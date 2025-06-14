    using KrishiSancharCore;
    using KrishiSancharCore.Helper;
    using KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;
    using KrishiSancharCore.ReservationFeatures;
    using KrishiSancharDataAccess.Data;
    using Microsoft.AspNetCore.Mvc;

    namespace KrishiSancharWeb.Controllers;
    [ApiController]
    [Route("api/order")]
    public class OrderApiController : ControllerBase
    {
        private readonly IUow _uow;
        private readonly CurrentUserHelper _currentUserHelper;
        private readonly AppDbContext _dbContext;

        public OrderApiController(IUow uow,CurrentUserHelper currentUserHelper,AppDbContext dbcontext)
        {
            _uow = uow;
            _currentUserHelper = currentUserHelper;
            _dbContext = dbcontext;
        }

       [HttpPost("preview")]
    public async Task<IActionResult> PreviewOrder([FromBody] List<ItemReserveRequest> cartItems)
    {
        if (cartItems == null || !cartItems.Any())
            return BadRequest("Cart is empty.");

        if (cartItems.Any(i => i.ProductId <= 0 || i.Quantity <= 0))
            return BadRequest("Invalid product ID or quantity.");

        var previewResponse = new OrderPreviewResponse();

        try
        {
            // Validate products and populate item.Product
            foreach (var item in cartItems)
            {
                var product = await _uow.Products.GetProductById(item.ProductId);
                if (product == null)
                    return BadRequest($"Product with ID {item.ProductId} not found.");

                product.Seller = await _uow.Users.GetUserById(product.SellerId);
                if (product.Seller == null)
                    return BadRequest($"Seller not found for Product ID {item.ProductId}");

                if (item.Quantity > product.Stock)
                    return BadRequest($"Not enough stock for product {product.Name}. Available: {product.Stock}");

                item.Product = product;
            }

            // Reserve products after validation
            var reserveResult = await ReserveProducts(cartItems);
            if (reserveResult is BadRequestObjectResult || reserveResult is UnauthorizedResult)
                return reserveResult;

            // Group items for preview response
            var grouped = cartItems.GroupBy(i => i.Product.Seller.Id)
                .Select((g, index) => new KeyValuePair<string, Package>(
                    $"package{index + 1}",
                    new Package
                    {
                        SoldBy = g.First().Product.Seller.FullName,
                        Items = g.Select(i => new OrderPreviewItemResponse
                        {
                            ProductId = i.ProductId,
                            ProductName = i.Product.Name,
                            Quantity = i.Quantity,
                            SubTotalAmount = i.Product.DisplayPrice * i.Quantity
                        }).ToList(),
                        DeliveryCharge = 50
                    }
                ));

            previewResponse.Packages = grouped.ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

            return Ok(previewResponse);
        }
        catch (Exception ex)
        {
            return StatusCode(500, ex.Message);
        }
    }

    private async Task<IActionResult> ReserveProducts(List<ItemReserveRequest> cartItems)
    {
        if (cartItems == null || !cartItems.Any())
            return BadRequest("Cart is empty.");

        var userId = _currentUserHelper.GetUserId();
        if (userId == null)
            return Unauthorized();

        using var transaction = await _dbContext.Database.BeginTransactionAsync();

        try
        {
            foreach (var item in cartItems)
            {
                var product = item.Product; // Use already fetched product
                if (product == null)
                    return BadRequest($"Product {item.ProductId} not found.");

                if (item.Quantity > (product.Stock - product.Reserve))
                    return BadRequest($"Not enough stock for product {product.Name}");

                product.Reserve += item.Quantity;
                product.Stock -= item.Quantity;

                var reservation = new ReservationItemEntity
                {
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    UserId = userId.Value,
                    ReservedAt = DateTime.UtcNow,
                    ExpireAt = DateTime.UtcNow.AddMinutes(2),
                    IsCompleted = false
                };

                await _dbContext.ReservationItems.AddAsync(reservation);
            }

            await _uow.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok("Products reserved for 2 minutes.");
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, ex.Message);
        }
    }

    }
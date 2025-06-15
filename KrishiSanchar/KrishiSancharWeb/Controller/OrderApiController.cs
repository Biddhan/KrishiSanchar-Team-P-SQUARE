using KrishiSancharCore;
using KrishiSancharCore.Helper;
using KrishiSancharCore.LedgerFeatures;
using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;
using KrishiSancharCore.OrderFeature.OrderEnums;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharCore.ReservationFeatures;
using KrishiSancharDataAccess.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;

namespace KrishiSancharWeb.Controllers;

[ApiController]
[Route("api/order")]
public class OrderApiController : ControllerBase
{
    private readonly IUow _uow;
    private readonly CurrentUserHelper _currentUserHelper;
    private readonly AppDbContext _dbContext;
    private readonly IMemoryCache _cache;

    public OrderApiController(IUow uow, CurrentUserHelper currentUserHelper, AppDbContext dbcontext, IMemoryCache cache)
    {
        _uow = uow;
        _currentUserHelper = currentUserHelper;
        _dbContext = dbcontext;
        _cache = cache;
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
            var userId = _currentUserHelper.GetUserId();
            if (userId == null)
                return Unauthorized();

            var user = await _uow.Users.GetUserById(userId.Value);
            if (user == null)
                return NotFound("User not found.");

            previewResponse.DeliveryAddress = user.Address;

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

            // Group items by seller
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
                            SubTotalAmount = i.Product.DisplayPrice * i.Quantity,
                            SubNetTotalAmount = i.Product.UnitPrice * i.Quantity,
                        }).ToList(),
                        DeliveryCharge = 50
                    }
                ));

            previewResponse.Packages = grouped.ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
            var token = Guid.NewGuid().ToString();
            previewResponse.Token = token;
            _cache.Set(token, previewResponse, TimeSpan.FromMinutes(15));

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

    [HttpPost("placeorder")]
    public async Task<IActionResult> PlaceOrder([FromBody] OrderPlaceRequestDto request)
    {
        if (string.IsNullOrWhiteSpace(request.Token))
            return BadRequest("Missing preview token.");

        var preview = _cache.Get<OrderPreviewResponse>(request.Token);
        if (preview == null)
            return BadRequest("Order session expired.");

        var userId = _currentUserHelper.GetUserId();
        if (userId == null)
            return Unauthorized();

        var order = new OrderEntity
        {
            BuyerId = userId.Value,
            DeliveryAddress = request.DeliveryAddress,
            TotalGrossAmount = preview.GrandTotalAmount,
            OrderItems = preview.Packages
                .SelectMany(p => p.Value.Items.Select(i => new OrderItemEntity
                {
                    ProductId = i.ProductId,
                    Quantity = i.Quantity,
                    TotalPrice = i.SubTotalAmount
                }))
                .ToList()
        };

        await _uow.Orders.CreateOrder(order);
        await _uow.SaveChangesAsync();
        _cache.Remove(request.Token);

        return Ok(new
        {
            orderId = order.Id,
            message = "Order placed successfully. Please proceed with payment.",
        });
    }

    [HttpPost("pay")]
public async Task<IActionResult> AddPayment([FromBody] PaymentCreateDto dto)
{
    var order = await _uow.Orders.GetOrderById(dto.OrderId);
    if (order == null)
        return NotFound("Order not found.");

    var payment = new PaymentEntity
    {
        Amount = dto.Amount,
        OrderId = dto.OrderId,
        PaymentMethod = dto.Method ?? "Esewa"
    };

    await _uow.Payments.CreatePayment(payment);
    await _uow.SaveChangesAsync();

    // Assuming systemAccountId is known or fetched
    int systemAccountId = 1; 
    var systemAccount = await _uow.Users.GetUserById(systemAccountId);

    var ledger = new LedgerEntity
    {
        CreditorId = systemAccountId,
        CreditorUser = systemAccount,
        Creditor = systemAccount.FullName,  // snapshot
        DebtorId = order.BuyerId,
        DebtorUser = order.Buyer,
        Debtor = order.Buyer.FullName,       // snapshot
        Amount = dto.Amount,
        OrderId = dto.OrderId
    };


    await _uow.Ledgers.CreateLedger(ledger);
    await _uow.SaveChangesAsync(); // Save before looping

    var sellerGroups = order.OrderItems.GroupBy(item => item.Product.SellerId);

    foreach (var group in sellerGroups)
    {
        var sellerId = group.Key;
        var seller = await _uow.Users.GetUserById(sellerId);
        if (seller == null) continue;

        var sellerAmount = group.Sum(item => item.Quantity * item.Product.UnitPrice);

        var sellerLedger = new LedgerEntity
        {
            CreditorId = sellerId,
            CreditorUser = seller,
            Creditor = seller.FullName, // or seller.Name or whatever field holds "Roman Khatri"
            DebtorId = systemAccountId,
            DebtorUser = systemAccount,
            Debtor = systemAccount.FullName, // same here
            Amount = sellerAmount,
            OrderId = dto.OrderId
        };


        await _uow.Ledgers.CreateLedger(sellerLedger);
        await _uow.SaveChangesAsync();
    }

    

    var totalPaid = await _uow.Payments.GetTotalPaidForOrder(order.Id);
    var isFullyPaid = totalPaid >= order.TotalGrossAmount;

    if (isFullyPaid)
    {
        order.OrderStatus = OrderStatusEnum.Payed;
        await _uow.Orders.UpdateOrder(order);
        await _uow.SaveChangesAsync();
    }

    return Ok(new { message = "Payment recorded successfully." });
}


}
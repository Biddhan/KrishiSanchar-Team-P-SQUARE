using KrishiSancharCore;
using KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;
using KrishiSancharCore.ReservationFeatures;
using Microsoft.AspNetCore.Mvc;

namespace KrishiSancharWeb.Controllers;
[ApiController]
[Route("api/order")]
public class OrderApiController : ControllerBase
{
    private readonly IUow _uow;

    public OrderApiController(IUow uow)
    {
        _uow = uow;
    }

    [HttpPost("preview")]
    public async Task<ActionResult<OrderPreviewResponse>> PreviewOrder([FromBody] List<ItemReserveRequest> cartItems)
    {
        // Validate input
        if (cartItems == null || !cartItems.Any())
            return BadRequest("Cart is empty.");

        if (cartItems.Any(i => i.ProductId <= 0 || i.Quantity <= 0))
            return BadRequest("Invalid product ID or quantity.");

        var previewResponse = new OrderPreviewResponse();

        try
        {
            foreach (var item in cartItems)
            {
                var product = await _uow.Products.GetProductById(item.ProductId);
                if (product == null)
                    return BadRequest($"Product with ID {item.ProductId} not found.");

                product.Seller = await _uow.Users.GetUserById(product.SellerId);
                if (product.Seller == null)
                    return BadRequest($"Seller not found for Product ID {item.ProductId}.");

                item.Product = product;

            }

            var grouped = cartItems.GroupBy(i => i.Product.Seller.Id) // Group by int Seller.Id
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
            // Log the error (use a logging framework like Serilog)
            return StatusCode(500, ex.Message);
        }
    }
}
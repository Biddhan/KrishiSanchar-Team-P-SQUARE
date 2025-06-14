using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using KrishiSancharCore.ProductFeatures;

namespace KrishiSancharCore.ReservationFeatures;

public class ItemReserveRequest
{
    public int Quantity { get; set; }
    public int ProductId { get; set; }
    [ValidateNever]
    public ProductEntity Product { get; set; }
}
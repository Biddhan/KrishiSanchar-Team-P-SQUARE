using KrishiSancharCore.ProductFeatures;

namespace KrishiSancharCore.OrderFeature;

public class OrderItemEntity
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public virtual ProductEntity Product { get; set; }
    public int Quantity { get; set; }
    public decimal TotalPrice { get; set; }
}
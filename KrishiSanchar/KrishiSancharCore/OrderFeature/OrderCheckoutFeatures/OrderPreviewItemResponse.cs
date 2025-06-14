namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class OrderPreviewItemResponse
{
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public decimal Quantity { get; set; }
    public decimal SubTotalAmount { get; set; }
}
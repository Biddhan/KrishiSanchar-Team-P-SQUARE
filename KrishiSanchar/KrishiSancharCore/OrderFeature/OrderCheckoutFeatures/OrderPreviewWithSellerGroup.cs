namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class OrderPreviewWithSellerGroup
{
    public int SellerId { get; set; } // Changed to int
    public List<OrderPreviewItemResponse> Items { get; set; } = new();
    public decimal DeliveryCharge { get; set; }
    public decimal SellerTotal => Items.Sum(i => i.SubTotalAmount) + DeliveryCharge;
}
namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class Package
{
    public string SoldBy { get; set; }
    public List<OrderPreviewItemResponse> Items { get; set; } = new();
    public decimal DeliveryCharge { get; set; }
    public decimal PackageTotal => Items.Sum(i => i.SubTotalAmount) + DeliveryCharge;
}
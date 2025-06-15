namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class OrderPreviewResponse
{
    public string Token { get; set; } = string.Empty;
    public Dictionary<string, Package> Packages { get; set; } = new Dictionary<string, Package>();
    public decimal GrandTotalAmount => Packages.Values.Sum(g => g.PackageTotal);
    public string DeliveryAddress { get; set; } = "Birtamode";
}
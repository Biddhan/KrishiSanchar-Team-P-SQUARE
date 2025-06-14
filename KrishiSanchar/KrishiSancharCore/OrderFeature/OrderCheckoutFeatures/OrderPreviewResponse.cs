namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class OrderPreviewResponse
{
    public Dictionary<string, Package> Packages { get; set; } = new Dictionary<string, Package>();
    public decimal GrandTotalAmount => Packages.Values.Sum(g => g.PackageTotal);
}
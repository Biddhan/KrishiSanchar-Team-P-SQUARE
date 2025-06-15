namespace KrishiSancharCore.InsuranceFeatures;

public class InsuranceProductEntity
{
    public int Id { get; set; }
    public int ProviderId { get; set; }
    public InsuranceProviderEntity Provider { get; set; }

    public string Name { get; set; } // e.g., "Livestock Basic Plan"
    public string Category { get; set; } // "Livestock", "Crops", "Equipment", etc.
    public string Description { get; set; }
}

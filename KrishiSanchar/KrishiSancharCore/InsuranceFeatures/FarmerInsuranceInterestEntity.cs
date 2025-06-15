using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore.InsuranceFeatures;

public class FarmerInsuranceInterestEntity
{
    public int Id { get; set; }
    public int FarmerId { get; set; }
    public UserEntity Farmer { get; set; }

    public int InsuranceProductId { get; set; }
    public InsuranceProductEntity InsuranceProduct { get; set; }

    public DateTime SubmittedAt { get; set; } = DateTime.UtcNow;
}

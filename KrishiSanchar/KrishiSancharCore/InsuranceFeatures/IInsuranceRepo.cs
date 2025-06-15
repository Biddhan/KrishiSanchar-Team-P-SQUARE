namespace KrishiSancharCore.InsuranceFeatures;

public interface IInsuranceRepo
{
    Task<List<InsuranceProviderEntity>> GetAllProvidersAsync();
    Task<List<InsuranceProductEntity>> GetProductsByProviderIdAsync(int providerId);
    Task<List<InsuranceProductEntity>> GetAllProductsAsync();
    Task CreateInterestAsync(FarmerInsuranceInterestEntity interest);
    Task<FarmerInsuranceInterestEntity> GetInterestAsync(int userId,int productId);

}

using KrishiSancharCore.InsuranceFeatures;
using KrishiSancharDataAccess.Data;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Repository;

public class InsuranceRepo : IInsuranceRepo
{
    private readonly AppDbContext _context;

    public InsuranceRepo(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<InsuranceProviderEntity>> GetAllProvidersAsync()
    {
        return await _context.InsuranceProviders.ToListAsync();
    }

    public async Task<List<InsuranceProductEntity>> GetProductsByProviderIdAsync(int providerId)
    {
        return await _context.InsuranceProducts
            .Where(p => p.ProviderId == providerId)
            .ToListAsync();
    }

    public async Task<List<InsuranceProductEntity>> GetAllProductsAsync()
    {
        return await _context.InsuranceProducts.ToListAsync();
    }

    public async Task CreateInterestAsync(FarmerInsuranceInterestEntity interest)
    {
        await _context.FarmerInsuranceInterests.AddAsync(interest);
    }

    public async Task<FarmerInsuranceInterestEntity> GetInterestAsync(int userId,int productId)
    {
        return await _context.FarmerInsuranceInterests.FirstOrDefaultAsync(i => i.FarmerId == userId && i.InsuranceProductId == productId);
    }
}

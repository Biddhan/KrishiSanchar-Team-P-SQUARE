using KrishiSancharCore.LedgerFeatures;
using KrishiSancharDataAccess.Data;

namespace KrishiSancharDataAccess.Repository;

public class LedgerRepo: ILedgerRepo
{
    private readonly AppDbContext _appDbContext;

    public LedgerRepo(AppDbContext appDbContext)
    {
        _appDbContext =appDbContext;
    }

    public async Task CreateLedger(LedgerEntity entity)
    {
       await _appDbContext.Ledgers.AddAsync(entity);
    }
}
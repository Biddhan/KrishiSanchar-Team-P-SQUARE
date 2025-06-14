using KrishiSancharCore;
using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.LedgerFeatures;
using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharCore.UserFeatures;
using KrishiSancharDataAccess.Converter;
using KrishiSancharDataAccess.Data;

namespace KrishiSancharDataAccess.Repository;

public class Uow : IUow
{
    private readonly AppDbContext _appDbContext;
    public ICategoryRepo Categories { get; private set; }
    public IOrderRepo Orders { get; private set; }
    public IProductRepo Products { get; private set; }
    public IUserRepo Users { get; private set; }
    public IPaymentRepo Payments { get; private set; }
    public ILedgerRepo Ledgers { get; private set; }
    public Uow(AppDbContext appDbContext)
    {
        _appDbContext = appDbContext;
        Categories = new CategoryRepo(_appDbContext);
        Orders = new OrderRepo(_appDbContext);
        Products = new ProductRepo(_appDbContext);
        Users = new UserRepo(_appDbContext);
        Payments = new PaymentRepo(_appDbContext);
        Ledgers = new LedgerRepo(_appDbContext);
    }

    public async Task BeginTransactionAsync() => await _appDbContext.Database.BeginTransactionAsync();
    public async Task CommitAsync() => await _appDbContext.Database.CommitTransactionAsync();
    public async Task RollbackAsync() => await _appDbContext.Database.RollbackTransactionAsync();
    public async Task SaveChangesAsync() => await _appDbContext.SaveChangesAsync();
}
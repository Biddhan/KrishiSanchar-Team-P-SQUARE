using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.LedgerFeatures;
using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore;

public interface IUow
{
    ICategoryRepo Categories { get; }
    IOrderRepo Orders { get; }
    IProductRepo Products { get; }
    IUserRepo Users { get; }
    IPaymentRepo Payments { get; }
    ILedgerRepo Ledgers { get; }
    Task SaveChangesAsync();
    
    Task BeginTransactionAsync();
    Task CommitAsync();
    Task RollbackAsync();

}
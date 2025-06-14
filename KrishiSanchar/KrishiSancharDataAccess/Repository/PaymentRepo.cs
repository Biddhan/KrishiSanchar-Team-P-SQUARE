using KrishiSancharCore.PaymentFeatures;
using KrishiSancharDataAccess.Data;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Repository;

public class PaymentRepo: IPaymentRepo
{
    private readonly AppDbContext _appDbContext;
    public PaymentRepo(AppDbContext appDbContext)
    {
        _appDbContext = appDbContext;
    }
    public async Task CreatePayment(PaymentEntity payment)
    {
       await _appDbContext.Payments.AddAsync(payment);
    }
    public async Task<decimal> GetTotalPaidForOrder(int orderId)
    {
        return await _appDbContext.Payments
            .Where(p => p.OrderId == orderId)
            .SumAsync(p => p.Amount);
    }

}
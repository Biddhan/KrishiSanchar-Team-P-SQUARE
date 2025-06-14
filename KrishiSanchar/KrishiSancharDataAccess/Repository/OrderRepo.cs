using KrishiSancharCore.OrderFeature;
using KrishiSancharDataAccess.Data;

namespace KrishiSancharDataAccess.Repository;

public class OrderRepo : IOrderRepo
{
    private readonly AppDbContext _appDbcontext;

    public OrderRepo(AppDbContext appDbContext)
    {
        _appDbcontext = appDbContext;
    }

    public async Task CreateOrder(OrderEntity order)
    {
        await _appDbcontext.Orders.AddAsync(order);
    }

    public async Task<OrderEntity> GetOrderById(int id)
    {
        return await _appDbcontext.Orders.FindAsync(id);
    }

    public Task UpdateOrder(OrderEntity order)
    {
        _appDbcontext.Orders.Update(order);
        return Task.CompletedTask; 
    }
}

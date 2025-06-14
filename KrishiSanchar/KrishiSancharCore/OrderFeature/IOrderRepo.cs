namespace KrishiSancharCore.OrderFeature;

public interface IOrderRepo
{
    Task CreateOrder(OrderEntity order);
    Task<OrderEntity> GetOrderById(int id);
    Task UpdateOrder(OrderEntity order);
}
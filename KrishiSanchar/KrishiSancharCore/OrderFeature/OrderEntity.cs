using KrishiSancharCore.LedgerFeatures;
using KrishiSancharCore.OrderFeature.OrderEnums;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore.OrderFeature;

public class OrderEntity
{
    public OrderEntity()
    {
        Guid = Guid.NewGuid();
        OrderStatus = OrderStatusEnum.Pending;
        CreatedDate = DateOnly.FromDateTime(DateTime.Now);
        CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
    }

    public OrderEntity(int Id, string Description, string OrderStatus, string DeliveryAddress):base()
    {
        this.Id = Id;
    }

    public int Id { get; protected set; }
    public Guid Guid { get; set; }
    public int BuyerId { get; set; }
    public UserEntity Buyer { get; set; }
    public DateOnly CreatedDate { get; set; }
    public TimeOnly CreatedTime { get; set; }
    public OrderStatusEnum OrderStatus { get; set; }
    public string DeliveryAddress  { get; set; }
    public decimal TotalGrossAmount { get; set; }
    
    public List<OrderItemEntity> OrderItems { get; set; }
    public List<LedgerEntity> Ledgers { get; set; }
    public List<PaymentEntity> Payments { get; set; }

    public void OrderPending()
    {
        OrderStatus = OrderStatusEnum.Pending;

    }
    
    public void OrderConfirmed()
    {
        OrderStatus = OrderStatusEnum.Confirmed;
    }
    
    public void OrderPayed()
    {
        OrderStatus = OrderStatusEnum.Payed;

    }

    public void OrderDelievered()
    {
        OrderStatus= OrderStatusEnum.Delivered;
    }

    public void OrderShipped()
    {
        OrderStatus = OrderStatusEnum.Shipped;

    }
    public void OrderCancelled()
    {
        OrderStatus = OrderStatusEnum.Cancelled;

    }
}
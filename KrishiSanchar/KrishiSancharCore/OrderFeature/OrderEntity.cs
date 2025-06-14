using KrishiSancharCore.OrderFeature.OrderEnums;

namespace KrishiSancharCore.OrderFeature;

public class OrderEntity
{
    public OrderEntity(string Description,int CustomerId, string DelieveryAddress)
    {
        Guid = Guid.NewGuid();
        this.Description = Description;
        OrderStatus = OrderStatusEnum.Pending;
        this.DelieveryAddress = DelieveryAddress;
        CreatedDate = DateOnly.FromDateTime(DateTime.Now);
        CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
    }

    public OrderEntity(int Id, string Description, int CustomerId, string OrderStatus, string DelieveryAddress):this(Description, CustomerId, DelieveryAddress)
    {
        this.Id = Id;
    }

    public int Id { get; protected set; }
    public Guid Guid { get; set; }
    public string Description { get; set; }
    // public ICollection<OrderItemEntity> OrderItems { get; set; } = new List<OrderItemEntity>();
    public DateOnly CreatedDate { get; set; }
    public TimeOnly CreatedTime { get; set; }
    public string OrderStatus { get; set; }
    public string DelieveryAddress  { get; set; }
    // public decimal FinalPrice => OrderItems.Sum(item => item.TotalPrice);

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
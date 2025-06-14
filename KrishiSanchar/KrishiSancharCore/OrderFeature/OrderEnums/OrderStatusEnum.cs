using KrishiSancharDataAccess.Converter;

namespace KrishiSancharCore.OrderFeature.OrderEnums;

public class OrderStatusEnum:Enumeration
{
    public static readonly OrderStatusEnum Pending    = new(1, nameof(Pending));
    public static readonly OrderStatusEnum Payed    = new(1, nameof(Payed));
    public static readonly OrderStatusEnum Confirmed  = new(2, nameof(Confirmed));
    public static readonly OrderStatusEnum Shipped    = new(3, nameof(Shipped));
    public static readonly OrderStatusEnum Delivered  = new(4, nameof(Delivered));
    public static readonly OrderStatusEnum Cancelled  = new(5, nameof(Cancelled));
    
    private OrderStatusEnum(int id, string name) : base(id, name)
    {
    }
}
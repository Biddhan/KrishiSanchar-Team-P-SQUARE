using KrishiSancharCore.OrderFeature.OrderEnums;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace KrishiSancharDataAccess.Converter;

public class OrderStatusEnumConverter
    : ValueConverter<OrderStatusEnum,string>
{
    public OrderStatusEnumConverter()
        : base(
            userStatus => userStatus.Name,
            name => Enumeration.GetAll<OrderStatusEnum>().FirstOrDefault(t => t.Name == name)        
        )
    { }
}
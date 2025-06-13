using KrishiSancharCore.ProductFeatures;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace KrishiSancharDataAccess.Converter;

public class ProductStatusEnumConverter : ValueConverter<ProductStatusEnum, string>
{
    public ProductStatusEnumConverter()
        : base(
            productStatus => productStatus.Name,
            name => Enumeration.GetAll<ProductStatusEnum>().FirstOrDefault(t => t.Name == name)
        )
    {
    }
}

using KrishiSancharDataAccess.Converter;

namespace KrishiSancharCore.ProductFeatures;

public class ProductStatusEnum : Enumeration
{
    public static readonly ProductStatusEnum Active = new ProductStatusEnum(1, "Active");
    public static readonly ProductStatusEnum InActive = new ProductStatusEnum(2, "InActive");

    private ProductStatusEnum(int id, string name) : base(id, name)
    {
    }
}

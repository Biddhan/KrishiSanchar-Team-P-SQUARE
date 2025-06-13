using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.ProductFeatures;

namespace KrishiSancharCore;

public interface IUow
{
    ICategoryRepo Categories { get; }
    // IOrderRepo Orders { get; }
    IProductRepo Products { get; }
    // IUserRepo Users { get; }
    Task SaveChangesAsync();

}
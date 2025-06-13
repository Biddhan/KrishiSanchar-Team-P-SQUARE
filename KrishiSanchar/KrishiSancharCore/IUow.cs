using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore;

public interface IUow
{
    ICategoryRepo Categories { get; }
    // IOrderRepo Orders { get; }
    IProductRepo Products { get; }
    IUserRepo Users { get; }
    Task SaveChangesAsync();

}
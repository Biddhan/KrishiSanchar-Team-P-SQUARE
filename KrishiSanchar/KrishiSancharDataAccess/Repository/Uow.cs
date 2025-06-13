using KrishiSancharCore;
using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Converter;
using KrishiSancharDataAccess.Data;

namespace KrishiSancharDataAccess.Repository;

public class Uow : IUow
{
    private readonly AppDbContext _appDbContext;
    public ICategoryRepo Categories { get; private set; }
    // public IOrderRepo Orders { get; private set; }
    public IProductRepo Products { get; private set; }
    // public IUserRepo Users { get; private set; }
    public Uow(AppDbContext appDbContext)
    {
        _appDbContext = appDbContext;
        Categories = new CategoryRepo(_appDbContext);
        // Orders = new OrderRepo(_appDbContext);
        Products = new ProductRepo(_appDbContext);
        // Users = new UserRepo(_appDbContext);
    }

    public async Task SaveChangesAsync()
    {
        await _appDbContext.SaveChangesAsync();
    }
}
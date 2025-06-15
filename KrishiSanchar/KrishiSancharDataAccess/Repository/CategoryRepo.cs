using KrishiSancharCore.CategoryFeatures;
using KrishiSancharDataAccess.Data;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Repository;

public class CategoryRepo : ICategoryRepo
{
    private AppDbContext _appDbContext;
    public CategoryRepo(AppDbContext appDbContext)
    {
        _appDbContext= appDbContext;
    }
    public async Task<IEnumerable<CategoryEntity>> GetAllCategories()
    {
        return await _appDbContext.Categories.Include(c => c.Products).ToListAsync();

    }
    public async Task<CategoryEntity> GetCategoryById(int id)
    {
        return await _appDbContext.Categories.FirstOrDefaultAsync(c=>c.Id==id);

    }
    public async Task Create(CategoryEntity entity)
    {
        _appDbContext.Categories.Add(entity);
        await _appDbContext.SaveChangesAsync(); 
    }             

    public async Task Update(CategoryEntity entity)
    {
        _appDbContext.Categories.Update(entity);
        await _appDbContext.SaveChangesAsync();
    }
    public async Task Delete(CategoryEntity entity)
    {
        _appDbContext.Categories.Remove(entity);
        await _appDbContext.SaveChangesAsync();
    }
}
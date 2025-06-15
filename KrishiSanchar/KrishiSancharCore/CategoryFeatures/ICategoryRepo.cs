namespace KrishiSancharCore.CategoryFeatures;

public interface ICategoryRepo
{
    Task<IEnumerable<CategoryEntity>> GetAllCategories();
    Task<CategoryEntity> GetCategoryById(int id);
    Task Create(CategoryEntity entity);
    Task Update(CategoryEntity entity);
    Task Delete(CategoryEntity entity);
}
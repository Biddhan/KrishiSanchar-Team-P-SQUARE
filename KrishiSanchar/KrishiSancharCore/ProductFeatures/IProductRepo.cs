namespace KrishiSancharCore.ProductFeatures;

public interface IProductRepo
{
    Task<IEnumerable<ProductEntity>> GetAllProducts();
    Task<ProductEntity> GetProductById(int id);
    Task Create(ProductEntity entity);
    Task Update(ProductEntity entity);
    Task Delete(ProductEntity entity);
}
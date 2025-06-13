using KrishiSancharDataAccess.Converter;

namespace KrishiSancharCore.ProductFeatures;

public class ProductService
{
    private readonly IProductRepo _productRepo;
    private readonly IUow _uow;
    public ProductService(IProductRepo productRepo,IUow uow)
    {
        _productRepo = productRepo;
        _uow = uow;
    }
    public async Task<IEnumerable<ProductEntity>> GetAllProducts()
    {
        return await _productRepo.GetAllProducts();
    }
    public async Task<ProductEntity> GetProductById(int id)
    {
        return await _productRepo.GetProductById(id);
    }
    public async Task CreateProduct(ProductCreateDto dto)
    {
        var entity = new ProductEntity(dto.Name, dto.Description, dto.ImageUrl, dto.CategoryId, dto.Stock,
            dto.UnitPrice);
        await _productRepo.Create(entity);
    }
    
    public async Task UpdateProduct(ProductEntity product, ProductUpdateDto dto)
    {
        product.Name = dto.Name;
        product.Description = dto.Description;
        product.ImageUrl = dto.ImageUrl;
        product.CategoryId = dto.CategoryId;
        product.Stock = dto.Stock;
        product.UnitPrice = dto.UnitPrice;
        product.UpdateTimestamp();
        await _productRepo.Update(product);
    }
    
    public async Task DeleteProduct(ProductEntity entity)
    {
        await _productRepo.Delete(entity);
    }

    public async Task ActivateProduct(ProductEntity entity)
    {
        entity.Activate();
        await _uow.Products.Update(entity);
    }
    
    public async Task DeactivateProduct(ProductEntity entity)
    {
        entity.Deactivate();
        await _uow.Products.Update(entity);
    }
    
    public async Task<List<ProductEntity>> SearchProducts(int categoryId, string query)
    {
        var products = await _uow.Products.GetAllProducts();

        return products
            .Where(p => p.CategoryId == categoryId &&
                        (p.Name.Contains(query, StringComparison.OrdinalIgnoreCase) ||
                         p.Description.Contains(query, StringComparison.OrdinalIgnoreCase)))
            .ToList();
    }



}
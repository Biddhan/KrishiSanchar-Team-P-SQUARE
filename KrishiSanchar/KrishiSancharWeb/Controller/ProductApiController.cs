using KrishiSancharCore;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Converter;
using KrishiSancharDataAccess.Converter.Utility;
using KrishiSancharWeb.ViewModel;
using Microsoft.AspNetCore.Mvc;

namespace KrishiSancharWeb.Controllers;

[Route("api/product")]
[ApiController]
public class ProductApiController: ControllerBase
{
    private readonly ProductService _productService;
    private readonly IUow _uow;
    private readonly CloudinaryService _cloudinaryService;
    private readonly ILogger<ProductApiController> _logger;

    public ProductApiController(ProductService productService, CloudinaryService cloudinaryService, ILogger<ProductApiController> logger, IUow uow)
    {
        _productService = productService;
        _cloudinaryService = cloudinaryService;
        _logger = logger;
        _uow = uow;
    }
    
    [HttpGet]
    public async Task<IActionResult> GetProducts()
    {
        var list = await _productService.GetAllProducts();
        return Ok(list);
    }
    
    [HttpGet("{id}")]
    public async Task<IActionResult> GetProductById(int id)
    {
        var product = await _productService.GetProductById(id);
        return Ok(product);
    }
    
    [HttpPost]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> CreateProduct([FromForm] ProductCreateViewModel vm)
    {
        if (vm.Image == null || vm.Image.Length == 0)
        {
            return BadRequest("Image is required");
        }
        var dto = new ProductCreateDto
        {
            Name = vm.Name,
            Description = vm.Description,
            CategoryId = vm.CategoryId,
            Stock = vm.Stock,
            UnitPrice = vm.UnitPrice
        };      

        try
        {
            dto.ImageUrl = await _cloudinaryService.UploadImageAsync(vm.Image);
            await _productService.CreateProduct(dto);
            return Ok(new { Message = "Created" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error creating product controller: {ex.Message}");
        }

    }

    [HttpPut]
    public async Task<IActionResult> UpdateProduct(int id, ProductUpdateViewModel vm)
    {
        var product = await _productService.GetProductById(id);
        if(product==null) throw new Exception("Product with id:{id} not found");
        var category = await _uow.Categories.GetCategoryById(id);
        if(category==null) throw new Exception("Category with id:{id} not found");
        var dto = new ProductUpdateDto
        {
            Name = vm.Name,
            Description = vm.Description,
            Stock = vm.Stock,
            Reserve = vm.Reserve,
            ImageUrl = vm.ImageUrl
        };
        await _productService.UpdateProduct(product,dto);
        return Ok();
    }
    
    
    [HttpPost("{id}/activate")]
    public async Task<IActionResult> ActivateProduct(int id)
    {
        var product = await _productService.GetProductById(id);
        if(product == null) throw new Exception($"Product with id:{id} not found");
        await _productService.ActivateProduct(product);
        return Ok();
    }
    
    [HttpPost("{id}/deactivate")]
    public async Task<IActionResult> DeactivateProduct(int id)
    {
        var product = await _productService.GetProductById(id);
        if(product == null) throw new Exception($"Product with id:{id} not found");
        await _productService.DeactivateProduct(product);
        return Ok();
    }
    
    [HttpGet("search")]
    public async Task<IActionResult> SearchProducts([FromQuery] int categoryId, [FromQuery] string query)
    {
        var results = await _productService.SearchProducts(categoryId, query);
        if(results==null) throw new Exception("Search result is null");
        return Ok(results);
    }

}
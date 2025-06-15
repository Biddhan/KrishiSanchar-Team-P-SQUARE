namespace KrishiSancharCore.ProductFeatures;

public class ProductUpdateDto: ProductCreateDto
{
    public int Id { get; set; }
    public int? Reserve { get; set; }
}
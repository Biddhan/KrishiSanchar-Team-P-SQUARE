namespace KrishiSancharWeb.ViewModel;

public class ProductUpdateViewModel
{
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal UnitPrice { get; set; }
    public int Stock { get; set; }
    public int CategoryId { get; set; }
    public int? Reserve { get; set; }
    public string ImageUrl { get; set; }
}
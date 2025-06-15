using System.ComponentModel.DataAnnotations;

namespace KrishiSancharWeb.ViewModel;

public class ProductCreateViewModel
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
    public string Name { get; set; }
     
    [Required(ErrorMessage = "Description is required")]
    [StringLength(500, ErrorMessage = "Description cannot exceed 500 characters")]
    public string Description { get; set; }        
     
    [Required(ErrorMessage = "Category ID is required")]
    [Range(1, int.MaxValue, ErrorMessage = "Category ID must be a positive integer")]
    public int CategoryId { get; set; }
     
    [Required(ErrorMessage = "Quantity is required")]
    [Range(0, int.MaxValue, ErrorMessage = "Quantity cannot be negative")]
    public int Stock { get; set; }
     
    [Required(ErrorMessage = "Price is required")]
    [Range(0, int.MaxValue, ErrorMessage = "Price cannot be negative")]
    public int UnitPrice { get; set; }
    
    public int SellerId { get; set; }
     
    public IFormFile Image { get; set; }
}
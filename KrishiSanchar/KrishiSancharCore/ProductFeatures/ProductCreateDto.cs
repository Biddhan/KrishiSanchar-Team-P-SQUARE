﻿namespace KrishiSancharCore.ProductFeatures;

public class ProductCreateDto
{
    public string Name { get; set; }
    public string Description { get; set; }
    public int SellerId { get; set; }
    public string ImageUrl { get; set; }
    public int CategoryId { get; set; }
    public int Stock { get; set; }
    public decimal UnitPrice { get; set; }
    
}
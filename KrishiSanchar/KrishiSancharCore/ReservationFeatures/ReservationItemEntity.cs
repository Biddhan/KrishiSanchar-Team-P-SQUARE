using KrishiSancharCore.ProductFeatures;

namespace KrishiSancharCore.ReservationFeatures;

public class ReservationItemEntity
{
    public int Id { get; set; }
    public int UserId { get; set; } 
    public int ProductId { get; set; }
    public ProductEntity Product { get; set; }
    public int Quantity { get; set; }
    public DateTime ReservedAt { get; set; } = DateTime.Now;
    public DateTime  ExpireAt { get; set; } = DateTime.Now.AddMinutes(1);
    public bool IsCompleted { get; set; }
}
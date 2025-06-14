using KrishiSancharCore.OrderFeature;

namespace KrishiSancharCore.PaymentFeatures;

public class PaymentEntity
{
    public PaymentEntity()
    {
        CreatedDate = DateOnly.FromDateTime(DateTime.Now);
        CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
    }
    public int Id { get; set; }
    public string PaymentMethod { get; set; } = "Cash";
    public decimal Amount { get; set; }
    public DateOnly CreatedDate { get; set; }
    public TimeOnly CreatedTime { get; set; }
    public int OrderId { get; set; }
    public OrderEntity Order { get; set; }
}
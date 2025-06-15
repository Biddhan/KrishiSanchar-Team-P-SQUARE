namespace KrishiSancharCore.PaymentFeatures;

public class PaymentCreateDto
{
    public int OrderId { get; set; }
    public decimal Amount { get; set; }
    public string Method { get; set; } = "Cash";
}
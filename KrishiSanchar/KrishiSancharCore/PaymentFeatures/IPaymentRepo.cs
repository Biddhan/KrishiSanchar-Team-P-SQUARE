namespace KrishiSancharCore.PaymentFeatures;

public interface IPaymentRepo
{
    Task CreatePayment(PaymentEntity payment);
    Task<decimal> GetTotalPaidForOrder(int orderId);

}
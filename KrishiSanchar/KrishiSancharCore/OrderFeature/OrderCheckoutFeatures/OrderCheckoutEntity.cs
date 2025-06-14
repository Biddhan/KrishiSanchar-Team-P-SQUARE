using KrishiSancharCore.ReservationFeatures;

namespace KrishiSancharCore.OrderFeature.OrderCheckoutFeatures;

public class OrderCheckoutEntity
{
    public OrderCheckoutEntity(int buyerId, List<ItemReserveRequest> itemReserveRequests)
    {
        BuyerId = buyerId;
        ItemReserveRequests = itemReserveRequests;
        CalculateTotalAmount();
    }
    
    public int Id { get; set; }
    public int BuyerId { get; set; }
    public List<ItemReserveRequest> ItemReserveRequests { get; set; }
    public decimal TotalAmount { get; set; }

    public void CalculateTotalAmount()
    {
        TotalAmount = ItemReserveRequests.Sum(item => item.Quantity * item.Product.DisplayPrice);
    }
}

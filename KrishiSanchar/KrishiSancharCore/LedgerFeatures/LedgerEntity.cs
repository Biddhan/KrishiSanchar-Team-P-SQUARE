using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore.LedgerFeatures;

public class LedgerEntity
{
    public int Id { get; set; }
    public int DebtorId { get; set; }
    public UserEntity DebtorUser { get; set; }
    public string Debtor { get; set; }
    
    public int CreditorId { get; set; }
    public UserEntity CreditorUser { get; set; }
    public string Creditor { get; set; }
    public decimal Amount { get; set; }
    public int OrderId { get; set; }
}
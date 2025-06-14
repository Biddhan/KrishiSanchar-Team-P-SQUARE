namespace KrishiSancharCore.LedgerFeatures;

public class LedgerEntity
{
    public int Id { get; set; }
    public string Debtor { get; set; }
    public string Creditor { get; set; }
    public decimal Amount { get; set; }
}
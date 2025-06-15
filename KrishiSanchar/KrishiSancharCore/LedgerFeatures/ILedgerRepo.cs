namespace KrishiSancharCore.LedgerFeatures;

public interface ILedgerRepo
{
    Task CreateLedger(LedgerEntity entity);
}
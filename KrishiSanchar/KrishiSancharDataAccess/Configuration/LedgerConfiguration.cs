using KrishiSancharCore.LedgerFeatures;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class LedgerConfiguration : IEntityTypeConfiguration<LedgerEntity>
{
    public void Configure(EntityTypeBuilder<LedgerEntity> builder)
    {
        builder.ToTable("Ledgers");

        builder.HasKey(l => l.Id);

        builder.Property(l => l.Id)
            .HasColumnName("id")
            .ValueGeneratedOnAdd();

        builder.Property(l => l.Amount)
            .HasColumnName("amount")
            .IsRequired()
            .HasColumnType("decimal(18,2)");

        // Debtor
        builder.Property(l => l.DebtorId)
            .HasColumnName("debtor_id")
            .IsRequired();

        builder.HasOne(l => l.DebtorUser)
            .WithMany()
            .HasForeignKey(l => l.DebtorId)
            .OnDelete(DeleteBehavior.Restrict);

        // Creditor
        builder.Property(l => l.CreditorId)
            .HasColumnName("creditor_id")
            .IsRequired();

        builder.HasOne(l => l.CreditorUser)
            .WithMany()
            .HasForeignKey(l => l.CreditorId)
            .OnDelete(DeleteBehavior.Restrict);

        // OrderId (if needed)
        builder.Property(l => l.OrderId)
            .HasColumnName("order_id")
            .IsRequired();
    }
}
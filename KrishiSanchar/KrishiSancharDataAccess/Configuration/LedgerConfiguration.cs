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

        builder.Property(l => l.Debtor)
            .HasColumnName("debtor")
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(l => l.Creditor)
            .HasColumnName("creditor")
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(l => l.Amount)
            .HasColumnName("amount")
            .IsRequired()
            .HasColumnType("decimal(18,2)");
    }
}
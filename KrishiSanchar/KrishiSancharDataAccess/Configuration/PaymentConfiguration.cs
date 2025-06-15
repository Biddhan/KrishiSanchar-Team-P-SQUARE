using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharDataAccess.Converter;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class PaymentConfiguration : IEntityTypeConfiguration<PaymentEntity>
{
    public void Configure(EntityTypeBuilder<PaymentEntity> builder)
    {
        builder.ToTable("Payments");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Id)
            .HasColumnName("id")
            .ValueGeneratedOnAdd();

        builder.Property(p => p.PaymentMethod)
            .HasColumnName("payment_method")
            .IsRequired()
            .HasMaxLength(50)
            .HasDefaultValue("Cash");

        builder.Property(p => p.Amount)
            .HasColumnName("amount")
            .IsRequired()
            .HasColumnType("decimal(18,2)");

        builder.Property(p => p.CreatedDate)
            .HasColumnName("created_date")
            .HasConversion(new DateOnlyConverter())
            .IsRequired();

        builder.Property(p => p.CreatedTime)
            .HasColumnName("created_time")
            .HasConversion(new TimeOnlyConverter())
            .IsRequired();

        builder.Property(p => p.OrderId)
            .HasColumnName("order_id")
            .IsRequired();

      
    }
}
using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.OrderFeature.OrderEnums;
using KrishiSancharDataAccess.Converter;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class OrderConfiguration : IEntityTypeConfiguration<OrderEntity>
{
    public void Configure(EntityTypeBuilder<OrderEntity> builder)
    {
        builder.ToTable("Orders");

        builder.HasKey(o => o.Id);

        builder.Property(o => o.Id)
            .HasColumnName("id")
            .ValueGeneratedOnAdd();

        builder.Property(o => o.Guid)
            .HasColumnName("guid")
            .IsRequired();

        builder.Property(o => o.BuyerId)
            .HasColumnName("buyer_id")
            .IsRequired();
        
        builder.HasOne(o => o.Buyer)
            .WithMany()
            .HasForeignKey(o => o.BuyerId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.Property(o => o.CreatedDate)
            .HasColumnName("created_date")
            .HasConversion(new DateOnlyConverter())
            .IsRequired();

        builder.Property(o => o.CreatedTime)
            .HasColumnName("created_time")
            .HasConversion(new TimeOnlyConverter())
            .IsRequired();

        builder.Property(o => o.OrderStatus)
            .HasColumnName("order_status")
            .IsRequired()
            .HasConversion(new OrderStatusEnumConverter())
            .HasMaxLength(50); 

        builder.Property(o => o.DeliveryAddress)
            .HasColumnName("delivery_address")
            .HasMaxLength(255);

        builder.Property(o => o.TotalGrossAmount)
            .HasColumnName("total_gross_amount")
            .HasPrecision(18, 2);

        builder.HasMany(o => o.OrderItems)
            .WithOne()
            .HasForeignKey("OrderId") 
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(o => o.Ledgers)
            .WithOne()
            .HasForeignKey("OrderId")
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(o => o.Payments)
            .WithOne(p => p.Order) 
            .HasForeignKey(p => p.OrderId)
            .OnDelete(DeleteBehavior.Cascade);

    }
}
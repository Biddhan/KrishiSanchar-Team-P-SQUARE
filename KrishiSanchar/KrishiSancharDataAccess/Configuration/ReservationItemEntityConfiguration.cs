using KrishiSancharCore.ReservationFeatures;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class ReservationItemEntityConfiguration : IEntityTypeConfiguration<ReservationItemEntity>
{
    public void Configure(EntityTypeBuilder<ReservationItemEntity> builder)
    {
        builder.HasKey(r => r.Id);

        builder.Property(r => r.UserId)
            .IsRequired();

        builder.Property(r => r.ProductId)
            .IsRequired();

        builder.Property(r => r.Quantity)
            .IsRequired();

        builder.Property(r => r.ReservedAt)
            .IsRequired();

        builder.Property(r => r.ExpireAt)
            .IsRequired();

        builder.Property(r => r.IsCompleted)
            .HasDefaultValue(false);

        builder.HasOne(r => r.Product)
            .WithMany() 
            .HasForeignKey(r => r.ProductId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
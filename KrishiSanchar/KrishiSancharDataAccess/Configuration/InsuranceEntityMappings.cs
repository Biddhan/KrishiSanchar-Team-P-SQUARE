using KrishiSancharCore.InsuranceFeatures;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class InsuranceProviderEntityMapping : IEntityTypeConfiguration<InsuranceProviderEntity>
{
    public void Configure(EntityTypeBuilder<InsuranceProviderEntity> builder)
    {
        builder.ToTable("InsuranceProviders");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Name)
               .IsRequired()
               .HasMaxLength(100);

        builder.Property(p => p.ContactInfo)
               .HasMaxLength(200);

        builder.Property(p => p.WebsiteUrl)
               .HasMaxLength(200);
    }
}

public class InsuranceProductEntityMapping : IEntityTypeConfiguration<InsuranceProductEntity>
{
    public void Configure(EntityTypeBuilder<InsuranceProductEntity> builder)
    {
        builder.ToTable("InsuranceProducts");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Name)
               .IsRequired()
               .HasMaxLength(150);

        builder.Property(p => p.Category)
               .IsRequired()
               .HasMaxLength(50);

        builder.Property(p => p.Description)
               .HasMaxLength(500);

        builder.HasOne(p => p.Provider)
               .WithMany() // Add navigation property if needed
               .HasForeignKey(p => p.ProviderId)
               .OnDelete(DeleteBehavior.Cascade);
    }
}

public class FarmerInsuranceInterestEntityMapping : IEntityTypeConfiguration<FarmerInsuranceInterestEntity>
{
    public void Configure(EntityTypeBuilder<FarmerInsuranceInterestEntity> builder)
    {
        builder.ToTable("FarmerInsuranceInterests");

        builder.HasKey(p => p.Id);

        builder.HasOne(p => p.Farmer)
               .WithMany() // Add .WithMany(f => f.InsuranceInterests) if reverse nav exists
               .HasForeignKey(p => p.FarmerId)
               .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(p => p.InsuranceProduct)
               .WithMany()
               .HasForeignKey(p => p.InsuranceProductId)
               .OnDelete(DeleteBehavior.Cascade);

        builder.Property(p => p.SubmittedAt)
               .IsRequired();
    }
}
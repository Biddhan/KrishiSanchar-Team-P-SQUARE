using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Converter;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration
{
    public class ProductConfiguration : IEntityTypeConfiguration<ProductEntity>
    {
        public void Configure(EntityTypeBuilder<ProductEntity> builder)
        {
            builder.ToTable("Products");

            builder.HasKey(p => p.Id);

            builder.Property(p => p.Id)
                .HasColumnName("id")
                .ValueGeneratedOnAdd();

            builder.Property(p => p.Guid)
                .HasColumnName("guid")
                .IsRequired();

            builder.Property(p => p.Name)
                .HasColumnName("name")
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(p => p.Description)
                .HasColumnName("description")
                .HasMaxLength(1000);

            builder.Property(p => p.ImageUrl)
                .HasColumnName("image_url")
                .HasMaxLength(255);

            builder.Property(p => p.Stock)
                .HasColumnName("stock")
                .IsRequired();

            builder.Property(p => p.Reserve)
                .HasColumnName("reserve")
                .IsRequired(false);

            builder.Property(p => p.UnitPrice)
                .HasColumnName("unit_price")
                .IsRequired()
                .HasPrecision(10, 2);

            builder.Property(p => p.DisplayPrice)
                .HasColumnName("display_price")
                .HasPrecision(10, 2);

            builder.Property(p => p.Status)
                .HasColumnName("status")
                .HasMaxLength(20)
                .HasConversion(new ProductStatusEnumConverter());

            builder.Property(p => p.CreatedDate)
                .HasColumnName("created_date")
                .HasColumnType("date")
                .HasConversion(new DateOnlyConverter());

            builder.Property(p => p.CreatedTime)
                .HasColumnName("created_time")
                .HasColumnType("time")
                .HasConversion(new TimeOnlyConverter());

            builder.Property(p => p.UpdatedDate)
                .HasColumnName("updated_date")
                .HasColumnType("date")
                .HasConversion(new DateOnlyConverter());

            builder.Property(p => p.UpdatedTime)
                .HasColumnName("updated_time")
                .HasColumnType("time")
                .HasConversion(new TimeOnlyConverter());

            builder.Property(p => p.CategoryId)
                .HasColumnName("category_id")
                .IsRequired();
        }
    }
}

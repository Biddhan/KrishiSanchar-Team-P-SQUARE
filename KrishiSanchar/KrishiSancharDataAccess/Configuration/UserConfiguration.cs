using KrishiSancharCore.UserFeatures;
using KrishiSancharDataAccess.Converter;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace KrishiSancharDataAccess.Configuration;

public class UserConfiguration : IEntityTypeConfiguration<UserEntity>
    {
        public void Configure(EntityTypeBuilder<UserEntity> builder)
        {
            builder.ToTable("users");

            builder.HasKey(x => x.Id);

            builder.Property(x => x.Id)
                .IsRequired()
                .ValueGeneratedOnAdd()
                .HasColumnType("int")
                .HasColumnName("user_id");

            builder.Property(x => x.FullName)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnType("nvarchar(50)")
                .HasColumnName("full_name");

            builder.Property(x => x.UserName)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnType("nvarchar(50)")
                .HasColumnName("username");

            builder.Property(x => x.PasswordHash)
                .IsRequired()
                .HasMaxLength(255)
                .HasColumnType("nvarchar(255)")
                .HasColumnName("password_hash");

            builder.Property(x => x.Email)
                .HasMaxLength(100)
                .HasColumnType("nvarchar(100)")
                .HasColumnName("email");

            builder.Property(x => x.PhoneNumber)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnType("nvarchar(20)")
                .HasColumnName("phone_number");

            builder.Property(x => x.Address)
                .IsRequired()
                .HasMaxLength(300)
                .HasColumnType("nvarchar(300)")
                .HasColumnName("address");

            builder.Property(x => x.CreatedDate)
                .IsRequired()
                .HasColumnType("date")
                .HasColumnName("created_date")
                .HasConversion(new DateOnlyConverter());

            builder.Property(x => x.CreatedTime)
                .IsRequired()
                .HasColumnType("time")
                .HasColumnName("created_time")
                .HasConversion(new TimeOnlyConverter());

            builder.Property(x => x.UpdatedDate)
                .HasColumnType("date")
                .HasColumnName("updated_date")
                .HasConversion(new DateOnlyConverter());

            builder.Property(x => x.UpdatedTime)
                .HasColumnType("time")
                .HasColumnName("updated_time")
                .HasConversion(new TimeOnlyConverter());

            builder.Property(x => x.Token)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnType("nvarchar(100)")
                .HasColumnName("token");

            builder.Property(x => x.IsVerified)
                .IsRequired()
                .HasColumnType("bit")
                .HasColumnName("is_verified");

            builder.Property(x => x.Status)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnType("nvarchar(20)")
                .HasConversion(new UserStatusEnumConverter())
                .HasColumnName("status");
            
            builder.Property(x => x.Role)
                .IsRequired()
                .HasMaxLength(20)
                .HasColumnType("nvarchar(8)")
                .HasConversion(new UserRoleEnumConverter())
                .HasColumnName("role");

            builder.HasIndex(x => x.Email)
                .IsUnique();

            builder.HasIndex(x => x.PhoneNumber)
                .IsUnique();

            builder.HasIndex(x => x.FullName);
        }
    }
using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Configuration;
using KrishiSancharDataAccess.Seeder;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Data;

public class AppDbContext: DbContext
{
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        
        public DbSet<CategoryEntity> Categories { get; set; }
        public DbSet<ProductEntity> Products { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.ApplyConfiguration(new CategoryConfiguration());
            modelBuilder.ApplyConfiguration(new ProductConfiguration());
            new AppSeeder(modelBuilder);
            // modelBuilder.ApplyConfiguration(new UserConfiguration());
            
            
            // modelBuilder.Entity<UserEntity>().HasData(
            //     new UserEntity(
            //         id: 1,
            //         fullname: "Roman Khatri",
            //         username: "admin1",
            //         passwordHash: BCrypt.Net.BCrypt.HashPassword("Secret123"), // Use a secure hash
            //         email: "romanforgit@gmail.com",
            //         phoneNumber: "+9779817996680",
            //         address: "Biratmode-4"
            //     ) { Status = UserStatusEnum.Active, IsVerified = true, Role= UserRoleEnum.Admin }
            // );
            
        }


    
}
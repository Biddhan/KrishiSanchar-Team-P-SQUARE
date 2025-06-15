using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.InsuranceFeatures;
using KrishiSancharCore.LedgerFeatures;
using KrishiSancharCore.OrderFeature;
using KrishiSancharCore.PaymentFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharCore.ReservationFeatures;
using KrishiSancharCore.UserFeatures;
using KrishiSancharCore.UserFeatures.UserEnums;
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
        public DbSet<UserEntity> Users { get; set; }
        public DbSet<OrderEntity> Orders { get; set; }
        public DbSet<PaymentEntity> Payments { get; set; }
        public DbSet<LedgerEntity> Ledgers { get; set; }
        public DbSet<ReservationItemEntity> ReservationItems { get; set; }
        public DbSet<InsuranceProviderEntity> InsuranceProviders { get; set; }
        public DbSet<InsuranceProductEntity> InsuranceProducts { get; set; }
        public DbSet<FarmerInsuranceInterestEntity> FarmerInsuranceInterests { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.ApplyConfiguration(new CategoryConfiguration());
            modelBuilder.ApplyConfiguration(new ProductConfiguration());
            modelBuilder.ApplyConfiguration(new UserConfiguration());
            modelBuilder.ApplyConfiguration(new OrderConfiguration());
            modelBuilder.ApplyConfiguration(new ReservationItemEntityConfiguration());
            modelBuilder.ApplyConfiguration(new InsuranceProviderEntityMapping());
            modelBuilder.ApplyConfiguration(new InsuranceProductEntityMapping());
            modelBuilder.ApplyConfiguration(new FarmerInsuranceInterestEntityMapping());
            new AppSeeder(modelBuilder);
           
            
        }


    
}
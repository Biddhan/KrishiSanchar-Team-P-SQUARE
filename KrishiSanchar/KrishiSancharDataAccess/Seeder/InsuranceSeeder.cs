using KrishiSancharCore.InsuranceFeatures;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class InsuranceSeeder
{
    public InsuranceSeeder(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<InsuranceProviderEntity>().HasData(
            new InsuranceProviderEntity { Id = 1, Name = "AgroSecure Ltd.", ContactInfo = "9800000001", WebsiteUrl = "https://agrosecure.com" },
            new InsuranceProviderEntity { Id = 2, Name = "Nepal Non-Life", ContactInfo = "9800000002", WebsiteUrl = "https://nepalnonlife.com" },
            new InsuranceProviderEntity { Id = 3, Name = "Krishi Suraksha", ContactInfo = "9800000003", WebsiteUrl = "https://krishisuraksha.com" }
        );

        modelBuilder.Entity<InsuranceProductEntity>().HasData(
            // AgroSecure Ltd.
            new InsuranceProductEntity
            {
                Id = 1,
                Name = "Agro Livestock Care",
                Category = "Livestock",
                Description = "Coverage for cows, buffaloes, and goats against disease and injury.",
                ProviderId = 1
            },
            new InsuranceProductEntity
            {
                Id = 2,
                Name = "Agro Crop Shield",
                Category = "Crops",
                Description = "Protects cereals and seasonal crops from floods and drought.",
                ProviderId = 1
            },
            new InsuranceProductEntity
            {
                Id = 3,
                Name = "Agro Mixed Farm Plan",
                Category = "Mixed",
                Description = "Combined protection for mixed farming operations.",
                ProviderId = 1
            },

            // Nepal Non-Life
            new InsuranceProductEntity
            {
                Id = 4,
                Name = "NonLife Livestock Plus",
                Category = "Livestock",
                Description = "Enhanced plan for poultry, pigs, and cattle.",
                ProviderId = 2
            },
            new InsuranceProductEntity
            {
                Id = 5,
                Name = "NonLife Crop Secure",
                Category = "Crops",
                Description = "Guards major food crops from climate risks.",
                ProviderId = 2
            },
            new InsuranceProductEntity
            {
                Id = 6,
                Name = "NonLife Farm Combo",
                Category = "Mixed",
                Description = "Affordable plan for both crops and animals.",
                ProviderId = 2
            },

            // Krishi Suraksha
            new InsuranceProductEntity
            {
                Id = 7,
                Name = "Krishi Livestock Saver",
                Category = "Livestock",
                Description = "Basic livestock risk protection package.",
                ProviderId = 3
            },
            new InsuranceProductEntity
            {
                Id = 8,
                Name = "Krishi Crop Defense",
                Category = "Crops",
                Description = "Covers grains and vegetables against pests and floods.",
                ProviderId = 3
            },
            new InsuranceProductEntity
            {
                Id = 9,
                Name = "Krishi Total Cover",
                Category = "Mixed",
                Description = "All-in-one plan for diverse farm types.",
                ProviderId = 3
            }
        );
    }
}

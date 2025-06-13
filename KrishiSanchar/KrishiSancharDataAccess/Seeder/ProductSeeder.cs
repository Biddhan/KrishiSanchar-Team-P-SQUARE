using KrishiSancharCore.ProductFeatures;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class ProductSeeder
{
    public ProductSeeder(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ProductEntity>().HasData(
    new ProductEntity(1, "Tomato Seeds", "High-germination tomato seeds ideal for backyard or farm planting.", "images/products/seeds_tomato.jpg", 1, 50, 299m)
    {
        Guid = Guid.Parse("11111111-1111-1111-1111-111111111111"),
        DisplayPrice = Math.Round(299m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },
    new ProductEntity(2, "Spinach Seeds", "Fast-growing spinach variety perfect for home gardening.", "images/products/seeds_spinach.jpg", 1, 30, 199m)
    {
        Guid = Guid.Parse("22222222-2222-2222-2222-222222222222"),
        DisplayPrice = Math.Round(199m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },
    new ProductEntity(3, "Lemon Sapling", "Healthy lemon sapling ready for garden or orchard planting.", "images/products/sapling_lemon.jpg", 1, 20, 399m)
    {
        Guid = Guid.Parse("33333333-3333-3333-3333-333333333333"),
        DisplayPrice = Math.Round(399m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },

    // CategoryId 2: Crops
    new ProductEntity(4, "Fresh Corn", "Organic sweet corn harvested at peak ripeness.", "images/products/crop_corn.jpg", 2, 100, 150m)
    {
        Guid = Guid.Parse("44444444-4444-4444-4444-444444444444"),
        DisplayPrice = Math.Round(150m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },
    new ProductEntity(5, "Basmati Rice", "Premium long-grain basmati rice for home use.", "images/products/crop_rice.jpg", 2, 80, 499m)
    {
        Guid = Guid.Parse("55555555-5555-5555-5555-555555555555"),
        DisplayPrice = Math.Round(499m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },

    // CategoryId 3: Tools
    new ProductEntity(6, "Hand Trowel", "Stainless steel hand trowel with ergonomic handle.", "images/products/tools_trowel.jpg", 3, 40, 250m)
    {
        Guid = Guid.Parse("66666666-6666-6666-6666-666666666666"),
        DisplayPrice = Math.Round(250m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },
    new ProductEntity(7, "Pruning Shears", "Durable pruning shears for cutting branches and stems.", "images/products/tools_shears.jpg", 3, 25, 550m)
    {
        Guid = Guid.Parse("77777777-7777-7777-7777-777777777777"),
        DisplayPrice = Math.Round(550m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },

    // CategoryId 4: Medicine
    new ProductEntity(8, "Neem Oil", "Natural pesticide effective against a range of pests.", "images/products/medicine_neem_oil.jpg", 4, 60, 350m)
    {
        Guid = Guid.Parse("88888888-8888-8888-8888-888888888888"),
        DisplayPrice = Math.Round(350m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    },
    new ProductEntity(9, "Fungal Cure Spray", "Protects plants from fungal infections and improves immunity.", "images/products/medicine_fungalcure.jpg", 4, 50, 400m)
    {
        Guid = Guid.Parse("99999999-9999-9999-9999-999999999999"),
        DisplayPrice = Math.Round(400m * 1.005m, 2),
        Status = ProductStatusEnum.Active
    }
);

    }
}

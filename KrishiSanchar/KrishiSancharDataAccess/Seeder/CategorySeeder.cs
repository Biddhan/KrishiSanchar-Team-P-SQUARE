using KrishiSancharCore.CategoryFeatures;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class CategorySeeder
{
    public CategorySeeder(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CategoryEntity>().HasData(
            new CategoryEntity(1, "Seed and Sapling"),
            new CategoryEntity(2, "Crops"),
            new CategoryEntity(3, "Tools"),
            new CategoryEntity(4, "Medicine")
        );
    }
}

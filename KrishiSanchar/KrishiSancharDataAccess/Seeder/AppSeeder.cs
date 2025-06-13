using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class AppSeeder
{
    public AppSeeder(ModelBuilder modelBuilder)
         {
             // Categories
             new CategorySeeder(modelBuilder);

             // Products
             new ProductSeeder(modelBuilder);

             //Users
             // new UserSeeder(modelBuilder);

             //Orders
             // new OrderSeeder(modelBuilder);

             //OrderItems
             // new OrderItemsSeeder(modelBuilder);

             
         }
}
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class AppSeeder
{
    public AppSeeder(ModelBuilder modelBuilder)
         {
             //Users
             new UserSeeder(modelBuilder);
             // Categories
             new CategorySeeder(modelBuilder);

             // Products
             new ProductSeeder(modelBuilder);

             //Orders
             // new OrderSeeder(modelBuilder);

             //OrderItems
             // new OrderItemsSeeder(modelBuilder);
             
             //Insurance
             new InsuranceSeeder(modelBuilder);

             
         }
}
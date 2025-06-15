using KrishiSancharCore.UserFeatures;
using KrishiSancharCore.UserFeatures.UserEnums;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class UserSeeder
{
    public UserSeeder(ModelBuilder modelBuilder)
    {
         var hashedPassword = BCrypt.Net.BCrypt.HashPassword("Secret123");

        modelBuilder.Entity<UserEntity>().HasData(
            new UserEntity(
                id: 1,
                fullname: "Roman Khatri",
                username: "admin1",
                passwordHash: hashedPassword,
                email: "romanforgit@gmail.com",
                phoneNumber: "+9779817996680",
                address: "Biratmode-4"
            )
            {
                Status = UserStatusEnum.Active,
                IsVerified = true,
                Role = UserRoleEnum.Admin,
                CreatedDate = new DateOnly(2024, 1, 1),
                CreatedTime = new TimeOnly(9, 0)
            },

            new UserEntity(
                id: 2,
                fullname: "Krishi User",
                username: "krishi.3",
                passwordHash: hashedPassword,
                email: "webcone1@gmail.com",
                phoneNumber: "+9779817996909",
                address: "Biratmode-4"
            )
            {
                Status = UserStatusEnum.Active,
                IsVerified = true,
                Role = UserRoleEnum.General,
                CreatedDate = new DateOnly(2024, 1, 10),
                CreatedTime = new TimeOnly(10, 0)
            },

            new UserEntity(
                id: 3,
                fullname: "Sushma Sharma",
                username: "sushma.sharma",
                passwordHash: hashedPassword,
                email: "sushma@example.com",
                phoneNumber: "9800000011",
                address: "Chitwan, Nepal"
            )
            {
                Status = UserStatusEnum.Active,
                IsVerified = true,
                Role = UserRoleEnum.General,
                CreatedDate = new DateOnly(2024, 1, 11),
                CreatedTime = new TimeOnly(10, 45)
            },

            new UserEntity(
                id: 4,
                fullname: "Raju Karki",
                username: "raju.karki",
                passwordHash: hashedPassword,
                email: "raju@example.com",
                phoneNumber: "9800000012",
                address: "Jhapa, Nepal"
            )
            {
                Status = UserStatusEnum.Active,
                IsVerified = true,
                Role = UserRoleEnum.General,
                CreatedDate = new DateOnly(2024, 1, 12),
                CreatedTime = new TimeOnly(11, 15)
            }
        );
    }
}
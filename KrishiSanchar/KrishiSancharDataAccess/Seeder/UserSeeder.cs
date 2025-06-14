using KrishiSancharCore.UserFeatures;
using KrishiSancharCore.UserFeatures.UserEnums;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Seeder;

public class UserSeeder
{
    public UserSeeder(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<UserEntity>().HasData(
            new UserEntity(2, "Ramesh Shrestha", "ramesh.seller", "hashed_password_here", "ramesh@example.com", "9800000002", "Lalitpur, Nepal")
            {
                IsVerified = true,
                Status = UserStatusEnum.Active,
                Role = UserRoleEnum.General,
                CreatedDate = new DateOnly(2024, 1, 10),
                CreatedTime = new TimeOnly(9, 0)
            },
            new UserEntity(3, "Sita Gurung", "sita.seller", "hashed_password_here", "sita@example.com", "9800000003", "Pokhara, Nepal")
            {
                IsVerified = true,
                Status = UserStatusEnum.Active,
                Role = UserRoleEnum.General,
                CreatedDate = new DateOnly(2024, 1, 12),
                CreatedTime = new TimeOnly(10, 0)
            }
        );
    }
}
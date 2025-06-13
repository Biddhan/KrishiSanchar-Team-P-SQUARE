using KrishiSancharCore.UserFeatures;
using KrishiSancharDataAccess.Data;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharDataAccess.Repository;

public class UserRepo: IUserRepo
{
    private readonly AppDbContext _appDbContext;
    public UserRepo(AppDbContext appDbContext)
    {
        _appDbContext= appDbContext;
    }

    public async Task RegisterUserAsync(UserEntity entity)
    {
        await _appDbContext.Users.AddAsync(entity);
    }

    public async Task<UserEntity> GetUserByEmail(string email)
    {
        return await _appDbContext.Users.FirstOrDefaultAsync(u=>u.Email==email);
    }

    public async Task<UserEntity> GetUserById(int id)
    {
        return await _appDbContext.Users.FirstOrDefaultAsync(u=>u.Id==id);
    }

    public async Task UpdateUser(UserEntity entity)
    {
        _appDbContext.Users.Update(entity);
    }
}
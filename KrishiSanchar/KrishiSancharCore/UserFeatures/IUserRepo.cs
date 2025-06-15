namespace KrishiSancharCore.UserFeatures;

public interface IUserRepo
{
    Task RegisterUserAsync(UserEntity entity);
    Task UpdateUser(UserEntity entity);
    Task<UserEntity> GetUserByEmail(string email);
    Task<UserEntity> GetUserById(int id);
}
using KrishiSancharDataAccess.Converter.Utility;
using Microsoft.Extensions.Options;

namespace KrishiSancharCore.UserFeatures.UserEnums;

public class UserService
{
    private readonly IUow _uow;
    private readonly UrlService _urlService;
    private readonly BrevoEmailService _brevoEmailService;

    public UserService(IUow uow,IOptions<UrlService> urlService,BrevoEmailService emailService)
    {
        _uow = uow;
        _urlService= urlService.Value;
        _brevoEmailService=emailService;
    }

    public async Task UpdateUser(UserUpdateDto dto)
    {
        var entity = await _uow.Users.GetUserById(dto.Id);
        if(entity == null) throw new Exception($"User with Id {dto.Id} not found");
        entity.FullName = dto.FullName;
        entity.Address = dto.Address;
        entity.PhoneNumber = dto.PhoneNumber;
        if (entity.Email != dto.Email)
        {
            entity.RegenerateToken();
            var verifyLink = $"{_urlService.BaseUrl}/api/auth/verify?token={entity.Token}&email={dto.Email}";
            await _brevoEmailService.SendVerificationEmailAsync(dto.Email, verifyLink,entity.FullName); 
        }
    }

    public async Task UpdateUserPassword(string newPasswordHash, int id)
    {
        var entity = await _uow.Users.GetUserById(id);
        if(entity == null) throw new Exception($"User with Id {id} not found");
        entity.PasswordHash = newPasswordHash;
        await _uow.Users.UpdateUser(entity);
        await _uow.SaveChangesAsync();
    }
}
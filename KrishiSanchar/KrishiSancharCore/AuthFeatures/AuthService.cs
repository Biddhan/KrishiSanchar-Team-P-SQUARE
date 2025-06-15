using System.Security.Claims;
using KrishiSancharCore.UserFeatures;
using KrishiSancharDataAccess.Converter.Utility;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace KrishiSancharCore.AuthFeatures;

public class AuthService
{
    private readonly IUow _uow;
    private readonly JwtService _jwtService;
    private readonly NgrokService _ngrokService;
    private readonly UrlService _urlService;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly BrevoEmailService _brevoEmailService;

    public AuthService(
        IUow uow,
        IOptions<JwtService> jwtOptions,
        IHttpContextAccessor httpContextAccessor,
        BrevoEmailService emailService,
        IOptions<NgrokService> ngrokService,
        IOptions<UrlService> urlService)
    {
        _uow = uow;
        _jwtService = jwtOptions.Value;
        _httpContextAccessor = httpContextAccessor;
        _brevoEmailService = emailService;
        _ngrokService = ngrokService.Value;
        _urlService = urlService.Value;
    }

    public string GenerateJwtToken(UserEntity user)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Role, user.Role)
        };

        return _jwtService.GenerateToken(claims);
    }

    public ClaimsPrincipal? DecodeJwtToken(string token)
    {
        return _jwtService.ValidateToken(token);
    }

    public string SetJwtCookie(UserEntity user)
    {
        var token = GenerateJwtToken(user);
        _httpContextAccessor.HttpContext.Response.Cookies.Append("c_user", token, new CookieOptions
        {
            HttpOnly = true,
            Secure = false,
            SameSite = SameSiteMode.Lax,
            Expires = DateTime.UtcNow.AddDays(_jwtService.ExpiresInDays)
        });
        return token;
    }

    public async Task RegisterUserAsync(UserCreateDto dto)
    {
        dto.PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password);
        var entity = new UserEntity(dto.FullName, dto.Username, dto.PasswordHash, dto.Email, dto.PhoneNumber, dto.Address);
        await _uow.Users.RegisterUserAsync(entity);
        await _uow.SaveChangesAsync();

        var verifyLink = $"{_urlService.BaseUrl}/api/auth/verify?token={entity.Token}&email={entity.Email}";
        await _brevoEmailService.SendVerificationEmailAsync(entity.Email, verifyLink, entity.FullName);
    }
}

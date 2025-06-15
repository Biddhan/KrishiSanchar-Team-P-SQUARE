using System.Security.Claims;
using KrishiSancharCore;
using KrishiSancharCore.AuthFeatures;
using KrishiSancharCore.Helper;
using KrishiSancharCore.UserFeatures;
using KrishiSancharWeb.ViewModel.UserViewModel;
using Microsoft.AspNetCore.Mvc;

namespace KrishiSancharWeb.Controllers;

[Route("api/auth")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly AuthService _authService;
    private readonly IUow _uow;
    private readonly CurrentUserHelper _currentUserHelper;
    public AuthController(AuthService authService,IUow uow,CurrentUserHelper currentUserHelper)
    {
        _authService = authService;
        _uow = uow;
        _currentUserHelper = currentUserHelper;
    }

    [HttpGet("verify")]
    public async Task<IActionResult> Verify([FromQuery]string token, [FromQuery] string email)
    {
        var user= await _uow.Users.GetUserByEmail(email);
        if (user == null || user.IsVerified || user.Token != token)
        {
            return BadRequest("Invalid token or no such user");
        }
        user.IsVerified = true;
        user.VerifyUser();
        await _uow.SaveChangesAsync();
        _authService.SetJwtCookie(user);
        return Ok();
    }

    [HttpPost("register")]
    public async Task<IActionResult> RegisterUserAsync(UserCreateRequestApiViewModel vm)
    {
        var dto = new UserCreateDto
        {
            FullName =
                $"{vm.FirstName} {(string.IsNullOrWhiteSpace(vm.MiddleName) ? "" : vm.MiddleName + " ")}{vm.LastName}"
                    .Trim(),
            Username = (vm.FirstName + vm.LastName).ToLower() + new Random().Next(100, 999),
            Email = vm.Email,
            PhoneNumber = vm.PhoneNumber,
            Address = vm.Address,
            Password = vm.Password,
        };
        await _authService.RegisterUserAsync(dto);
        return Ok(dto);
    }

    [HttpPost("login")]
    public async Task<IActionResult> LoginUserAsync([FromBody] UserLoginRequestApiViewModel vm)
    {
        var user = await _uow.Users.GetUserByEmail(vm.Email);
        if (user == null || !BCrypt.Net.BCrypt.Verify(vm.Password, user.PasswordHash))
        {
            return Unauthorized("Invalid credentials");
        }
       var token= _authService.SetJwtCookie(user);
        return Ok(new { token});
    }

    [HttpPost("logout")]
    public async Task<IActionResult> LogoutUserAsync()
    {
        Response.Cookies.Delete("c_user");
        return Ok();
    }
    
    [HttpGet("me")]
    public IActionResult GetLoggedInUser()
    {
        var (userId, email, role) = _currentUserHelper.GetUserInfo();
        if (userId == null)
            return Unauthorized("User not logged in.");

        return Ok(new { UserId = userId, Email = email, Role = role });
    }



    
    
}
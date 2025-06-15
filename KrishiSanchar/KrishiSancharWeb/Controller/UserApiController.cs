using KrishiSancharCore;
using KrishiSancharCore.Helper;
using KrishiSancharCore.UserFeatures;
using KrishiSancharCore.UserFeatures.UserEnums;
using KrishiSancharDataAccess.Data;
using KrishiSancharWeb.ViewModel;
using KrishiSancharWeb.ViewModel.UserViewModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharWeb.Controllers;

[ApiController]
[Route("api/user")]

public class UserApiController : ControllerBase
{
    private readonly AppDbContext _dbcontext;
    private readonly CurrentUserHelper _currentUser;
    private readonly IUow _uow;
    private readonly UserService _userService;

    public UserApiController(AppDbContext dbcontext, CurrentUserHelper currentUser,IUow uow,UserService userService)
    {
        _dbcontext = dbcontext;
        _currentUser = currentUser;
        _uow = uow;
        _userService = userService;
    }

    [HttpGet("my-products")]
    public async Task<IActionResult> GetMyProducts()
    {
        try
        {
            var userId = _currentUser.GetUserId();
            if (userId == null)
                return Unauthorized();

            var myProducts = await _dbcontext.Products
                .Include(p => p.Seller)
                .Where(p => p.SellerId == userId)
                .ToListAsync();
            return Ok(myProducts);
        }
        catch (Exception e)
        {
            return BadRequest(e.Message);
        }
    }
    
    [HttpGet("my-orders")]
    public async Task<IActionResult> GetMyOrders()
    {
        try
        {
            var userId = _currentUser.GetUserId();
            if (userId == null)
                return Unauthorized();

            var myProducts = await _dbcontext.Orders
                .Include(p => p.Buyer)
                .Where(p => p.BuyerId == userId)
                .ToListAsync();
            return Ok(myProducts);
        }
        catch (Exception e)
        {
            return BadRequest(e.Message);
        }
    }

    [HttpPut]
    public async Task<IActionResult> UpdateUser(UserUpdateRequestApiViewModel vm)
    {
        var existingUser = await _uow.Users.GetUserById(vm.Id );
        if (existingUser == null) return BadRequest();
        var dto = new UserUpdateDto
        {
            Email = vm.Email,
            PhoneNumber = vm.PhoneNumber,
            FullName =
                $"{vm.FirstName} {(string.IsNullOrWhiteSpace(vm.MiddleName) ? "" : vm.MiddleName + " ")}{vm.LastName}"
                    .Trim(),
            Address = vm.Address
        };
        await _userService.UpdateUser(dto);
        return Ok();

    }

    [HttpGet("get-user")]
    public async Task<IActionResult> GetUserById()
    {
        var userId = _currentUser.GetUserId();
        if (userId == null) return Unauthorized();
        var user = await _uow.Users.GetUserById(userId.Value);
        return Ok(user);
    }

    [HttpPut("make-me-expert")]
    public async Task<IActionResult> MakeMeExpert()
    {
        var userId = _currentUser.GetUserId();
        if (userId == null) return Unauthorized();
        var user= await _uow.Users.GetUserById(userId.Value);
        await _userService.UpdateUserRoleToExpert(user);
        return Ok();
    }

    [HttpGet("get-experts")]
    public async Task<IActionResult> GetExperts()
    {
        var users = await _dbcontext.Users.Where(u=>u.Role==UserRoleEnum.Expert).ToListAsync();
        return Ok(users);
    }
}
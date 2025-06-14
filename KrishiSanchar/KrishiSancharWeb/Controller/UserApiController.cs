using KrishiSancharCore.Helper;
using KrishiSancharDataAccess.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace KrishiSancharWeb.Controllers;

[ApiController]
[Route("api/user")]

public class UserApiController : ControllerBase
{
    private readonly AppDbContext _dbcontext;
    private readonly CurrentUserHelper _currentUser;

    public UserApiController(AppDbContext dbcontext, CurrentUserHelper currentUser)
    {
        _dbcontext = dbcontext;
        _currentUser = currentUser;
    }

    [HttpGet("my-products")]
    public async Task<IActionResult> GetMyProducts()
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
}
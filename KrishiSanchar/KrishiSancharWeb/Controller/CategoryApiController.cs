using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KrishiSancharDataAccess;
using KrishiSancharDataAccess.Data;

namespace KrishiSancharWeb.Controllers
{
    [ApiController]
    [Route("api/category")]
    public class CategoryApiController : ControllerBase
    {
        private readonly AppDbContext _dbcontext;

        public CategoryApiController(AppDbContext dbcontext)
        {
            _dbcontext = dbcontext;
        }

        [HttpGet]
        public async Task<IActionResult> GetCategories()
        {
            try
            {
                var categories = await _dbcontext.Categories.Include(e => e.Products).ToListAsync();
                return Ok(categories);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCategoryById(int id)
        {
            var category = await _dbcontext.Categories.Include(e=>e.Products).FirstOrDefaultAsync(c=>c.Id == id);
            if (category == null) throw new Exception($"Category with id:{id} not found");
            return Ok(category);
        }
        
        
    }
}
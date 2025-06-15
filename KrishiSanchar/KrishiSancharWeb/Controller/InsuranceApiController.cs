using KrishiSancharCore;
using KrishiSancharCore.Helper;
using KrishiSancharCore.InsuranceFeatures;
using Microsoft.AspNetCore.Mvc;

namespace KrishiSancharWeb.Controllers;

[ApiController]
[Route("api/insurance")]
public class InsuranceApiController : ControllerBase
{
    private readonly IUow _uow;
    private readonly CurrentUserHelper _currentUserHelper;

    public InsuranceApiController(IUow uow, CurrentUserHelper currentUserHelper)
    {
        _uow = uow;
        _currentUserHelper = currentUserHelper;
    }

    [HttpGet("providers")]
    public async Task<IActionResult> GetProviders()
    {
        var providers = await _uow.Insurances.GetAllProvidersAsync();
        return Ok(providers);
    }

    [HttpGet("products")]
    public async Task<IActionResult> GetAllProducts()
    {
        var products = await _uow.Insurances.GetAllProductsAsync();
        return Ok(products);
    }

    [HttpGet("products/by-provider/{providerId}")]
    public async Task<IActionResult> GetProductsByProvider(int providerId)
    {
        var products = await _uow.Insurances.GetProductsByProviderIdAsync(providerId);
        return Ok(products);
    }

    [HttpPost("{id}/interest")]
    public async Task<bool> SubmitInterest(int id)
    {
        var userId = _currentUserHelper.GetUserId();
        if (!userId.HasValue)
            return false; // or throw Unauthorized if you want stricter control

        var existing = await _uow.Insurances.GetInterestAsync(userId.Value, id);
        if (existing != null)
            return false; // Interest already exists, so "apply" button should show

        var interest = new FarmerInsuranceInterestEntity
        {
            FarmerId = userId.Value,
            InsuranceProductId = id
        };

        await _uow.Insurances.CreateInterestAsync(interest);
        await _uow.SaveChangesAsync();

        return true;
    }
}

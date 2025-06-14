using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Options;

namespace KrishiSancharDataAccess.Converter.Utility;

public class BrevoEmailService
{
    private readonly BrevoSettings _settings;
    private readonly HttpClient _httpClient;

    public BrevoEmailService(IOptions<BrevoSettings> options, HttpClient httpClient)
    {
        _settings = options.Value;
        _httpClient = httpClient;
    }

    public async Task SendVerificationEmailAsync(string toEmail, string verifyLink,string fullName)
    {
        var payload = new
        {
            to = new[] { new { email = toEmail } },
            templateId = 2, 
            @params = new
            {
                verify_link = verifyLink ,
                full_name= fullName
            }
        };

        var request = new HttpRequestMessage(HttpMethod.Post, "https://api.brevo.com/v3/smtp/email");
        request.Headers.Add("api-key", _settings.ApiKey); 

        var json = JsonSerializer.Serialize(payload);
        request.Content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await _httpClient.SendAsync(request); 
        response.EnsureSuccessStatusCode();

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
    
    public async Task SendConfirmationEmailAsync(string toEmail, string confirmLink,string fullName)
    {
        var payload = new
        {
            to = new[] { new { email = toEmail } },
            templateId = 2, 
            @params = new
            {
                confirm_link = confirmLink ,
                full_name= fullName
            }
        };

        var request = new HttpRequestMessage(HttpMethod.Post, "https://api.brevo.com/v3/smtp/email");
        request.Headers.Add("api-key", _settings.ApiKey); 

        var json = JsonSerializer.Serialize(payload);
        request.Content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await _httpClient.SendAsync(request); 
        response.EnsureSuccessStatusCode();

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
}
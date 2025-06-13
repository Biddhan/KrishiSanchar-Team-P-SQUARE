using CloudinaryDotNet;
using KrishiSancharCore;
using KrishiSancharCore.AuthFeatures;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Converter.Utility;
using KrishiSancharDataAccess.Data;
using KrishiSancharDataAccess.Repository;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<AppDbContext>(options => options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddHttpContextAccessor();


builder.Services.Configure<JwtService>(
    builder.Configuration.GetSection("JwtSettings"));
builder.Services.Configure<BrevoSettings>(builder.Configuration.GetSection("BrevoSettings"));
builder.Services.Configure<NgrokService>(builder.Configuration.GetSection("NgrokSettings"));
builder.Services.Configure<UrlService>(builder.Configuration.GetSection("UrlSettings"));



var cloudinaryUrl = builder.Configuration["Cloudinary:Url"];
builder.Services.AddSingleton(new Cloudinary(cloudinaryUrl));

builder.Services.AddScoped<ProductService>();
builder.Services.AddHttpClient<BrevoEmailService>();
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<IUow, Uow>();
builder.Services.AddScoped<IProductRepo, ProductRepo>();
builder.Services.AddScoped<CloudinaryService>();



builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "API V1");
    c.RoutePrefix = string.Empty;
});



app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();


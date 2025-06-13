using CloudinaryDotNet;
using KrishiSancharCore;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharDataAccess.Converter.Utility;
using KrishiSancharDataAccess.Data;
using KrishiSancharDataAccess.Repository;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<AppDbContext>(options => options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

var cloudinaryUrl = builder.Configuration["Cloudinary:Url"];
builder.Services.AddSingleton(new Cloudinary(cloudinaryUrl));

builder.Services.AddScoped<ProductService>();
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


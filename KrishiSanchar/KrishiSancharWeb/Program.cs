using System.Text;
using CloudinaryDotNet;
using KrishiSancharCore;
using KrishiSancharCore.AuthFeatures;
using KrishiSancharCore.Helper;
using KrishiSancharCore.ProductFeatures;
using KrishiSancharCore.ReservationFeatures;
using KrishiSancharDataAccess.Converter.Utility;
using KrishiSancharDataAccess.Data;
using KrishiSancharDataAccess.Repository;
using KrishiSancharInfrastructure.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<CurrentUserHelper>();

builder.Services.Configure<JwtService>(builder.Configuration.GetSection("JwtSettings"));
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
builder.Services.AddScoped<IReservationCleanupService, ReserveItemCleanupService>();
builder.Services.AddHostedService<ReserveItemCleanupService>();

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
        ValidAudience = builder.Configuration["JwtSettings:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(builder.Configuration["JwtSettings:Key"]))
    };
    options.Events = new JwtBearerEvents
    {
        OnMessageReceived = context =>
        {
            // 1. Try to read from cookie
            var cookieToken = context.Request.Cookies["c_user"];
            if (!string.IsNullOrEmpty(cookieToken))
            {
                context.Token = cookieToken;
            }

// 2. If not in cookie, try custom header (Flutter sends like this)
            var headerToken = context.Request.Headers["c_user"].FirstOrDefault();
            if (!string.IsNullOrEmpty(headerToken) && headerToken.StartsWith("Bearer "))
            {
                context.Token = headerToken.Substring("Bearer ".Length).Trim();
            }

            return Task.CompletedTask;
        }
    };
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.SetIsOriginAllowed(_ => true) // Allow all origins
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();
    });
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseCors("AllowFrontend");

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "API V1");
    c.RoutePrefix = string.Empty;
});

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
using KrishiSancharDataAccess.Data;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using KrishiSancharCore.ReservationFeatures;

namespace KrishiSancharInfrastructure.Services
{
    public class ReserveItemCleanupService : BackgroundService, IReservationCleanupService
    {
        private readonly IServiceScopeFactory _scopeFactory;

        public ReserveItemCleanupService(IServiceScopeFactory scopeFactory)
        {
            _scopeFactory = scopeFactory;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                await CleanUpReservationsAsync();
                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken); // Adjust interval as needed
            }
        }

        public async Task CleanUpReservationsAsync()
        {
            using var scope = _scopeFactory.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            try
            {
                var expiredReservations = dbContext.ReservationItems
                    .Where(r => r.ExpireAt <= DateTime.UtcNow && !r.IsCompleted)
                    .ToList();

                foreach (var reservation in expiredReservations)
                {
                    var product = await dbContext.Products.FindAsync(reservation.ProductId);
                    if (product != null)
                    {
                        product.Reserve -= reservation.Quantity;
                        product.Stock += reservation.Quantity;
                        dbContext.ReservationItems.Remove(reservation);
                    }
                }

                await dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Log the error (use a logging service if available)
                Console.WriteLine($"Error in CleanUpReservations: {ex.Message}");
            }
        }
    }
}
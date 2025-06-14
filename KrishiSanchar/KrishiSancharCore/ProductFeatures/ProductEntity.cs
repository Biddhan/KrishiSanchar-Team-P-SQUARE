using KrishiSancharCore.CategoryFeatures;
using KrishiSancharCore.UserFeatures;

namespace KrishiSancharCore.ProductFeatures;

public class ProductEntity
    {
        protected ProductEntity()
        {
        }
        public ProductEntity(string name, string description, string imageUrl, int categoryId, int stock, decimal unitPrice, int sellerId)
        {
            Guid = Guid.NewGuid();
            Name = name;
            Description = description;
            ImageUrl = imageUrl;
            CategoryId = categoryId;
            CreatedDate = DateOnly.FromDateTime(DateTime.Now);
            CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
            Stock = stock;
            UnitPrice = unitPrice;
            SellerId = sellerId;
            CalculateDisplayPrice();
            Activate();
        }

        public ProductEntity(int id, string name, string description, string imageUrl, int categoryId, int stock, decimal unitPrice, int sellerId)
            : this(name, description, imageUrl, categoryId, stock, unitPrice, sellerId)
        {
            Id = id;
        }

        public int Id { get; protected set; }
        public Guid Guid { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public int Stock { get; set; }
        public int Reserve { get; set; } = 0;
        public decimal UnitPrice { get; set; }
        public decimal DisplayPrice { get; set; }
        public int CategoryId { get; set; }
        
        public int SellerId { get; set; }
        public UserEntity Seller { get; set; }
        public DateOnly CreatedDate { get; private set; }
        public DateOnly UpdatedDate { get; private set; }
        public TimeOnly UpdatedTime { get; private set; }
        public TimeOnly CreatedTime { get; private set; }

        public ProductStatusEnum Status { get; set; }

        public void Activate()
        {
            Status= ProductStatusEnum.Active;
        }
        public void Deactivate()
        {
            Status = ProductStatusEnum.InActive;
        }
        public bool IsActive() {  
            return Status == ProductStatusEnum.Active;
        }
        public void UpdateTimestamp()
        {
            UpdatedDate = DateOnly.FromDateTime(DateTime.Now);
            UpdatedTime = TimeOnly.FromDateTime(DateTime.Now);
        }

        public void CalculateDisplayPrice()
        {
            DisplayPrice = UnitPrice * 1.05m;
        }


    }
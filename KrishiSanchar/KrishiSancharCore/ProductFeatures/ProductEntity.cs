using KrishiSancharCore.CategoryFeatures;

namespace KrishiSancharCore.ProductFeatures;

public class ProductEntity
    {
        protected ProductEntity()
        {
        }
        public ProductEntity(string Name, string Description, string ImageUrl, int CategoryId, int Stock,decimal UnitPrice)
        {
            Guid = Guid.NewGuid();
            this.Name = Name;
            this.Description = Description;
            this.ImageUrl = ImageUrl;
            this.CategoryId = CategoryId;
            CreatedDate = DateOnly.FromDateTime(DateTime.Now);
            CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
            this.Stock = Stock;
            this.UnitPrice = UnitPrice;
            CalculateDisplayPrice();
            Activate();

        }
        public ProductEntity(int Id,string Name, string Description, string ImageUrl, int CategoryId, int stock,decimal UnitPrice): this(Name,Description,ImageUrl,CategoryId,stock,UnitPrice)
        {
            this.Id =Id;
        }
        public int Id { get; protected set; }
        public Guid Guid { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public int Stock { get; set; }
        public int? Reserve { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal DisplayPrice { get; set; }
        public int CategoryId { get; set; }
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
            DisplayPrice = UnitPrice * 1.005m;
        }


    }
using KrishiSancharCore.ProductFeatures;

namespace KrishiSancharCore.CategoryFeatures;

public class CategoryEntity
{
        protected CategoryEntity() { }
        public CategoryEntity(string Name)
        {
            this.Name = Name;
        }

        public CategoryEntity(int Id, string Name):this(Name)
        {
            this.Id = Id;
        }

        public int Id { get; protected set; }
        public string Name { get; set; }
        public IEnumerable<ProductEntity> Products { get; set; } = new List<ProductEntity>();
    
}
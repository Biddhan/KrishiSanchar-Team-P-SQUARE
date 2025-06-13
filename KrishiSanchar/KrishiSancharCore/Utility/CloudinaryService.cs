using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Microsoft.AspNetCore.Http;

namespace KrishiSancharDataAccess.Converter.Utility;

public class CloudinaryService
    {
        private readonly Cloudinary _cloudinary;

        public CloudinaryService(Cloudinary cloudinary)
        {
            _cloudinary = cloudinary ?? throw new ArgumentNullException(nameof(cloudinary));
            _cloudinary.Api.Secure = true;
        }

        public async Task<string> UploadImageAsync(IFormFile image)
        {
            if (image == null || image.Length == 0)
                throw new ArgumentException("No image provided.", nameof(image));

            var uploadParams = new ImageUploadParams
            {
                File = new FileDescription(image.FileName, image.OpenReadStream()),
                UseFilename = true,
                UniqueFilename = false,
                Overwrite = true,
                Transformation = new Transformation().Width(500).Height(500).Crop("fit")
            };

            var uploadResult = await _cloudinary.UploadAsync(uploadParams);

            if (uploadResult.Error != null)
            {
                throw new Exception($"Cloudinary upload error: {uploadResult.Error.Message}");
            }

            // 🔍 Check this value
            var secureUrl = uploadResult.SecureUrl?.AbsoluteUri;

            if (string.IsNullOrEmpty(secureUrl))
                throw new Exception("Image upload failed or returned no URL.");

            return secureUrl;
        }


        public async Task<string> GetQualityAnalysisAsync(string publicId)
        {
            if (string.IsNullOrEmpty(publicId))
                throw new ArgumentException("Public ID is required.", nameof(publicId));

            var getResourceParams = new GetResourceParams(publicId)
            {
                QualityAnalysis = true
            };
            var getResourceResult = await _cloudinary.GetResourceAsync(getResourceParams);
            return getResourceResult.JsonObj["quality_analysis"]?.ToString();
        }

        public string GetTransformedUrl(string imageUrl)
        {
            if (string.IsNullOrEmpty(imageUrl))
                throw new ArgumentException("Image URL is required.", nameof(imageUrl));

            var publicId = Path.GetFileNameWithoutExtension(imageUrl);
            var transformation = _cloudinary.Api.UrlImgUp.Transform(new Transformation()
                .Width(300).Crop("scale").Chain()
                .Effect("cartoonify"));
            return transformation.BuildUrl(publicId);
        }
    }
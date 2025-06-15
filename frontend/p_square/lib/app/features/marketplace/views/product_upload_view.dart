import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/product_upload_controller.dart';
import 'package:p_square/core/constants/enum_constants.dart';
// import 'package:p_square/core/constants/string_constants.dart';

class ProductUploadView extends StatefulWidget {
  const ProductUploadView({super.key});

  @override
  State<ProductUploadView> createState() => _ProductUploadViewState();
}

class _ProductUploadViewState extends State<ProductUploadView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductUploadController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('अपलोड गर्नुहोस्'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: controller.clearForm,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isSuccess.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                const Text(
                  'सफलतापूर्वक अपलोड भयो!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.isSuccess.value = false;
                  },
                  child: const Text('अर्को उत्पादन अपलोड गर्नुहोस्'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                _buildImagePicker(context, controller),

                const SizedBox(height: 20),

                // Product name
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'उत्पादनको नाम',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया उत्पादनको नाम आवश्यक छ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Product description
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'विवरण',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया उत्पादनको विवरण प्रविष्ट गर्नुहोस्';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Category selection
                _buildCategorySelector(controller),

                const SizedBox(height: 16),

                if (controller.stockController.text.isNotEmpty &&
                    controller.priceController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.lightBlue.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      "बिक्री मूल्य: ${int.parse(controller.priceController.text) * 1.05}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                SizedBox(height: 16),

                // Stock and price in a row
                Row(
                  children: [
                    // Stock
                    Expanded(
                      child: TextFormField(
                        controller: controller.stockController,
                        decoration: const InputDecoration(
                          labelText: 'स्टक',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.inventory),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'आवश्यक छ';
                          }
                          if (int.tryParse(value) == null) {
                            return 'नम्बर प्रविष्ट गर्नुहोस्';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Price
                    Expanded(
                      child: TextFormField(
                        controller: controller.priceController,
                        decoration: const InputDecoration(
                          labelText: 'मूल्य (रु.)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'आवश्यक छ';
                          }
                          if (int.tryParse(value) == null) {
                            return 'नम्बर आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.uploadProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'उत्पादन अपलोड गर्नुहोस्',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    ProductUploadController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'उत्पादनको तस्वीर',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: controller.selectedImage.value == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 50, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'तस्वीर छनौट',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('ग्यालेरी'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.captureImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('क्यामेरा'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelector(ProductUploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'श्रेणी',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              _buildCategoryTile(
                CategoryEnum.seeds,
                'बीउ',
                Icons.eco,
                Colors.green,
                controller,
              ),
              const Divider(height: 1),
              _buildCategoryTile(
                CategoryEnum.tools,
                'उपकरण',
                Icons.build,
                Colors.orange,
                controller,
              ),
              const Divider(height: 1),
              _buildCategoryTile(
                CategoryEnum.crops,
                'बाली',
                Icons.grass,
                Colors.lightGreen,
                controller,
              ),
              const Divider(height: 1),
              _buildCategoryTile(
                CategoryEnum.medicine,
                'औषधि',
                Icons.healing,
                Colors.red,
                controller,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    CategoryEnum category,
    String title,
    IconData icon,
    Color color,
    ProductUploadController controller,
  ) {
    return Obx(
      () => RadioListTile<CategoryEnum>(
        title: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        value: category,
        groupValue: controller.selectedCategory.value,
        onChanged: (value) {
          if (value != null) {
            controller.setCategory(value);
          }
        },
        activeColor: color,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

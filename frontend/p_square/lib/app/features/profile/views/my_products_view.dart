import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/profile/controller/profile_controller.dart';
import 'package:p_square/app/features/profile/models/product_model.dart';

import '../../marketplace/views/product_upload_view.dart';

class MyProductsView extends GetView<ProfileController> {
  const MyProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load products when the view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyProducts();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('मेरो उत्पादनहरू'), elevation: 0),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingProducts.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'कुनै उत्पादन छैन',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'तपाईंले अहिलेसम्म कुनै उत्पादन थप्नुभएको छैन',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.to(ProductUploadView()),
                    child: const Text('उत्पादन थप्नुहोस्'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.getMyProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.myProducts.length,
              itemBuilder: (context, index) {
                final productJson = controller.myProducts[index];
                return ProductCard(productJson: productJson);
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ProductUploadView()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic productJson;

  const ProductCard({super.key, required this.productJson});

  @override
  Widget build(BuildContext context) {
    final product = Product.fromJson(productJson);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'रू ${product.displayPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'स्टक: ${product.stock}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: product.status.name == 'Active'
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.status.name == 'Active'
                            ? 'सक्रिय'
                            : 'निष्क्रिय',
                        style: TextStyle(
                          fontSize: 10,
                          color: product.status.name == 'Active'
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

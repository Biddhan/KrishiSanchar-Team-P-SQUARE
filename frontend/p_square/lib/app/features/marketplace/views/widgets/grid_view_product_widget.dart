import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/marketplace_controller.dart';
import '../product_view.dart';
import 'product_widget.dart';

class GridViewProductWidget extends StatelessWidget {
  const GridViewProductWidget({super.key, required this.controller});

  final MarketplaceController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.size.height * 0.75,
      child: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (controller.items.isEmpty) {
            return const Center(
              child: Text(
                'No products found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final product = controller.items[index];
              return ProductCard(
                onTap: (product) {
                  Get.to(() => ProductView(product));
                },
                product: product,
              );
            },
          );
        },
      ),
    );
  }
}

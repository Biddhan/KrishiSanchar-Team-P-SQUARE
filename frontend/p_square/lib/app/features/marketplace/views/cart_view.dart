import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/app/features/marketplace/models/order_response_model.dart';

import '../../../../core/constants/string_constants.dart';

class CartView extends GetView<MarketplaceController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.cart),
        actions: [
          Obx(
            () => controller.cartItems.isEmpty
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      Get.defaultDialog(
                        title: StringConstants.clearCart,
                        middleText: StringConstants.areYouSureClearCart,
                        textConfirm: StringConstants.yes,
                        textCancel: StringConstants.no,
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.clearCart();
                          Get.back();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isProcessingOrder.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(StringConstants.processingOrder),
              ],
            ),
          );
        }

        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  StringConstants.emptyCart,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text(StringConstants.continueShopping),
                ),
              ],
            ),
          );
        }

        // If we have an order preview, show order summary
        if (controller.orderPreview.value != null) {
          return _buildOrderSummary(context, controller.orderPreview.value!);
        }

        // Otherwise show loading
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderResponse orderResponse) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order summary header
          const Text(
            StringConstants.orderSummary,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Packages
          ...orderResponse.packages.entries.map((entry) {
            final packageId = entry.key;
            final package = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller info
                    Row(
                      children: [
                        const Icon(Icons.store, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${StringConstants.soldBy} ${package.soldBy}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Items in this package
                    ...package.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Find the cart item to get the image
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildProductImage(item.productId),
                            ),
                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${StringConstants.quantity} ${item.quantity}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          _showQuantityDialog(
                                            context,
                                            item.productId,
                                            item.quantity,
                                          );
                                        },
                                        child: Text(
                                          StringConstants.edit,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${StringConstants.currency} ${item.subTotalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    controller.removeFromCart(item.productId);
                                  },
                                  child: const Text(
                                    StringConstants.remove,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 24),

                    // Package summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(StringConstants.itemsTotal),
                        Text(
                          '${StringConstants.currency} ${(package.packageTotal - package.deliveryCharge).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(StringConstants.deliveryFee),
                        Text(
                          '${StringConstants.currency} ${package.deliveryCharge.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          StringConstants.packageTotal,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${StringConstants.currency} ${package.packageTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          // Grand total
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        StringConstants.grandTotal,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${StringConstants.currency} ${orderResponse.grandTotalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Place order button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.placeOrder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                StringConstants.placeOrder,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Continue shopping button
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text(
                StringConstants.continueShopping,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to find product image from cart items
  Widget _buildProductImage(int productId) {
    final cartItem = controller.cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );

    if (cartItem != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          cartItem.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
        ),
      );
    } else {
      // Fallback if image not found
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }

  // Show dialog to edit quantity
  void _showQuantityDialog(
    BuildContext context,
    int productId,
    int currentQuantity,
  ) {
    int quantity = currentQuantity;

    Get.dialog(
      AlertDialog(
        title: const Text(StringConstants.updateQuantity),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(StringConstants.cancelChanges),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateQuantity(productId, quantity);
              Get.back();
            },
            child: const Text(StringConstants.saveChanges),
          ),
        ],
      ),
    );
  }
}

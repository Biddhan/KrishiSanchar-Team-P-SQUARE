import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/app/features/marketplace/views/cart_view.dart';

import '../../../../../core/constants/string_constants.dart';
import '../../../../../core/routes/app_routes.dart';

class HeaderAndSearchIcon extends GetView<MarketplaceController> {
  const HeaderAndSearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 12),

        // header text
        Text(
          StringConstants.marketplaceHeaderText,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: theme.textTheme.headlineSmall,
        ),
        // search icon
        Row(
          children: [
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNames.search);
              },
              icon: const Icon(Icons.search),
            ),
            // cart icon with badge
            Obx(() => Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const CartView());
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                if (controller.cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${controller.cartItemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            )),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/app/features/marketplace/views/widgets/top_action_buttons.dart';

import 'widgets/grid_view_product_widget.dart';
import 'widgets/header_search_widget.dart';

class MarketplaceScreen extends GetView<MarketplaceController> {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only load data if not initialized
    if (!controller.isInitialized.value) {
      controller.loadInitialData();
    } else {
      // If returning to marketplace, reset to show all products without filtering
      controller.resetToAllProducts();
    }

    return SafeArea(
      child: Column(
        children: [
          const HeaderAndSearchIcon(),
          const TopActionButtons(),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: controller.refreshMarketplace,
                      child: GridViewProductWidget(controller: controller),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/app/features/marketplace/views/widgets/grid_view_product_widget.dart';
import 'package:p_square/core/constants/enum_constants.dart';
import 'package:p_square/core/constants/string_constants.dart';

import 'widgets/search_top_bar.dart';

class SearchView extends GetView<MarketplaceController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use onInit to prepare for search view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.prepareForSearchView();
    });

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // search widget
            const SearchWIdget(),

            // selected category
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(
                      '${StringConstants.selectedCategory}: ${getNepaliName(controller.selectedCategory.value).toUpperCase()}',
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Search status
            Obx(
              () =>
                  controller.isSearching.value &&
                      controller.searchBarController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Search results for "${controller.searchBarController.text}"',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // gridview
            Expanded(child: GridViewProductWidget(controller: controller)),
          ],
        ),
      ),
    );
  }

  String getNepaliName(CategoryEnum category) {
    switch (category) {
      case CategoryEnum.crops:
        return StringConstants.crops;
      case CategoryEnum.medicine:
        return StringConstants.medicine;
      case CategoryEnum.seeds:
        return StringConstants.seeds;
      case CategoryEnum.tools:
        return StringConstants.tools;
    }
  }
}

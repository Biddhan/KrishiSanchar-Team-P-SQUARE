import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/views/category_view.dart';

import '../../../../../core/constants/string_constants.dart';
import '../../controller/marketplace_controller.dart';

class SearchWIdget extends GetView<MarketplaceController> {
  const SearchWIdget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () {
                // Clear search before going back
                controller.clearSearch();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              style: ButtonStyle(
                iconSize: const WidgetStatePropertyAll(24),
                backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
              ),
            ),

            const SizedBox(width: 8),

            // Search bar
            Expanded(
              child: SizedBox(
                height: 45,
                child: TextField(
                  controller: controller.searchBarController,
                  decoration: InputDecoration(
                    hintText: StringConstants.searchHintText,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    suffixIcon: controller.searchBarController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clearSearch();
                            },
                          )
                        : const SizedBox.shrink(),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    // Debounce search to prevent too many API calls
                    if (value.isEmpty) {
                      controller.clearSearch();
                    } else {
                      // Use a slight delay to reduce API calls while typing
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (value == controller.searchBarController.text) {
                          controller.searchString(value);
                        }
                      });
                    }
                  },
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    controller.searchString(value);
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Category filter button
            IconButton(
              onPressed: () {
                Get.to(() => const CategoryView());
              },
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter by category',
              style: ButtonStyle(
                iconSize: const WidgetStatePropertyAll(24),
                backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

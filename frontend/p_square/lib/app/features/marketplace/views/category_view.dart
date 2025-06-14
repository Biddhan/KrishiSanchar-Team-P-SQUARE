import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/core/constants/enum_constants.dart';

import '../../../../core/constants/string_constants.dart';

class CategoryView extends GetView<MarketplaceController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConstants.categories)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                StringConstants.allCategories,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Categories List
            Expanded(
              child: Obx(
                () => ListView(
                  children: [
                    CategoryListItem(
                      title: StringConstants.crops,
                      icon: Icons.grass,
                      isSelected:
                          controller.selectedCategory.value ==
                          CategoryEnum.crops,
                      onTap: () {
                        controller.selectCategoryById(CategoryEnum.crops);
                        Get.back();
                      },
                    ),
                    CategoryListItem(
                      title: StringConstants.tools,
                      icon: Icons.build,
                      isSelected:
                          controller.selectedCategory.value ==
                          CategoryEnum.tools,
                      onTap: () {
                        controller.selectCategoryById(CategoryEnum.tools);
                        Get.back();
                      },
                    ),
                    CategoryListItem(
                      title: StringConstants.seeds,
                      icon: Icons.eco,
                      isSelected:
                          controller.selectedCategory.value ==
                          CategoryEnum.seeds,
                      onTap: () {
                        controller.selectCategoryById(CategoryEnum.seeds);
                        Get.back();
                      },
                    ),
                    CategoryListItem(
                      title: StringConstants.medicine,
                      icon: Icons.bug_report,
                      isSelected:
                          controller.selectedCategory.value ==
                          CategoryEnum.medicine,
                      onTap: () {
                        controller.selectCategoryById(CategoryEnum.medicine);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}

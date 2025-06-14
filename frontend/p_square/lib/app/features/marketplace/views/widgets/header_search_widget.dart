import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/string_constants.dart';
import '../../../../../core/routes/app_routes.dart';

class HeaderAndSearchIcon extends StatelessWidget {
  const HeaderAndSearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(height: 12),

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
              icon: Icon(Icons.search),
            ),
            // vart icon
            IconButton(
              onPressed: () {
                // TODO: add cart page
                Get.toNamed(RouteNames.search);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
        ),
      ],
    );
  }
}

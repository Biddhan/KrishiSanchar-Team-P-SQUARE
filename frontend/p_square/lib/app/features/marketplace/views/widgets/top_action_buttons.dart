import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/core/constants/string_constants.dart';

import '../../../auth/views/auth_helper_method.dart';
import '../product_upload_view.dart';

class TopActionButtons extends StatelessWidget {
  const TopActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 8,
        children: [
          // sell
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFF6C63FF),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(0),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                overlayColor: WidgetStateProperty.all(
                  Colors.white.withValues(alpha: 0.1),
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              onPressed: () async {
                // Check if user is logged in, if not show login/signup dialog
                final isAuthenticated = await AuthHelper.checkAuthAndProceed();
                if (!isAuthenticated) {
                  return;
                }

                Get.to(() => const ProductUploadView());
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Icons.sell, size: 14)),
                    TextSpan(text: " ${StringConstants.sellButtonLabel}"),
                  ],
                ),
              ),
              // Text(StringConstants.sellButtonLabel, textAlign: TextAlign.center,),
            ),
          ),
          // // catrgory
          // Expanded(
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //       backgroundColor: WidgetStateProperty.all(
          //         const Color(0xFF6C63FF),
          //       ),
          //       foregroundColor: WidgetStateProperty.all(Colors.white),
          //       elevation: WidgetStateProperty.all(0),
          //       padding: WidgetStateProperty.all(
          //         const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          //       ),
          //       shape: WidgetStateProperty.all(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //       ),
          //       overlayColor: WidgetStateProperty.all(
          //         Colors.white.withValues(alpha: 0.1),
          //       ),
          //       textStyle: WidgetStateProperty.all(
          //         const TextStyle(
          //           fontSize: 15,
          //           fontWeight: FontWeight.w500,
          //           letterSpacing: 0.5,
          //         ),
          //       ),
          //     ),
          //     onPressed: () {
          //       Get.toNamed(RouteNames.category);
          //     },
          //     child: RichText(
          //       text: TextSpan(
          //         children: [
          //           WidgetSpan(child: Icon(Icons.category, size: 14)),
          //           TextSpan(text: StringConstants.categoryButtonLabel),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

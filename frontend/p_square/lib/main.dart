import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';
import 'package:p_square/app/features/marketplace/controller/product_upload_controller.dart';
import 'package:p_square/app/features/plant/controller/plant_controller.dart';
import 'package:p_square/core/routes/app_pages.dart';
import 'package:p_square/core/routes/app_routes.dart';
import 'package:p_square/main_view.dart';
import 'package:snackbarx/snackbarx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SnackbarX.init();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.initial,
      getPages: AppPages.pages,
      initialBinding: BindingsBuilder(() {
        Get.put(MarketplaceController());
        Get.put(PlantController());
        Get.put(ProductUploadController());
      }),
      unknownRoute: GetPage(name: RouteNames.initial, page: () => MainScreen()),
      theme: FlexThemeData.light(scheme: FlexScheme.mallardGreen),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mallardGreen),
      themeMode: ThemeMode.system,
    );
  }
}

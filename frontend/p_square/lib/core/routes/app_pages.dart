import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:p_square/app/features/auth/views/login_view.dart';
import 'package:p_square/app/features/marketplace/views/category_view.dart';
import 'package:p_square/app/features/marketplace/views/marketplace_view.dart';
import 'package:p_square/app/features/marketplace/views/search_view.dart';
import 'package:p_square/app/features/plant/views/plant_view.dart';
import 'package:p_square/app/features/sell/views/sell_view.dart';
import 'package:p_square/bindings/bindings.dart';
import 'package:p_square/core/routes/app_routes.dart';
import 'package:p_square/main_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouteNames.plant,
      page: () => PlantView(),
      transition: Transition.fadeIn,
      binding: PlantBinding()
    ),
    GetPage(
      name: RouteNames.marketplace,
      page: () => MarketplaceScreen(),
      transition: Transition.fadeIn,
      binding: MarketplaceBinding()
    ),
    GetPage(
      name: RouteNames.login,
      page: () => LoginView(),
      transition: Transition.fadeIn,
      // binding: LoginBinding()
    ),
    GetPage(
      name: RouteNames.category,
      page: () => CategoryView(),
      transition: Transition.fadeIn,
      // binding: CategoryBindings()
    ),
    GetPage(
      name: RouteNames.sell,
      page: () => SellView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.initial,
      page: () => MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.search,
      page: () => SearchView(),
      transition: Transition.fadeIn,
    ),
  ];
}

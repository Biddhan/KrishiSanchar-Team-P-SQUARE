import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/controller/marketplace_controller.dart';

import '../app/features/plant/controller/plant_controller.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceController>(() => MarketplaceController());
  }
}

class PlantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantController>(() => PlantController());
  }
}

// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<AuthBinding>(() => AuthController());
//   }
// }

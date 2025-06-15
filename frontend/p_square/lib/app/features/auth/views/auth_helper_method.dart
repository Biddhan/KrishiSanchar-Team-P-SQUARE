import 'package:get/get.dart';
import 'package:p_square/app/features/auth/controller/auth_controller.dart';
import 'package:p_square/app/features/auth/views/auth_dialog.dart';

class AuthHelper {
  static Future<void> showAuthDialog() async {
    // Make sure AuthController is initialized
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    
    // Show the dialog
    await Get.dialog(
      AuthDialog(),
      barrierDismissible: true,
    );
  }
  
  static bool isLoggedIn() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    return Get.find<AuthController>().isLoggedIn.value;
  }
  
  static Future<void> logout() async {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    await Get.find<AuthController>().logout();
  }
  
  static String? getToken() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    return Get.find<AuthController>().token.value;
  }
  
  // Check if user is logged in, if not show auth dialog
  static Future<bool> checkAuthAndProceed() async {
    if (isLoggedIn()) {
      return true;
    } else {
      await showAuthDialog();
      // Check again after dialog is closed
      return isLoggedIn();
    }
  }
}

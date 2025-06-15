import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  SnackbarUtils._();

  static void showNepaliError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  static void showNepaliSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showExpertApplicationSuccessDialog() async {
  return Get.defaultDialog<bool>(
    title: "आवेदन सफल भयो!",
    titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    middleText:
        "तपाईंले विशेषज्ञ (Expert) हुनको लागि सफलतापूर्वक आवेदन गर्नुभयो। हामी तपाईंको विवरण जाँच गरी शीघ्रै म्यानुअल रूपमा स्वीकृत गर्नेछौं।",
    middleTextStyle: TextStyle(fontSize: 16),
    textConfirm: "ठीक छ",
    confirmTextColor: Colors.white,
    buttonColor: Colors.blue,
    onConfirm: () {
      Get.back(result: true);
    },
  );
}

void showAlreadyAppliedDialog() {
  Get.defaultDialog(
    title: "तपाईंले पहिले नै आवेदन गर्नुभएको छ!",
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.orange,
    ),
    middleText: "हामी तपाईंको आवेदन हेर्दै छौं। कृपया प्रतीक्षा गर्नुहोस्...",
    middleTextStyle: TextStyle(fontSize: 16),
    textConfirm: "बुझे",
    confirmTextColor: Colors.white,
    buttonColor: Colors.blue,
    onConfirm: () => Get.back(),
  );
}

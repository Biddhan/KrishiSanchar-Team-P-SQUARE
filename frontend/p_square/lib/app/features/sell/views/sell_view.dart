import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/views/product_upload_view.dart';

import '../controller/sell_controller.dart';

class SellView extends GetView<SellController> {
  const SellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SellView')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ProductUploadView());
        },
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(child: Text('SellViewController')),
    );
  }
}

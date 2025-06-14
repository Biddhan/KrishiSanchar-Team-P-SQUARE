
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/plant/controller/plant_controller.dart';

class AddPlantButton extends GetView<PlantController> {
  const AddPlantButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // sell
        ElevatedButton(
          onPressed: () {
            // TODO: implement this
            // Sell
          },
          child: Text("Sell"),
        ),
        // catrgory
        ElevatedButton(
          onPressed: () {
            // TODO: implement this
            // Category
          },
          child: Text("Sell"),
        ),
      ],
    );
  }
}
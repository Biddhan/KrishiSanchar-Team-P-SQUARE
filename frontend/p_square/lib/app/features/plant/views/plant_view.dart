import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:p_square/app/features/plant/controller/plant_controller.dart';
import 'package:p_square/app/features/plant/views/widgets/add_plant_button.dart';

class PlantView extends GetView<PlantController> {
  const PlantView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AddPlantButton(),
            // list of items
          ],
        ),
      ),
    );
  }
}


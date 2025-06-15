import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/plant/controller/plant_controller.dart';

class JaggaTab extends GetView<PlantController> {
  const JaggaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputForm(),
            const SizedBox(height: 24),
            _buildPredictButton(),
            const SizedBox(height: 24),
            Obx(
              () => controller.cropPredictionResult.value != null
                  ? _buildResultSection()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "जग्गा र उत्पादन विवरण",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Aana Input
            TextField(
              controller: controller.aanaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "जग्गाको क्षेत्रफल (आना)",
                hintText: "उदाहरण: 8",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),

            // Quintal Input
            TextField(
              controller: controller.quintalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "उत्पादन परिमाण (क्विन्टल)",
                hintText: "उदाहरण: 10",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.agriculture),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLandPredictionLoading.value
              ? null
              : controller.predictCrop,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: controller.isLandPredictionLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "फसल अनुमान गर्नुहोस्",
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    final result = controller.cropPredictionResult.value!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "अनुमान परिणाम",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),

            // Display the recommended crop
            _buildResultItem(
              "अनुमानित फसल",
              controller.getCropNepaliName(result.crop),
              Icons.grass,
            ),

            const SizedBox(height: 24),

            // Fertilizer recommendations section
            const Text(
              "मलखाद सिफारिस",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Urea recommendation
            _buildFertilizerItem(
              "युरिया (नाइट्रोजन)",
              result.urea,
              Colors.blue.shade100,
            ),

            const SizedBox(height: 8),

            // DAP recommendation
            _buildFertilizerItem(
              "डीएपी (फस्फेट)",
              result.dap,
              Colors.amber.shade100,
            ),

            const SizedBox(height: 8),

            // Potash recommendation
            _buildFertilizerItem(
              "पोटास (K₂O)",
              result.potash,
              Colors.green.shade100,
            ),

            const SizedBox(height: 16),

            // Fertilizer usage note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "नोट: सकारात्मक मान थप्नुपर्ने मात्रा र नकारात्मक मान घटाउनुपर्ने मात्रा जनाउँछ।",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildFertilizerItem(
    String name,
    double value,
    Color backgroundColor,
  ) {
    // Format the value with 2 decimal places
    String formattedValue = value.toStringAsFixed(2);

    // Determine if it's an increase or decrease
    bool isIncrease = value >= 0;
    String actionText = isIncrease ? "थप्नुहोस्" : "घटाउनुहोस्";
    IconData icon = isIncrease ? Icons.add_circle : Icons.remove_circle;
    Color iconColor = isIncrease ? Colors.green : Colors.red;

    // Use absolute value for display
    String displayValue = "${(value * 10).abs().toStringAsFixed(2)} क्विन्टल";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$displayValue $actionText",
                  style: TextStyle(
                    color: isIncrease
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String?> getUserAddress() async {
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final address = await Get.generalDialog<String>(
    barrierDismissible: false,
    pageBuilder: (context, _, __) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'तपाईंको ठेगाना प्रविष्ट गर्नुहोस्',  // Enter your address
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'ठेगाना',  // Address
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'ठेगाना आवश्यक छ';  // Address is required
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('रद्द गर्नुहोस्'),  // Cancel
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Get.back(result: addressController.text.trim());
                        }
                      },
                      child: const Text('पेश गर्नुहोस्'),  // Submit
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  
  return address;
}

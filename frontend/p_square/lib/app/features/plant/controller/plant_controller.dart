import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_square/app/features/plant/services/plant_services.dart';
import 'package:p_square/app/utils/snackbar_utils.dart';
import 'package:p_square/app/features/marketplace/models/category_response_model.dart';
import 'package:p_square/app/features/marketplace/views/product_view.dart';

import '../models/plant_response_mode.dart';
import '../models/crop_prediction_response.dart';
import '../models/user_model.dart';

class PlantController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedPlantType = "Tomato".obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<DiseasePredictionResponse?> predictionResult =
      Rx<DiseasePredictionResponse?>(null);
  RxBool isLoadingRecommendedProducts = false.obs;
  RxList<Product> recommendedProducts = <Product>[].obs;

  // Land conversion related variables
  final TextEditingController aanaController = TextEditingController();
  final TextEditingController quintalController = TextEditingController();
  RxBool isLandPredictionLoading = false.obs;
  Rx<CropPredictionResponse?> cropPredictionResult =
      Rx<CropPredictionResponse?>(null);

  final PlantServices _plantServices = PlantServices();
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> plantTypes = ["Tomato", "Potato", "Maize"];

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
      // clear previous prediction
      predictionResult.value = null;
      recommendedProducts.clear();
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
      // Clear previous prediction
      predictionResult.value = null;
      recommendedProducts.clear();
    }
  }

  // Change selected plant type
  void changePlantType(String type) {
    if (plantTypes.contains(type)) {
      selectedPlantType.value = type;
      // Clear prediction result when plant type changes
      predictionResult.value = null;
      recommendedProducts.clear();
    }
  }

  // Clear selected image
  void clearImage() {
    selectedImage.value = null;
    predictionResult.value = null;
    recommendedProducts.clear();
  }

  // Predict plant disease based on selected type

Future<void> predictPlantDisease() async {
  if (selectedImage.value == null) {
    SnackbarUtils.showNepaliError(
      "त्रुटि",
      "कृपया पहिले एउटा तस्बिर चयन गर्नुहोस्",
    );
    return;
  }

  isLoading.value = true;
  predictionResult.value = null;
  recommendedProducts.clear();
  experts.clear(); // Clear previous experts

  try {
    DiseasePredictionResponse response;

    switch (selectedPlantType.value) {
      case "Tomato":
        response = await _plantServices.predictTomato(selectedImage.value!);
        break;
      case "Potato":
        response = await _plantServices.predictPotato(selectedImage.value!);
        break;
      case "Maize":
        response = await _plantServices.predictMaize(selectedImage.value!);
        break;
      default:
        response = await _plantServices.predictTomato(selectedImage.value!);
    }

    predictionResult.value = response;

    // After successful prediction, fetch recommended products
    await fetchRecommendedProducts(response.predictedClass);
    
    // Also fetch experts
    await fetchExperts();
  } catch (e) {
    SnackbarUtils.showNepaliError(
      "त्रुटि",
      "${selectedPlantType.value}को रोग पहिचान गर्न समस्या भयो (फेरि प्रयास गर्नुहोस्)",
    );
  } finally {
    isLoading.value = false;
  }
}
  // Fetch recommended products based on disease prediction
  Future<void> fetchRecommendedProducts(String diseaseName) async {
    isLoadingRecommendedProducts.value = true;

    try {
      final products = await _plantServices.getRecommendedProducts(diseaseName);
      recommendedProducts.assignAll(products);
    } catch (e) {
      SnackbarUtils.showNepaliError(
        "त्रुटि",
        "सिफारिस गरिएका उत्पादनहरू प्राप्त गर्न समस्या भयो",
      );
    } finally {
      isLoadingRecommendedProducts.value = false;
    }
  }

  // Navigate to product detail
  void navigateToProductDetail(Product product) {
    Get.to(() => ProductView(product));
  }

  // Get Nepali plant type name
  String getPlantTypeNepaliName() {
    switch (selectedPlantType.value) {
      case "Tomato":
        return "टमाटर";
      case "Potato":
        return "आलु";
      case "Maize":
        return "मकै";
      default:
        return selectedPlantType.value;
    }
  }

  // Convert Aana to Hectare
  double aanaToHectare(double aana) {
    // 1 Aana = 0.0031746 Hectare
    return aana * 0.0031746;
  }

  // Convert Quintal to Ton (1 Quintal = 0.1 Ton)
  double quintalToTon(double quintal) {
    return quintal / 10;
  }

  // Predict crop based on land area and production
  Future<void> predictCrop() async {
    if (aanaController.text.isEmpty || quintalController.text.isEmpty) {
      SnackbarUtils.showNepaliError(
        "त्रुटि",
        "कृपया जग्गाको क्षेत्रफल र उत्पादन परिमाण भर्नुहोस्",
      );
      return;
    }

    isLandPredictionLoading.value = true;
    cropPredictionResult.value = null;

    try {
      // Convert Aana to Hectare
      double aana = double.parse(aanaController.text);
      double hectare = aanaToHectare(aana);

      // Convert Quintal to Ton
      double quintal = double.parse(quintalController.text);
      double production = quintalToTon(quintal);

      // Prepare data for API
      Map<String, dynamic> data = {
        "Area_Harvested": hectare.toString(),
        "Production": production.toString(),
      };

      // Call API
      final response = await _plantServices.predictCrop(data);
      cropPredictionResult.value = CropPredictionResponse.fromJson(response);
    } catch (e) {
      SnackbarUtils.showNepaliError(
        "त्रुटि",
        "फसल अनुमान प्राप्त गर्न समस्या भयो (फेरि प्रयास गर्नुहोस्)",
      );
    } finally {
      isLandPredictionLoading.value = false;
    }
  }

  // Format disease name for display
  String formatDiseaseName(String diseaseName) {
    // Replace underscores with spaces
    String formatted = diseaseName.replaceAll('_', ' ');

    if (formatted.contains('Early blight')) {
      return 'प्रारम्भिक डढुवा (Early Blight)';
    } else if (formatted.contains('Late blight')) {
      return 'ढिलो डढुवा (Late Blight)';
    } else if (formatted.contains('Healthy')) {
      return 'स्वस्थ (Healthy)';
    }

    return formatted;
  }

  // Get Nepali crop name
  String getCropNepaliName(String cropName) {
    switch (cropName) {
      case "Coffee, green":
        return "कफी";
      // Add more crop translations as needed
      default:
        return cropName;
    }
  }


  RxBool isLoadingExperts = false.obs;
RxList<User> experts = <User>[].obs;

// Add this method to fetch experts
Future<void> fetchExperts() async {
  isLoadingExperts.value = true;
  try {
    final expertsList = await _plantServices.getExperts();
    experts.assignAll(expertsList);
  } catch (e) {
    SnackbarUtils.showNepaliError(
      "त्रुटि",
      "विशेषज्ञहरू प्राप्त गर्न समस्या भयो",
    );
  } finally {
    isLoadingExperts.value = false;
  }
}



  @override
  void dispose() {
    aanaController.dispose();
    quintalController.dispose();
    super.dispose();
  }
}

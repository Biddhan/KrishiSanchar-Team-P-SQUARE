import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:p_square/app/features/marketplace/models/category_response_model.dart';
import 'package:p_square/app/features/marketplace/models/product_upload_model.dart';
import 'package:p_square/app/features/marketplace/services/marketplace_service.dart';
import 'package:p_square/core/constants/enum_constants.dart';

class ProductUploadController extends GetxController {
  final MarketplaceService _service = MarketplaceService();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Selected image
  final Rxn<File> selectedImage = Rxn<File>();

  // Selected category
  final Rx<CategoryEnum> selectedCategory = CategoryEnum.seeds.obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;

  // Categories list
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    priceController.dispose();
    super.onClose();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final List<CategoryModel> response = await _service.getInitialData();
      categories.assignAll(response);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  // Select image from gallery
  Future<void> pickImage() async {
    try {
      // Request storage permission
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to pick images',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Select image from camera
  Future<void> captureImage() async {
    try {
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'Camera permission is required to take photos',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Set selected category
  void setCategory(CategoryEnum category) {
    selectedCategory.value = category;
  }

  // Upload product
  Future<void> uploadProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // load from local storage
      // final sellerId = ;
      final request = ProductUploadRequest(
        name: nameController.text,
        description: descriptionController.text,
        categoryId: selectedCategory.value.index + 1,
        stock: int.parse(stockController.text),
        unitPrice: int.parse(priceController.text),
        imageFile: selectedImage.value!,
        sellerId: 2,
        // TODO:
      );

      final response = await _service.uploadProduct(request);

      if (response != null) {
        isSuccess.value = true;
        Get.snackbar(
          'Success',
          'Product uploaded successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Clear form after successful upload
        clearForm();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload product: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    stockController.clear();
    priceController.clear();
    selectedImage.value = null;
    selectedCategory.value = CategoryEnum.seeds;
  }
}

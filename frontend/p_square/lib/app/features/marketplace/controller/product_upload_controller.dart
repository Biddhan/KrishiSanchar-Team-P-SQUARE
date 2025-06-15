import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_square/app/utils/secure_storage_util.dart';
import 'package:p_square/app/utils/snackbar_utils.dart';
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

  // Get seller id
  Future<bool> getUserId() async {
    try {
      final userToken = await StorageUtil.getToken();
      if (userToken != null) {
        final userDetails = await _service.getUserDetails(userToken);
        StorageUtil.saveValue("user_id", "${userDetails.userId}");
        return true;
      }
      SnackbarUtils.showNepaliError("त्रुटि", "फेरि प्रयास गर्नुहोस्।");
      return false;
    } catch (e) {
      SnackbarUtils.showNepaliError(
        "त्रुटि",
        "फेरि प्रयास गर्नुहोस्।. ${e.toString()}",
      );
      return false;
    }
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
      var userId = await StorageUtil.getValue("user_id");
      final cookie = await StorageUtil.getToken();
      if (userId == null) {
        final user = await _service.getUserDetails(cookie!);
        userId = "${user.userId}";
      }
      final parsedUserId = int.tryParse(userId) ?? -99999;

      final request = ProductUploadRequest(
        name: nameController.text,
        description: descriptionController.text,
        categoryId: selectedCategory.value.index + 1,
        stock: int.parse(stockController.text),
        unitPrice: int.parse(priceController.text),
        imageFile: selectedImage.value!,
        sellerId: parsedUserId,
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

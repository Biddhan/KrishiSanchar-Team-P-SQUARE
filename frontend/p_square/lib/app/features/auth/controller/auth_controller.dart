import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/auth/services/auth_services.dart';
import 'package:p_square/app/utils/secure_storage_util.dart';

class AuthController extends GetxController {
  // ignore: non_constant_identifier_names
  final AuthServices _AuthServices = AuthServices();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoginView = true.obs; // Toggle between login and signup views
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final Rxn<String> errorMessage = Rxn<String>();
  final Rxn<String> token = Rxn<String>();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();

    super.onClose();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    final savedToken = await StorageUtil.getToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      isLoggedIn.value = true;
    }
  }

  // Toggle between login and signup views
  void toggleAuthView() {
    isLoginView.toggle();
    errorMessage.value = null;
    clearForm();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  // Clear form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Login method
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    errorMessage.value = null;
    isLoading.value = true;

    try {
      final authToken = await _AuthServices.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Save token using secure storage
      await StorageUtil.saveToken(authToken);

      // Also save user email for reference
      await StorageUtil.saveValue('user_email', emailController.text.trim());

      token.value = authToken;
      isLoggedIn.value = true;

      // Close dialog and show success message
      Get.back();
      Get.snackbar(
        'Success',
        'Welcome to KrishiSanchar!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      clearForm();
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    errorMessage.value = null;
    isLoading.value = true;

    try {
      await _AuthServices.register(
        emailController.text.trim(),
        passwordController.text,
        firstNameController.text,
        lastNameController.text,
        middleNameController.text,
        phoneNumberController.text,
        addressController.text,
      );

      // Switch to login view after successful registration
      isLoginView.value = true;
      clearForm();

      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await StorageUtil.deleteToken();
    await StorageUtil.deleteValue('user_email');

    token.value = null;
    isLoggedIn.value = false;

    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Submit form based on current view
  Future<void> submitForm() async {
    if (isLoginView.value) {
      await login();
    } else {
      await register();
    }
  }
}

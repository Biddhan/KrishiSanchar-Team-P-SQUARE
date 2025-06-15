import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/services/marketplace_service.dart';
import 'package:p_square/app/features/profile/models/product_model.dart';
import 'package:p_square/app/features/profile/models/update_user_model.dart';
import 'package:p_square/app/features/profile/services/profile_services.dart';
import 'package:p_square/app/utils/secure_storage_util.dart';
import 'package:p_square/app/utils/snackbar_utils.dart';
import 'package:p_square/core/routes/app_routes.dart';

import '../models/insurance_company_list_modeld.dart';
import '../models/insurance_company_model.dart';
import '../models/insurance_plan_list.dart';
import '../models/insurance_plan_model.dart';
import '../models/order_model.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingOrders = false.obs;
  RxBool isLoadingProducts = false.obs;

  final _profileService = ProfileServices();
  final MarketplaceService _service = MarketplaceService();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Toggle password obscuring
  final RxBool seeOldPassword = false.obs;
  final RxBool seeNewPassword = false.obs;

  // User profile data
  RxString profileImageUrl = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;

  // Save my products in a list
  RxList<dynamic> myProducts = <dynamic>[].obs;
  RxList<dynamic> myOrders = <dynamic>[].obs;

  // Handle expert
  Future<bool> hasAppliedForExpert() async {
    try {
      String? value = await StorageUtil.getValue("applied");
      return value != null && int.parse(value) == 1;
    } catch (e) {
      return false;
    }
  }

  Future<void> markAsApplied() async {
    await StorageUtil.saveValue("applied", "1");
    update();
  }

  // Fetch user profile data
  void fetchUserProfile() async {
    isLoading.value = true;
    try {
      final cookie = await StorageUtil.getToken();
      if (cookie != null) {
        final userData = await _profileService.getUserProfile(cookie);

        // Update user profile data
        userName.value = userData['fullName'] ?? '';
        userEmail.value = userData['email'] ?? '';
        profileImageUrl.value = userData['profileImage'] ?? '';

        // Populate form fields if needed
        firstName.text = userData['firstName'] ?? '';
        lastName.text = userData['lastName'] ?? '';
        middleName.text = userData['middleName'] ?? '';
        email.text = userData['email'] ?? '';
        phoneNumber.text = userData['phoneNumber'] ?? '';
        address.text = userData['address'] ?? '';
      }
    } catch (e) {
      // Handle error
      SnackbarUtils.showNepaliError(
        'त्रुटि',
        'प्रोफाइल लोड हुन सकेन (फेरि प्रयास गर्नुहोस्)',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // logout
  void logout() async {
    isLoading.value = true;
    try {
      await StorageUtil.deleteToken();
      // Navigate to main screen
      Get.offAllNamed(RouteNames.initial);
    } catch (e) {
      Get.snackbar('त्रुटि', 'लगआउट हुन सकेन (फेरि प्रयास गर्नुहोस्)');
    } finally {
      isLoading.value = false;
    }
  }

  void submit() async {
    if ((formKey.currentState!.validate())) {
      await updateUserProfile();
    }
  }

  // Text controllers
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    middleName.dispose();
    email.dispose();
    phoneNumber.dispose();
    address.dispose();
    super.dispose();
  }

  Future<void> getMyProducts() async {
    isLoadingProducts.value = true;
    try {
      final cookie = await StorageUtil.getToken();
      if (cookie != null) {
        final response = await _profileService.myProducts(cookie);

        // Make sure we're getting a list and update the observable
        myProducts.assignAll(response);
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        'त्रुटि',
        'उत्पादनहरू लोड हुन सकेन (फेरि प्रयास गर्नुहोस्)',
      );
      myProducts.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> getMyOrders() async {
    isLoadingOrders.value = true;
    try {
      final cookie = await StorageUtil.getToken();
      if (cookie != null) {
        final response = await _profileService.myOrders(cookie);

        myOrders.assignAll(response);
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        'त्रुटि',
        'अर्डरहरू लोड हुन सकेन (फेरि प्रयास गर्नुहोस्)',
      );
      myOrders.clear();
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;
    try {
      // Getting userId if not found then hit api to get UserId according to token
      var userId = await StorageUtil.getValue("user_id");
      final cookie = await StorageUtil.getToken();
      if (userId == null && cookie != null) {
        final user = await _service.getUserDetails(cookie);
        userId = "${user.userId}";
        await StorageUtil.saveValue("user_id", userId);
      }

      if (cookie != null) {
        final parsedUserId = int.tryParse(userId ?? "") ?? -99999;

        final UpdateUser updatedUser = UpdateUser(
          id: parsedUserId,
          firstName: firstName.text,
          lastName: lastName.text,
          email: email.text,
          phoneNumber: phoneNumber.text,
          address: address.text,
          // Leave password blank
          password: "",
        );

        final response = await _profileService.updateUser(cookie, updatedUser);
        // If the response is false show error
        if (!response) {
          SnackbarUtils.showNepaliError(
            "अपडेट गर्न असफल",
            "तपाईंको विवरण अपडेट गर्दा त्रुटि आयो। कृपया पछि फेरि प्रयास गर्नुहोस् ",
          );
        } else {
          SnackbarUtils.showNepaliSuccess(
            "सफल",
            "प्रयोगकर्ता विवरण सफलतापूर्वक अद्यावधिक गरियो",
          );
          // Refresh user profile data
          fetchUserProfile();
        }
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        "अपडेट गर्न असफल",
        "तपाईंको विवरण अपडेट गर्न असफल",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payment(Order order) async {
    try {
      final cookie = await StorageUtil.getToken();

      final isSuccess = await _service.payment(
        order.id,
        order.totalGrossAmount,
        "esewa",
        cookie!,
      );
      if (isSuccess) {
        SnackbarUtils.showNepaliSuccess(
          "भुक्तानी सफल भयो",
          "तपाईंको भुक्तानी सफलतापूर्वक सम्पन्न भयो। धन्यवाद!",
        );
        getMyOrders();
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        "भुक्तानी असफल भयो",
        "तपाईंको भुक्तानी प्रक्रिया असफल भयो। कृपया पुनः प्रयास गर्नुहोस्।",
      );
    }
  }

  // For insurance company
  RxSet<int> expandedInsuranceIndices = <int>{}.obs;

  RxBool isLoadingInsurance = false.obs;
  RxList<InsuranceCompany> insuranceCompanies = <InsuranceCompany>[].obs;

  Future<void> fetchInsuranceCompanies() async {
    isLoadingInsurance.value = true;

    try {
      final cookie = await StorageUtil.getToken();
      if (cookie != null) {
        final response = await _profileService.insuranceCompanies(cookie);

        final companyList = InsuranceCompanyList.fromJson(response);
        insuranceCompanies.assignAll(companyList.companies);
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        'त्रुटि',
        'बीमा कम्पनीहरू लोड हुन सकेन (फेरि प्रयास गर्नुहोस्)',
      );
      insuranceCompanies.clear();
    } finally {
      isLoadingInsurance.value = false;
    }
  }

  RxMap<int, RxList<InsurancePlan>> insurancePlansMap =
      <int, RxList<InsurancePlan>>{}.obs;
  RxMap<int, RxBool> isLoadingPlans = <int, RxBool>{}.obs;

  // Method to toggle expansion and fetch plans if needed
  void toggleInsuranceExpansion(int index) async {
    final companyId = insuranceCompanies[index].id;

    // If expanding and plans not loaded yet, fetch them
    if (!expandedInsuranceIndices.contains(index)) {
      expandedInsuranceIndices.add(index);

      // Initialize loading state if not exists
      if (!isLoadingPlans.containsKey(companyId)) {
        isLoadingPlans[companyId] = false.obs;
      }

      // Initialize plans list if not exists
      if (!insurancePlansMap.containsKey(companyId)) {
        insurancePlansMap[companyId] = <InsurancePlan>[].obs;

        // Fetch plans for this provider
        await fetchInsurancePlans(companyId);
      }
    } else {
      // Just collapse if already expanded
      expandedInsuranceIndices.remove(index);
    }
  }

  // Method to fetch insurance plans for a specific provider
  Future<void> fetchInsurancePlans(int providerId) async {
    isLoadingPlans[providerId]?.value = true;

    try {
      final cookie = await StorageUtil.getToken();
      if (cookie != null) {
        final response = await _profileService.getProduct(cookie, providerId);

        // Convert the response to InsurancePlan objects
        final planList = InsurancePlanList.fromJson(response);
        insurancePlansMap[providerId]?.assignAll(planList.plans);
      }
    } catch (e) {
      SnackbarUtils.showNepaliError(
        'त्रुटि',
        'बीमा योजनाहरू लोड हुन सकेन (फेरि प्रयास गर्नुहोस्)',
      );
      insurancePlansMap[providerId]?.clear();
    } finally {
      isLoadingPlans[providerId]?.value = false;
    }
  }
}

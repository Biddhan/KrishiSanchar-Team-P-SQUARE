import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/services/marketplace_service.dart';
import 'package:p_square/core/constants/string_constants.dart';
import 'package:snackbarx/snackbarx.dart';

import '../../../../core/constants/enum_constants.dart';
import '../models/category_response_model.dart';
import '../views/product_view.dart';

class MarketplaceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxBool isInitialized = false.obs;

  final _service = MarketplaceService();

  final items = <Product>[].obs;
  final categoryList = <CategoryModel>[].obs;
  final selectedProduct = Rxn<Product>();
  final searchResults = <Product>[].obs;
  final allProducts = <Product>[].obs; // Store all products for easy reset

  // selected category
  Rx<CategoryEnum> selectedCategory = CategoryEnum.tools.obs;

  void selectCategoryById(CategoryEnum category) {
    if (selectedCategory.value == category) {
      return; // Prevent unnecessary updates
    }

    selectedCategory.value = category;
    
    // Only filter by category in search view
    if (isSearching.value) {
      filterItemsByCategory();
    }
    
    // Clear search results when changing category
    searchResults.clear();
    searchBarController.clear();
  }

  void filterItemsByCategory() {
    // If we have categories loaded, filter products by the selected category
    if (categoryList.isEmpty) return; // Prevent filtering if data isn't loaded

    final selectedCategoryId = selectedCategory.value.index + 1; // Adjust index to match API category IDs

    // Find the category with matching ID
    final matchingCategory = categoryList.firstWhereOrNull(
      (category) => category.id == selectedCategoryId,
    );

    // If found, update items with its products
    if (matchingCategory != null) {
      items.assignAll(matchingCategory.products);
    } else {
      // If no matching category found, show all products
      items.assignAll(allProducts);
    }
  }

  // search bar methods
  Future<void> searchString(String text) async {
    if (text.trim().isEmpty) {
      // If search text is empty, show all products for the selected category
      filterItemsByCategory();
      isSearching(false);
      return;
    }

    if (isLoading.value) return; // Prevent multiple simultaneous searches

    isLoading(true);
    isSearching(true);
    try {
      final int categoryId = selectedCategory.value.index + 1; // Adjust index to match API category IDs
      final List<Product> results = await _service.getSearchedItems(
        categoryId,
        text,
      );

      if (results.isEmpty) {
        // If no results, show a message
        Get.snackbar(
          'No Results',
          'No products found matching "$text"',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }

      // Update the search results
      searchResults.assignAll(results);
      // Update the items list with search results
      items.assignAll(results);
    } catch (e) {
      SnackbarX.showError('Search error: ${e.toString()}');
      // On error, revert to showing all products for the category
      filterItemsByCategory();
    } finally {
      isLoading(false);
    }
  }

  // Clear search and show all products for the selected category
  void clearSearch() {
    searchBarController.clear();
    isSearching(false);
    searchResults.clear();
    filterItemsByCategory();
  }

  // Reset to show all products (used when returning to marketplace)
  void resetToAllProducts() {
    if (isSearching.value) {
      isSearching(false);
      searchResults.clear();
      searchBarController.clear();
    }
    // Show all products without filtering
    items.assignAll(allProducts);
  }

  // Prepare for search view
  void prepareForSearchView() {
    // Set search mode
    isSearching(true);
    // Apply category filter
    filterItemsByCategory();
  }

  // load initial data
  Future<void> loadInitialData() async {
    if (isLoading.value || isInitialized.value) {
      return; // Prevent multiple loads
    }

    isLoading(true);
    try {
      final List<CategoryModel> response = await _service.getInitialData();
      categoryList.assignAll(response);

      // Store all products for easy reset
      List<Product> products = [];
      for (var category in response) {
        products.addAll(category.products);
      }
      allProducts.assignAll(products);

      // Show all products in marketplace view
      items.assignAll(allProducts);
      isInitialized(true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> onProductTap(Product product) async {
    selectedProduct.value = product;
    Get.to(() => ProductView(product));
  }

  final cart = <String>[].obs;

  Future<bool> addToCart(String guid) async {
    if (cart.contains(guid)) {
      Get.snackbar(
        StringConstants.alreadyInCartTitle,
        StringConstants.alreadyInCart,
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return false;
    }
    cart.add(guid);
    Get.snackbar(
      'Success',
      'Item added to cart',
      icon: const Icon(Icons.check, color: Colors.white),
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
    );
    return true;
  }

  void removeFromCart(String guid) {
    cart.remove(guid);
  }

  bool isInCart(String guid) {
    return cart.contains(guid);
  }

  // Controllers
  final searchBarController = TextEditingController();

  @override
  void onInit() {
    // Delay initial data loading to prevent UI jank
    Future.delayed(const Duration(milliseconds: 100), () {
      loadInitialData();
    });
    super.onInit();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }
}




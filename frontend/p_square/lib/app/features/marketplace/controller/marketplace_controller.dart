import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/marketplace/models/order_response_model.dart';
import 'package:p_square/app/features/marketplace/services/marketplace_service.dart';
import 'package:p_square/app/features/marketplace/views/cart_view.dart';
import 'package:p_square/app/utils/snackbar_utils.dart';
import 'package:snackbarx/snackbarx.dart';

import '../../../../core/constants/enum_constants.dart';
import '../../../utils/secure_storage_util.dart';
import '../../auth/views/auth_helper_method.dart';
import '../models/cart_item.dart';
import '../models/category_response_model.dart';
import '../views/product_view.dart';
import '../views/widgets/ask_addresss_widget.dart';

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

    final selectedCategoryId =
        selectedCategory.value.index +
        1; // Adjust index to match API category IDs

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
      final int categoryId =
          selectedCategory.value.index +
          1; // Adjust index to match API category IDs
      final List<Product> results = await _service.getSearchedItems(
        categoryId,
        text,
      );

      // Update the search results
      searchResults.assignAll(results);
      // Update the items list with search results
      items.assignAll(results);
    } catch (e) {
      SnackbarX.showError('खोज असफल भयो: ${e.toString()}');
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
        'त्रुटि',
        'उत्पादन लोड गर्न असफल: ${e.toString()}',
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

  // Cart related properties
  final cartItems = <CartItem>[].obs;
  final RxBool isProcessingOrder = false.obs;
  final Rxn<OrderResponse> orderPreview = Rxn<OrderResponse>();

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    isProcessingOrder(true);

    try {
      // Check if product is already in cart
      final existingItem = cartItems.firstWhereOrNull(
        (item) => item.productId == product.id,
      );

      if (existingItem != null) {
        // Update quantity if already in cart
        existingItem.quantity += quantity;
        cartItems.refresh();
      } else {
        cartItems.add(
          CartItem(
            productId: product.id,
            productName: product.name,
            price: product.unitPrice.toDouble(),
            imageUrl: product.imageUrl,
            quantity: quantity,
          ),
        );
      }

      final items = cartItems
          .map(
            (item) => {'productId': item.productId, 'quantity': item.quantity},
          )
          .toList();

      final userToken = await StorageUtil.getToken();
      final response = await _service.getOrderDetails(items, userToken!);

      // Store response
      orderPreview.value = response;

      Get.snackbar(
        'खरिद सूचीमा थपियो',
        'सामान खरिद सूचीमा सफलतापूर्वक थपियो',
        icon: const Icon(Icons.check, color: Colors.white),
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        mainButton: TextButton(
          onPressed: () {
            Get.to(() => const CartView());
          },
          child: const Text(
            'खरिद सूची हेर्नुहोस्',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'त्रुटि',
        'सामान खरिद सूचीमा थप्न असफल: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingOrder(false);
    }
  }

  // Remove from cart - now updates order preview
  Future<void> removeFromCart(int productId) async {
    cartItems.removeWhere((item) => item.productId == productId);

    if (cartItems.isEmpty) {
      // If cart is empty, clear order preview
      orderPreview.value = null;
      return;
    }

    // Update order preview
    await updateOrderPreview();
  }

  // Update quantity - now updates order preview
  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      item.quantity = quantity;
      cartItems.refresh();
      // Update order preview
      await updateOrderPreview();
    }
  }

  // Helper method to update order preview
  Future<void> updateOrderPreview() async {
    isProcessingOrder(true);

    try {
      // Prepare cart items for API
      final items = cartItems
          .map(
            (item) => {'productId': item.productId, 'quantity': item.quantity},
          )
          .toList();

      final userToken = await StorageUtil.getToken();
      final response = await _service.getOrderDetails(items, userToken!);

      // Store response
      orderPreview.value = response;
    } catch (e) {
      Get.snackbar(
        'त्रुटि',
        'अर्डर विवरण असफल: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingOrder(false);
    }
  }

  // Check if product is in cart
  bool isInCart(int productId) {
    return cartItems.any((item) => item.productId == productId);
  }

  // Get cart item quantity
  int getCartItemQuantity(int productId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    return item?.quantity ?? 0;
  }

  // Calculate cart total from order preview
  double get cartTotal {
    return orderPreview.value?.grandTotalAmount ??
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Get cart item count
  int get cartItemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    orderPreview.value = null;
  }

  // Place order
  Future<void> placeOrder() async {
    // Check if user is logged in, if not
    final isAuthenticated = await AuthHelper.checkAuthAndProceed();
    if (!isAuthenticated) {
      return;
    }

    if (cartItems.isEmpty) {
      SnackbarUtils.showNepaliError(
        'खाली खरिद सूची',
        'तपाईंको खरिद सूचीमा कुनै सामान छैन',
      );
      return;
    }

    isProcessingOrder(true);

    try {
      final userToken = orderPreview.value!.token;
      final address = await getUserAddress();
            final authToken = await StorageUtil.getToken();

      if (address != null) {
        await _service.placeOrder(userToken, address, authToken!);
      } else {
        Get.snackbar(
          'सूचना',
          'ठेगाना प्रदान गरिएको छैन',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Clear cart after successful order
      clearCart();

      Get.snackbar(
        'अर्डर सफल भयो',
        'सामान खरिद सूचीमा सफलतापूर्वक थपियो',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'अर्डर असफल',
        'अर्डर राख्न असफल: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingOrder(false);
    }
  }

  // Refresh
  Future<void> refreshMarketplace() async {
    isLoading(true);
    try {
      final List<CategoryModel> response = await _service.getInitialData();
      categoryList.assignAll(response);

      // Update all products
      List<Product> products = [];
      for (var category in response) {
        products.addAll(category.products);
      }
      allProducts.assignAll(products);

      // Reset to show all products
      items.assignAll(allProducts);

      // Clear search if active
      if (isSearching.value) {
        isSearching(false);
        searchResults.clear();
        searchBarController.clear();
      }
    } catch (e) {
      Get.snackbar(
        'त्रुटि',
        'उत्पादनहरू ताजा गर्न असफल: ${e.toString()}',
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

}

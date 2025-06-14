import 'package:dio/dio.dart';
import 'package:p_square/app/features/marketplace/models/category_response_model.dart';
import 'package:p_square/app/features/marketplace/models/product_upload_model.dart';
import 'package:p_square/core/client/dio_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../models/order_response_model.dart';

class MarketplaceService {
  final DioClient _dioClient = DioClient();

  Future<List<Product>> getSearchedItems(int id, String text) async {
    try {
      final response = await _dioClient.get(
        "/api/product/search",
        queryParameters: {"categoryId": id, "query": text},
      );

      // The response is a list of products
      if (response is List) {
        // If response itself is a list
        return response
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is List) {
        // If response.data is a list
        return (response.data as List)
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        // Fallback if response structure is different
        return [];
      }
    } catch (e) {
      print("Error in search: $e");
      rethrow;
    }
  }

  Future<List<CategoryModel>> getInitialData() async {
    try {
      final response = await _dioClient.get("/api/category");

      // Handle different response structures
      if (response is List) {
        // If response itself is a list
        return response
            .map((json) => CategoryModel.fromMap(json as Map<String, dynamic>))
            .toList();
      } else {
        // If response is an object with data property
        try {
          final dynamic responseData = response.data;

          if (responseData is List) {
            // If response.data is a list
            return responseData
                .map(
                  (json) => CategoryModel.fromMap(json as Map<String, dynamic>),
                )
                .toList();
          } else if (responseData is Map &&
              responseData.containsKey('data') &&
              responseData['data'] is List) {
            // If response.data is a map with a 'data' key that is a list
            return (responseData['data'] as List)
                .map(
                  (json) => CategoryModel.fromMap(json as Map<String, dynamic>),
                )
                .toList();
          } else {
            // Fallback
            return [];
          }
        } catch (e) {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product?> loadProductWith(int id) async {
    try {
      final response = await _dioClient.get("/api/product/$id");

      if (response is Map<String, dynamic>) {
        // If response itself is a map
        return Product.fromMap(response);
      } else if (response.data != null) {
        // If response has a data property
        return Product.fromMap(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> uploadProduct(ProductUploadRequest request) async {
    try {
      // Get file extension
      final fileExtension = path
          .extension(request.imageFile.path)
          .toLowerCase();

      // Determine content type based on file extension
      String contentType;
      if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
        contentType = 'image/jpeg';
      } else if (fileExtension == '.png') {
        contentType = 'image/png';
      } else if (fileExtension == '.gif') {
        contentType = 'image/gif';
      } else {
        contentType = 'application/octet-stream';
      }

      FormData formData = FormData.fromMap({
        'Name': request.name,
        'Description': request.description,
        'CategoryId': request.categoryId,
        'Stock': request.stock,
        'SellerId': request.sellerId,
        'UnitPrice': request.unitPrice,
        'Image': await MultipartFile.fromFile(
          request.imageFile.path,
          filename: path.basename(request.imageFile.path),
          contentType: MediaType.parse(contentType),
        ),
      });

      final response = await _dioClient.post(
        "/api/product",
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderResponse> placeOrder(List<Map<String, dynamic>> cartItems) async {
    try {
      final response = await _dioClient.post(
        "/api/orders",
        data: {"items": cartItems},
      );

      return OrderResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderResponse> getOrderDetails(String orderId) async {
    try {
      final response = await _dioClient.get("/api/orders/$orderId");
      return OrderResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

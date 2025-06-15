import 'package:dio/dio.dart';
import 'package:p_square/app/features/profile/models/update_user_model.dart';
import 'package:p_square/core/client/dio_client.dart';

class ProfileServices {
  final _dioClient = DioClient();

  // Get user profile data
  Future<Map<String, dynamic>> getUserProfile(String cookie) async {
    try {
      final response = await _dioClient.get(
        "/api/user",
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );
      return response is Map<String, dynamic> ? response : {};
    } catch (e) {
      rethrow;
    }
  }

  // Get user's products
  Future<List<dynamic>> myProducts(String cookie) async {
    try {
      final response = await _dioClient.get(
        "/api/user/my-products",
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );

      if (response is List) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<bool> updateUser(String cookie, UpdateUser changedUser) async {
    try {
      final response = await _dioClient.put(
        "/api/user",
        data: changedUser.toJson(),
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );

      return response != null;
    } catch (e) {
      rethrow;
    }
  }

  // Get user's orders
  Future<List<dynamic>> myOrders(String cookie) async {
    try {
      final response = await _dioClient.get(
        "/api/user/my-orders",
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );

      if (response is List) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // For insurance
  Future<List<dynamic>> insuranceCompanies(String cookie) async {
    try {
      final response = await _dioClient.get(
        "/api/insurance/providers",
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );

      if (response is List) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get Product insurance Company
  Future<List<dynamic>> getProduct(String cookie, int providerId) async {
    try {
      final response = await _dioClient.get(
        "/api/insurance/products/by-provider/$providerId",
        options: Options(headers: {"Cookie": "c_user=$cookie"}),
      );

      if (response is List) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}

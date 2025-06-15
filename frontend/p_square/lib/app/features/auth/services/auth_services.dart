import 'dart:convert';

import 'package:p_square/app/features/auth/model/token_response.dart';
import 'package:p_square/core/client/dio_client.dart';

class AuthServices {
  final DioClient _dioClient = DioClient();

  Future<String> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        "/api/auth/login",
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        return TokenResponse.fromJson(response.data).token;
      }
      throw Exception("Failed to login");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastname,
    String middleName,
    String phonenumber,
    String address,
  ) async {
    try {
      final response = await _dioClient.post(
        "/api/auth/register",
        data: jsonEncode({
          "firstName": firstName,
          "lastName": lastname,
          "middleName": middleName,
          "phoneNumber": phonenumber,
          "address": address,
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        return;
      }
      throw Exception("Failed to register client");
    } catch (e) {
      rethrow;
    }
  }
}

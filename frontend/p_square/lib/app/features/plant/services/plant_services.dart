import 'dart:io';
import 'package:p_square/core/client/dio_client_plant.dart';
import 'package:p_square/app/features/marketplace/models/category_response_model.dart';

import '../../../../core/client/dio_client.dart';
import '../models/plant_response_mode.dart';
import '../models/user_model.dart';

class PlantServices {
  final DioClientPlant _dioClientPlant = DioClientPlant();
  final DioClient _dioClient = DioClient();

  Future<DiseasePredictionResponse> predictPlant(
    String plantType,
    File imageFile,
  ) async {
    try {
      final response = await _dioClientPlant.uploadFile(
        "/predict/$plantType",
        imageFile,
      );
      return DiseasePredictionResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DiseasePredictionResponse> predictTomato(File imageFile) async {
    return await predictPlant("Tomato", imageFile);
  }

  Future<DiseasePredictionResponse> predictPotato(File imageFile) async {
    return await predictPlant("Potato", imageFile);
  }

  Future<DiseasePredictionResponse> predictMaize(File imageFile) async {
    return await predictPlant("Maize", imageFile);
  }

  Future<Map<String, dynamic>> predictCrop(Map<String, dynamic> data) async {
    try {
      final response = await _dioClientPlant.post("/predict/crop", data: data);

      // Ensure we're returning the expected format
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception("Unexpected response format from crop prediction API");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getExperts() async {
    try {
      final response = await _dioClient.get("/api/user/get-experts");

      if (response is List) {
        return response.map((json) => User.fromJson(json)).toList();
      } else if (response.data is List) {
        return (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getRecommendedProducts(String diseaseName) async {
    try {
      final response = await _dioClient.get(
        "/api/product/get-product-by-description",
        queryParameters: {"description": diseaseName},
      );

      if (response is List) {
        return (response).map((item) => Product.fromMap(item)).toList();
      } else if (response.data is Map && response.data['products'] is List) {
        return (response.data['products'] as List)
            .map((item) => Product.fromMap(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}

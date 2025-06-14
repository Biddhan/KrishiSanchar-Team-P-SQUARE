import 'package:p_square/app/features/sell/models/selling_product_model.dart';
import 'package:p_square/core/client/dio_client.dart';

final DioClient _dioClient = DioClient();

class SellService {
  Future<dynamic> sellProduct(SellingProductModel product) async {
    try {
      // final response = await _dioClient.post("path/", data: product.toJson());
      final response = {};
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

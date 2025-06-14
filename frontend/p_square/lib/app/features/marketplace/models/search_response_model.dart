import 'package:p_square/app/features/marketplace/models/category_response_model.dart';

class SearchResponse {
  final List<Product> products;

  SearchResponse({required this.products});

  factory SearchResponse.fromList(List<dynamic> json) {
    return SearchResponse(
      products: json
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

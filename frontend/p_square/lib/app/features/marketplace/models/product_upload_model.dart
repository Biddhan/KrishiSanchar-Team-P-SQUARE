import 'dart:io';

class ProductUploadRequest {
  final String name;
  final String description;
  final int categoryId;
  final int stock;
  final int sellerId;
  final int unitPrice;
  final File imageFile;

  ProductUploadRequest({
    required this.name,
    required this.description,
    required this.categoryId,
    required this.stock,
    required this.unitPrice,
    required this.sellerId,
    required this.imageFile,
  });
}

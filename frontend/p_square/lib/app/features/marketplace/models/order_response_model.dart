class OrderResponse {
  final Map<String, Package> packages;
  final double grandTotalAmount;

  OrderResponse({
    required this.packages,
    required this.grandTotalAmount,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final packagesJson = json['packages'] as Map<String, dynamic>;
    final packages = packagesJson.map((key, value) =>
      MapEntry(key, Package.fromJson(value)));

    return OrderResponse(
      packages: packages,
      grandTotalAmount: (json['grandTotalAmount'] as num).toDouble(),
    );
  }
}

class Package {
  final String soldBy;
  final List<Item> items;
  final double deliveryCharge;
  final double packageTotal;

  Package({
    required this.soldBy,
    required this.items,
    required this.deliveryCharge,
    required this.packageTotal,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      soldBy: json['soldBy'],
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      packageTotal: (json['packageTotal'] as num).toDouble(),
    );
  }
}

class Item {
  final int productId;
  final String productName;
  final int quantity;
  final double subTotalAmount;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.subTotalAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      subTotalAmount: (json['subTotalAmount'] as num).toDouble(),
    );
  }
}

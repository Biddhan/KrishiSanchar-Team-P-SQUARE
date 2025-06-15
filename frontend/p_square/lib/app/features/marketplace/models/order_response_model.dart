class OrderResponse {
  final String token;
  final Map<String, Package> packages;
  final double grandTotalAmount;
  final String deliveryAddress;

  OrderResponse({
    required this.token,
    required this.packages,
    required this.grandTotalAmount,
    required this.deliveryAddress,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final packagesJson = json['packages'] as Map<String, dynamic>;
    final packages = packagesJson.map((key, value) =>
        MapEntry(key, Package.fromJson(value as Map<String, dynamic>)));

    return OrderResponse(
      token: json['token'] as String,
      packages: packages,
      grandTotalAmount: (json['grandTotalAmount'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
    );
  }
}

class Package {
  final String soldBy;
  final int sellerId; // Added missing field
  final List<Item> items;
  final double deliveryCharge;
  final double packageTotal;

  Package({
    required this.soldBy,
    required this.sellerId,
    required this.items,
    required this.deliveryCharge,
    required this.packageTotal,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      soldBy: json['soldBy'] as String,
      sellerId: json['sellerId'] as int, // Added
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
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
  final double subNetTotalAmount; // Added missing field

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.subTotalAmount,
    required this.subNetTotalAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      subTotalAmount: (json['subTotalAmount'] as num).toDouble(),
      subNetTotalAmount: (json['subNetTotalAmount'] as num).toDouble(), // Added
    );
  }
}
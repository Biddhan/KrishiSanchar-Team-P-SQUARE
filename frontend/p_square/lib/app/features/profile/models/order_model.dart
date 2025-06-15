import 'package:intl/intl.dart';

class Order {
  final int id;
  final String guid;
  final int buyerId;
  final Buyer buyer;
  final String createdDate;
  final String createdTime;
  final OrderStatus orderStatus;
  final String deliveryAddress;
  final double totalGrossAmount;
  final List<OrderItem>? orderItems;

  Order({
    required this.id,
    required this.guid,
    required this.buyerId,
    required this.buyer,
    required this.createdDate,
    required this.createdTime,
    required this.orderStatus,
    required this.deliveryAddress,
    required this.totalGrossAmount,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      guid: json['guid'],
      buyerId: json['buyerId'],
      buyer: Buyer.fromJson(json['buyer']),
      createdDate: json['createdDate'],
      createdTime: json['createdTime'],
      orderStatus: OrderStatus.fromJson(json['orderStatus']),
      deliveryAddress: json['deliveryAddress'] ?? 'Not specified',
      totalGrossAmount: (json['totalGrossAmount'] as num).toDouble(),
      orderItems: json['orderItems'] != null
          ? List<OrderItem>.from(
              json['orderItems'].map((x) => OrderItem.fromJson(x)))
          : null,
    );
  }
}

class Buyer {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;

  Buyer({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }
}

class OrderStatus {
  final String name;
  final int id;

  OrderStatus({
    required this.name,
    required this.id,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      name: json['name'],
      id: json['id'],
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double totalAmount;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.totalAmount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}

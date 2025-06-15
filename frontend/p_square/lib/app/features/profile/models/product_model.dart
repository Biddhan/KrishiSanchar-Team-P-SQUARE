class Product {
  final int id;
  final String guid;
  final String name;
  final String description;
  final String imageUrl;
  final int stock;
  final int reserve;
  final double unitPrice;
  final double displayPrice;
  final int categoryId;
  final int sellerId;
  final Seller seller;
  final String createdDate;
  final String updatedDate;
  final String updatedTime;
  final String createdTime;
  final Status status;

  Product({
    required this.id,
    required this.guid,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.reserve,
    required this.unitPrice,
    required this.displayPrice,
    required this.categoryId,
    required this.sellerId,
    required this.seller,
    required this.createdDate,
    required this.updatedDate,
    required this.updatedTime,
    required this.createdTime,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      guid: json['guid'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      stock: json['stock'],
      reserve: json['reserve'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      displayPrice: (json['displayPrice'] as num).toDouble(),
      categoryId: json['categoryId'],
      sellerId: json['sellerId'],
      seller: Seller.fromJson(json['seller']),
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
      updatedTime: json['updatedTime'],
      createdTime: json['createdTime'],
      status: Status.fromJson(json['status']),
    );
  }
}

class Seller {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final Status status;
  final Role role;

  Seller({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.role,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      status: Status.fromJson(json['status']),
      role: Role.fromJson(json['role']),
    );
  }
}

class Status {
  final String name;
  final int id;

  Status({
    required this.name,
    required this.id,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      name: json['name'],
      id: json['id'],
    );
  }
}

class Role {
  final String name;
  final int id;

  Role({
    required this.name,
    required this.id,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
      id: json['id'],
    );
  }
}

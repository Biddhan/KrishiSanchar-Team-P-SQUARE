class Product {
  int id;
  String guid;
  String name;
  String description;
  String imageUrl;
  int stock;
  dynamic reserve;
  double unitPrice;
  double displayPrice;
  int categoryId;
  DateTime createdDate;
  DateTime updatedDate;
  String updatedTime;
  String createdTime;
  Status status;

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
    required this.createdDate,
    required this.updatedDate,
    required this.updatedTime,
    required this.createdTime,
    required this.status,
  });

  factory Product.fromMap(Map<String, dynamic> json) {
    try {
      return Product(
        id: json["id"] ?? 0,
        guid: json["guid"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        stock: json["stock"] ?? 0,
        reserve: json["reserve"],
        unitPrice: json["unitPrice"] ?? 0,
        displayPrice: (json["displayPrice"] ?? 0).toDouble(),
        categoryId: json["categoryId"] ?? 0,
        createdDate: json["createdDate"] != null 
            ? DateTime.parse(json["createdDate"]) 
            : DateTime.now(),
        updatedDate: json["updatedDate"] != null 
            ? DateTime.parse(json["updatedDate"]) 
            : DateTime.now(),
        updatedTime: json["updatedTime"] ?? '',
        createdTime: json["createdTime"] ?? '',
        status: json["status"] != null 
            ? Status.fromMap(json["status"]) 
            : Status(name: 'Unknown', id: 0),
      );
    } catch (e) {
      throw Exception('Error parsing Product: $e');
    }
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "guid": guid,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "stock": stock,
    "reserve": reserve,
    "unitPrice": unitPrice,
    "displayPrice": displayPrice,
    "categoryId": categoryId,
    "createdDate": createdDate.toIso8601String(),
    "updatedDate": updatedDate.toIso8601String(),
    "updatedTime": updatedTime,
    "createdTime": createdTime,
    "status": status.toMap(),
  };
}

class CategoryModel {
  int id;
  String name;
  List<Product> products;

  CategoryModel({
    required this.id, 
    required this.name, 
    required this.products
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    try {
      return CategoryModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        products: json["products"] != null
            ? List<Product>.from(
                json["products"].map((x) => Product.fromMap(x)),
              )
            : <Product>[],
      );
    } catch (e) {
      throw Exception('Error parsing CategoryModel: $e');
    }
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
  };
}

class Status {
  String name;
  int id;

  Status({required this.name, required this.id});

  factory Status.fromMap(Map<String, dynamic> json) {
    try {
      return Status(
        name: json["name"] ?? '',
        id: json["id"] ?? 0,
      );
    } catch (e) {
      throw Exception('Error parsing Status: $e');
    }
  }

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
  };
}

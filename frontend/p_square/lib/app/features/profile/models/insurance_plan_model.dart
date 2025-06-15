class InsurancePlan {
  final int id;
  final int providerId;
  final dynamic provider; // Can be null based on your JSON
  final String name;
  final String category;
  final String description;

  InsurancePlan({
    required this.id,
    required this.providerId,
    this.provider,
    required this.name,
    required this.category,
    required this.description,
  });

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      id: json['id'] as int,
      providerId: json['providerId'] as int,
      provider: json['provider'],
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'provider': provider,
      'name': name,
      'category': category,
      'description': description,
    };
  }
}
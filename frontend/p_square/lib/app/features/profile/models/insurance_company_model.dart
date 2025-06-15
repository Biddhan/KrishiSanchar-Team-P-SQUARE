class InsuranceCompany {
  final int id;
  final String name;
  final String contactInfo;
  final String websiteUrl;

  InsuranceCompany({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.websiteUrl,
  });

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    return InsuranceCompany(
      id: json['id'] as int,
      name: json['name'] as String,
      contactInfo: json['contactInfo'] as String,
      websiteUrl: json['websiteUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'websiteUrl': websiteUrl,
    };
  }
}
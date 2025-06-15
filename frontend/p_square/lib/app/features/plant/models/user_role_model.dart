class UserRole {
  final String name;
  final int id;

  UserRole({
    required this.name,
    required this.id,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      name: json['name'] as String,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };
}
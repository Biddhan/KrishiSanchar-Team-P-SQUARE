class UserStatus {
  final String name;
  final int id;

  UserStatus({
    required this.name,
    required this.id,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      name: json['name'] as String,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };
}
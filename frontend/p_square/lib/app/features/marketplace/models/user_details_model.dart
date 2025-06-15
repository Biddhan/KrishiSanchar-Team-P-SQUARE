class User {
  final int userId;
  final String email;
  final String role;

  User({
    required this.userId,
    required this.email,
    required this.role,
  });

  // JSON Parsing
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'role': role,
  };

  // Utility Methods
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isGeneralUser => role.toLowerCase() == 'general';
  
  // Empty user factory
  factory User.empty() => User(
    userId: 0,
    email: '',
    role: '',
  );
}
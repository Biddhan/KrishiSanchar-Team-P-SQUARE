import 'user_role_model.dart';
import 'user_status_model.dart';

class User {
  final int id;
  final String fullName;
  final String userName;
  final String passwordHash;
  final String email;
  final String phoneNumber;
  final String address;
  final String createdDate;
  final String createdTime;
  final String? updatedDate;
  final String? updatedTime;
  final String token;
  final bool isVerified;
  final UserStatus status;
  final UserRole role;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.passwordHash,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.createdDate,
    required this.createdTime,
    this.updatedDate,
    this.updatedTime,
    required this.token,
    required this.isVerified,
    required this.status,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      userName: json['userName'] as String,
      passwordHash: json['passwordHash'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      createdDate: json['createdDate'] as String,
      createdTime: json['createdTime'] as String,
      updatedDate: json['updatedDate'],
      updatedTime: json['updatedTime'],
      token: json['token'] as String,
      isVerified: json['isVerified'] as bool,
      status: UserStatus.fromJson(json['status'] as Map<String, dynamic>),
      role: UserRole.fromJson(json['role'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'userName': userName,
    'passwordHash': passwordHash,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'createdDate': createdDate,
    'createdTime': createdTime,
    'updatedDate': updatedDate,
    'updatedTime': updatedTime,
    'token': token,
    'isVerified': isVerified,
    'status': status.toJson(),
    'role': role.toJson(),
  };
}
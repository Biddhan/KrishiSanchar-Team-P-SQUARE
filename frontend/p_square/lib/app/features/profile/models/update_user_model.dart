class UpdateUser {
  final int id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  UpdateUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  });


  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'middleName': middleName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'password': password, // Remember to hash before sending to server
  };

}
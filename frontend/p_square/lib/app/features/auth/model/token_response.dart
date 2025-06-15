class TokenResponse {
  final String token;

  TokenResponse({required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}
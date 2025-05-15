class LoginResponse {
  final String message;
  final Map<String, dynamic> entity;

  LoginResponse({required this.message, required this.entity});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      entity: json['entity'],
    );
  }
}


class Customer {
  final String message;
  final int statusCode;
  final List<Map<String, dynamic>> entity;

  Customer({
    required this.message,
    required this.statusCode,
    required this.entity,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      entity: List<Map<String, dynamic>>.from(json['entity'] ?? []),
    );
  }
}

class CollectionResponse {
  final String customerCode;
  final String unitOfMeasure;
  final int quantity;
  // Add other fields as necessary

  CollectionResponse({required this.customerCode, required this.unitOfMeasure, required this.quantity});

  factory CollectionResponse.fromJson(Map<String, dynamic> json) {
    return CollectionResponse(
      customerCode: json['customerCode'] ?? '',
      unitOfMeasure: json['unitOfMeasure'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}

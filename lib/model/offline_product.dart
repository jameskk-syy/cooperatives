class OfflineProduct {
  final String customerCode;
  final String unitOfMeasure;
  final int quantity;

  OfflineProduct({
    required this.customerCode,
    required this.unitOfMeasure,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerCode': customerCode,
      'unitOfMeasure': unitOfMeasure,
      'quantity': quantity,
    };
  }
}

class ProductRecord {
  final String postedTime;
  final int quantity;
  final String customerName;

  ProductRecord({
    required this.postedTime,
    required this.quantity,
    required this.customerName,
  });

  factory ProductRecord.fromJson(Map<String, dynamic> json) {
    return ProductRecord(
      postedTime: json['postedTime'],
      quantity: json['quantity'],
      customerName: json['customerName'],
    );
  }
}
import 'package:cooperativeapp/model/product_record.dart';

class Product {
  final String message;
  final int statusCode;
  final List<ProductRecord>? entity;

  Product({
    required this.message,
    required this.statusCode,
    required this.entity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['entity'] as List;
    List<ProductRecord> records = list.map((i) => ProductRecord.fromJson(i)).toList();

    return Product(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: records,
    );
  }
}
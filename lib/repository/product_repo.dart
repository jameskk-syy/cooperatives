import 'dart:convert';
import 'package:cooperativeapp/domain/api_domain.dart';
import 'package:cooperativeapp/httpInterceptor/http_interceptor.dart';
import 'package:cooperativeapp/model/product_record.dart';
import 'package:cooperativeapp/response/products_response.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  static Future<List<ProductRecord>> getAllProducts() async {
    try {
      var url = Uri.parse(ApiConstants.products);
      final headers = await HeaderInterceptor.getHeaders();
      final response = await http.get(
        url,
        headers: headers,
      );
      
       print("my headers $headers");
      if (response.statusCode == 200) {
        final productResponse = Product.fromJson(jsonDecode(response.body));

        return productResponse.entity ?? [];
      } else {
        throw Exception('Failed to get all products: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Getting products failed: $error');
    }
  }
}

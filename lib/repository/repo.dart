import 'dart:convert';
import 'package:cooperativeapp/domain/api_domain.dart';
import 'package:cooperativeapp/httpInterceptor/http_interceptor.dart';
import 'package:cooperativeapp/response/collection_response.dart';
import 'package:cooperativeapp/response/login_response.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  static Future<LoginResponse> login(String username, String password) async {
    try {
      var url = Uri.parse(ApiConstants.auth);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print(jsonDecode(response.body)); // Good for debugging

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('wrong_credentials');
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (error) {
      print("error");
      throw Exception('Login failed: $error');
    }
  }
static Future<CollectionResponse> addCollection(String customerCode, int quantity, String unitOfMeasure) async {
  try {
    var url = Uri.parse(ApiConstants.addCollection);
    final headers = await HeaderInterceptor.getHeaders();
    final response = await http.post(
      url,
      headers:headers,
      body: jsonEncode({
        'customerCode': customerCode,
        'quantity': quantity,
        'unitOfMeasure': unitOfMeasure
      }),
    );

    print(jsonDecode(response.body));
    print(response.statusCode); // Debug the response body

    if (response.statusCode == 200) {
      return CollectionResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Wrong credentials');
    } else {
      
      throw Exception('Failed to create collection: ${response.statusCode}');
    }
  } catch (error) {
    print("Error: $error");
    throw Exception('Failed to create collection: $error');
  }
}

}

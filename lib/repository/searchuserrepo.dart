import 'dart:convert';
import 'package:cooperativeapp/domain/api_domain.dart';
import 'package:cooperativeapp/response/customerresponse.dart';
import 'package:http/http.dart' as http;

class CustomerRepository {
  Future<Customer> fetchCustomers(String code) async {
    // Append the code as a query parameter to the URL
    var url = Uri.parse('${ApiConstants.searchmember}/get/all/members'); 
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'entityId': '0003',
          'username':'lucas'
        },
      );
      print(jsonDecode(response.body)); // Good for debugging

      if (response.statusCode == 200 ) {
        return Customer.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Customer not found');
      } else {
        throw Exception('Failed to fetch customer: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw Exception('Search failed: $error');
    }
  }
}

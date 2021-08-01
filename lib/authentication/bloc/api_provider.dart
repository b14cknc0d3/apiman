import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  static final baseUrl = "http://127.0.0.1:8080";
  static final loginUrl = "$baseUrl/api/token";
  Map<String, String> json_header = {"Accept": "application/json"};
  Future<String> login(String email, String password) async {
    final response = await Future.delayed(
      Duration(milliseconds: 1000),
      () => http.post(Uri.parse("$loginUrl"),
          headers: json_header,
          body: {"email": "$email", "password": "$password"}),
    );
    var data = json.decode(response.body);
    print(data);
    return data;
  }

// foot
}

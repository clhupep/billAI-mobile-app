import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../utils/config.dart';

class ApiService {
  Future<String> login(String email) async {
    final response = await http.post(Uri.parse('$userApi/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email})).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Login failed');
    final json = jsonDecode(response.body);
    if (json is! Map || json['id'] is! String) throw Exception('Invalid response');
    return json['id'] as String;
  }

  Future<List<Category>> categories(String userId) async {
    final response = await http.get(Uri.parse('$categoryApi/load'),
      headers: {'X-UserID': userId}).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Categories unavailable');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['categories'] as List? ?? []).map((item) => Category.fromJson(item as Map<String, dynamic>)).toList();
  }
}

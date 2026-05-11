import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class ApiService {
  // 10.0.2.2 là IP mặc định để máy ảo Android kết nối với localhost máy tính
  static const String baseUrl = "http://10.0.2.2:5000/api";

  static Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  static Future<http.Response> register(String fullName, String email, String password) async {
    return await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fullName": fullName, "email": email, "password": password}),
    );
  }

  static Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse("$baseUrl/foods"));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Food.fromJson(item)).toList();
    } else {
      throw Exception("Không thể tải danh sách món ăn");
    }
  }
  static Future<void> saveCart(String userId, List<Map<String, dynamic>> items) async {
    await http.post(
      Uri.parse("$baseUrl/cart/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "items": items}),
    );
  }

  static Future<Map<String, dynamic>> getCart(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/cart/$userId"));
    return jsonDecode(response.body);
  }
}
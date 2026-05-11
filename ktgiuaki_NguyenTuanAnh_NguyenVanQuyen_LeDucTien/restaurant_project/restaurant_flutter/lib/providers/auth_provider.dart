import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  bool get isAuth => _token != null;
  Map<String, dynamic>? get user => _user;

  // Hàm xử lý Đăng nhập
  Future<String?> signIn(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        _token = data['token'];
        _user = data['user'];
        notifyListeners();
        return null; // Không có lỗi
      } else {
        return data['msg'] ?? "Lỗi đăng nhập";
      }
    } catch (e) {
      return "Không thể kết nối đến Server";
    }
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
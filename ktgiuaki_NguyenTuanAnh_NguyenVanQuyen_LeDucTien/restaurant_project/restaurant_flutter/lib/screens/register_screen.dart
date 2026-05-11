import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng điền đủ thông tin")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.register(_nameController.text, _emailController.text, _passController.text);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công! Hãy đăng nhập.")));
        Navigator.pop(context); // Quay lại màn login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email đã tồn tại hoặc lỗi đăng ký")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không kết nối được server")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(hintText: "Full Name")),
            TextField(controller: _emailController, decoration: const InputDecoration(hintText: "Email")),
            TextField(controller: _passController, decoration: const InputDecoration(hintText: "Password"), obscureText: true),
            const SizedBox(height: 30),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue[800]),
                  onPressed: _handleRegister, 
                  child: const Text("Register Account", style: TextStyle(color: Colors.white))
                ),
          ],
        ),
      ),
    );
  }
}
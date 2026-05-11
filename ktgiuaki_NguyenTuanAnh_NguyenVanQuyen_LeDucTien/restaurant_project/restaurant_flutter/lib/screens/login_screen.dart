import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")));
      return;
    }

    setState(() => _isLoading = true);
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String? error = await auth.signIn(_emailController.text, _passwordController.text);

    setState(() => _isLoading = false);

    if (error == null) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    // THÊM DÒNG NÀY ĐỂ TẢI GIỎ HÀNG CỦA USER ĐÓ VỀ:
    await Provider.of<CartProvider>(context, listen: false).fetchCartFromAtlas(user!['id']);
    
    Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Thất bại -> Hiện lỗi từ Backend (Ví dụ: "Mật khẩu sai")
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          children: [
            const Text("Restaurant App", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 60),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email (Test@gmail.com)"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "Mật khẩu"),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chức năng Quên mật khẩu đã gửi đến Email")));
                },
                child: const Text("Forgot Password?", style: TextStyle(color: Colors.orange)),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _submit,
                  child: const Text("Sign In", style: TextStyle(color: Colors.black54, fontSize: 18)),
                ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
                onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
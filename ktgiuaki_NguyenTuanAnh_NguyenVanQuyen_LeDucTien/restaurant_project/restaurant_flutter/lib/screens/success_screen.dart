import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy số tiền được truyền từ màn hình Cart
    final totalAmount = ModalRoute.of(context)!.settings.arguments as double;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Payment Complete", style: TextStyle(color: Colors.red, fontSize: 18)),
              const SizedBox(height: 50),
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text("Payment Successful", style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Your payment has been approved!", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Text("₹ ${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Xóa giỏ hàng sau khi thanh toán xong
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                  // Quay về màn hình Home và xóa hết các màn hình cũ trong stack
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final subTotal = cart.totalAmount;
    final tax = subTotal * 0.08;
    final delivery = subTotal > 0 ? 30.0 : 0.0;
    final totalPay = subTotal + tax + delivery;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart", style: TextStyle(color: Colors.red))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                var item = cart.items.values.toList()[i];
                return ListTile(
                  leading: Image.network(item.image, width: 40),
                  title: Text(item.name, style: const TextStyle(color: Colors.red)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.remove), onPressed: () => cart.removeOneItem(item.id)),
                    Text("${item.quantity}"),
                    IconButton(icon: const Icon(Icons.add), onPressed: () => cart.addItem(item.id, item.name, item.price, item.image)),
                    Text("₹${item.price * item.quantity}"),
                  ]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: Column(children: [
              _row("Items Total", subTotal),
              _row("Taxes (8%)", tax),
              _row("Delivery Charges", delivery),
              const Divider(),
              _row("Total Pay", totalPay, isBold: true),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.pushNamed(context, '/success', arguments: totalPay),
                child: const Text("Proceed To Pay", style: TextStyle(color: Colors.white)),
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget _row(String t, double v, {bool isBold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(t, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      Text("₹${v.toStringAsFixed(2)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    ]),
  );
}
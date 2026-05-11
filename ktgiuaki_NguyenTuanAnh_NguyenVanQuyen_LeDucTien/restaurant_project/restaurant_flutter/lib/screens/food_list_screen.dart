import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';

class FoodListScreen extends StatelessWidget {
  final String categoryName;
  const FoodListScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName), centerTitle: true),
      body: FutureBuilder<List<Food>>(
        future: ApiService.fetchFoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          // Lọc món ăn theo loại (Cuisine)
          final foods = snapshot.data!.where((f) => f.category == categoryName).toList();

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (ctx, i) => Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(foods[i].image, height: 150, fit: BoxFit.cover),
                  ListTile(
                    title: Text(foods[i].name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    subtitle: Text(foods[i].category),
                    trailing: Text("₹ ${foods[i].price}", style: const TextStyle(fontSize: 18)),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        foods[i].id, foods[i].name, foods[i].price, foods[i].image
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã thêm vào giỏ hàng!"), duration: Duration(seconds: 1)));
                    },
                    child: const Text("ADD TO CART", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
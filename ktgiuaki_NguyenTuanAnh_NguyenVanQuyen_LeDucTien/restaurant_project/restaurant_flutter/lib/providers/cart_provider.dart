import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CartItem {
  final String id, name, image;
  final double price;
  int quantity;
  CartItem({required this.id, required this.name, required this.price, required this.image, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  String? _userId;

  Map<String, CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // 1. Đồng bộ từ Atlas về khi Login thành công
  Future<void> fetchCartFromAtlas(String userId) async {
    _userId = userId;
    try {
      final data = await ApiService.getCart(userId); // Giả sử hàm này trong ApiService đã có
      List itemsFromServer = data['items'];
      _items = {};
      for (var item in itemsFromServer) {
        final f = item['foodId'];
        _items[f['_id']] = CartItem(
          id: f['_id'], name: f['name'], price: f['price'].toDouble(), image: f['image'], quantity: item['quantity'],
        );
      }
      notifyListeners();
    } catch (e) { print("Lỗi đồng bộ giỏ hàng: $e"); }
  }

  // 2. Tự động gửi dữ liệu lên Atlas mỗi khi thay đổi
  void _sync() {
    if (_userId == null) return;
    List<Map<String, dynamic>> data = _items.values.map((i) => {"foodId": i.id, "quantity": i.quantity}).toList();
    ApiService.saveCart(_userId!, data);
  }

  void addItem(String id, String name, double price, String image) {
    if (_items.containsKey(id)) {
      _items.update(id, (ex) => CartItem(id: ex.id, name: ex.name, price: ex.price, image: ex.image, quantity: ex.quantity + 1));
    } else {
      _items.putIfAbsent(id, () => CartItem(id: id, name: name, price: price, image: image));
    }
    notifyListeners(); _sync();
  }

  void removeOneItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items.update(id, (ex) => CartItem(id: ex.id, name: ex.name, price: ex.price, image: ex.image, quantity: ex.quantity - 1));
    } else { _items.remove(id); }
    notifyListeners(); _sync();
  }

  void clearCart() { _items = {}; notifyListeners(); _sync(); }
}
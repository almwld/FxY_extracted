import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  void addItem(String id, String name, double price, int quantity, String image) {
    final existingIndex = _items.indexWhere((item) => item['id'] == id);
    if (existingIndex != -1) {
      _items[existingIndex]['quantity'] += quantity;
    } else {
      _items.add({'id': id, 'name': name, 'price': price, 'quantity': quantity, 'image': image});
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index]['quantity'] = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
class ProductProvider extends ChangeNotifier {
  List<dynamic> _featuredProducts = [];
  List<dynamic> _products = [];
  List<dynamic> _categories = [];
  bool _isLoading = false;
  List<dynamic> get featuredProducts => _featuredProducts;
  List<dynamic> get products => _products;
  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isEmpty => _featuredProducts.isEmpty && _products.isEmpty;
  Future<void> loadFeaturedProducts({bool refresh = false}) async {
    _isLoading = true; notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _featuredProducts = List.generate(6, (i) => {'id': '$i', 'name': 'منتج ${i+1}', 'price': 1000 * (i+1), 'image': ''});
    _isLoading = false; notifyListeners();
  }
  Future<void> loadProducts({bool refresh = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    _products = List.generate(20, (i) => {'id': '$i', 'name': 'منتج ${i+1}', 'price': 500 * (i+1), 'image': ''});
    notifyListeners();
  }
  Future<void> loadCategories() async {
    _categories = List.generate(8, (i) => {'id': '$i', 'name': 'قسم ${i+1}', 'icon': Icons.category});
    notifyListeners();
  }
}

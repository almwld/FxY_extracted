import 'package:flutter/material.dart';
import '../services/supabase/product_service.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get featuredProducts => _featuredProducts;
  List<ProductModel> get products => _products;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isEmpty => _featuredProducts.isEmpty && _products.isEmpty;
  String? get error => _error;

  Future<void> loadFeaturedProducts({bool refresh = false}) async {
    if (refresh) _featuredProducts = [];
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final products = await _productService.getProducts();
      _featuredProducts = products.take(6).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) _products = [];
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    _categories = [
      {'id': 'electronics', 'name': 'إلكترونيات', 'icon': Icons.electrical_services, 'color': 0xFF9C27B0},
      {'id': 'fashion', 'name': 'أزياء', 'icon': Icons.checkroom, 'color': 0xFFE91E63},
      {'id': 'furniture', 'name': 'أثاث', 'icon': Icons.weekend, 'color': 0xFF795548},
      {'id': 'cars', 'name': 'سيارات', 'icon': Icons.directions_car, 'color': 0xFF4CAF50},
      {'id': 'real_estate', 'name': 'عقارات', 'icon': Icons.house, 'color': 0xFF2196F3},
      {'id': 'services', 'name': 'خدمات', 'icon': Icons.build, 'color': 0xFF607D8B},
      {'id': 'restaurants', 'name': 'مطاعم', 'icon': Icons.restaurant, 'color': 0xFFF44336},
    ];
    notifyListeners();
  }
}

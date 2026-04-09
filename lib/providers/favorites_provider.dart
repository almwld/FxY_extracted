import 'package:flutter/material.dart';
import '../models/product/product_model.dart';
import '../services/supabase/product_service.dart';

/// مزود المفضلة
class FavoritesProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  final List<ProductModel> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProductModel> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _favorites.isEmpty;
  int get count => _favorites.length;

  /// تحميل المفضلة
  Future<void> loadFavorites(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _favorites.clear();
      final favorites = await _productService.getFavorites(userId);
      _favorites.addAll(favorites);
    } catch (e) {
      _setError('فشل تحميل المفضلة');
    } finally {
      _setLoading(false);
    }
  }

  /// إضافة للمفضلة
  Future<bool> addToFavorites(String userId, ProductModel product) async {
    if (isFavorite(product.id)) return true;

    _setLoading(true);
    _clearError();

    try {
      await _productService.addToFavorites(userId, product.id);
      _favorites.add(product);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل إضافة للمفضلة');
      _setLoading(false);
      return false;
    }
  }

  /// إزالة من المفضلة
  Future<bool> removeFromFavorites(String userId, String productId) async {
    _setLoading(true);
    _clearError();

    try {
      await _productService.removeFromFavorites(userId, productId);
      _favorites.removeWhere((p) => p.id == productId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل إزالة من المفضلة');
      _setLoading(false);
      return false;
    }
  }

  /// تبديل المفضلة
  Future<bool> toggleFavorite(String userId, ProductModel product) async {
    if (isFavorite(product.id)) {
      return await removeFromFavorites(userId, product.id);
    } else {
      return await addToFavorites(userId, product);
    }
  }

  /// التحقق مما إذا كان المنتج في المفضلة
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  /// مسح المفضلة
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  /// تعيين حالة التحميل
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// تعيين الخطأ
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// مسح الخطأ
  void _clearError() {
    _error = null;
  }

  /// مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/product/product_model.dart';
import '../models/product/product_category.dart';
import '../models/product/product_filter.dart';
import '../services/supabase/product_service.dart';

/// مزود المنتجات
class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<ProductModel> _products = [];
  List<ProductCategory> _categories = [];
  List<ProductModel> _featuredProducts = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;
  int _currentPage = 1;

  // Getters
  List<ProductModel> get products => List.unmodifiable(_products);
  List<ProductCategory> get categories => List.unmodifiable(_categories);
  List<ProductModel> get featuredProducts => List.unmodifiable(_featuredProducts);
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isEmpty => _products.isEmpty;

  /// تحميل المنتجات
  Future<void> loadProducts({
    ProductFilter? filter,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _products.clear();
    }

    if (!_hasMore || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final products = await _productService.getProducts(
        filter: filter,
        page: _currentPage,
      );

      if (products.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(products);
        _currentPage++;
      }
    } catch (e) {
      _setError('فشل تحميل المنتجات');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل المنتجات المميزة
  Future<void> loadFeaturedProducts({int limit = 10}) async {
    _setLoading(true);
    _clearError();

    try {
      _featuredProducts = await _productService.getFeaturedProducts(limit: limit);
    } catch (e) {
      _setError('فشل تحميل المنتجات المميزة');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل الفئات
  Future<void> loadCategories() async {
    _setLoading(true);
    _clearError();

    try {
      _categories = await _productService.getCategories();
    } catch (e) {
      _setError('فشل تحميل الفئات');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل منتج بواسطة المعرف
  Future<void> loadProductById(String productId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedProduct = await _productService.getProductById(productId);
      if (_selectedProduct == null) {
        _setError('المنتج غير موجود');
      }
    } catch (e) {
      _setError('فشل تحميل المنتج');
    } finally {
      _setLoading(false);
    }
  }

  /// البحث في المنتجات
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _products.clear();
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _products = await _productService.searchProducts(query);
    } catch (e) {
      _setError('فشل البحث');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل منتجات الفئة
  Future<void> loadCategoryProducts(
    String categoryId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _products.clear();
    }

    if (!_hasMore || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final products = await _productService.getCategoryProducts(
        categoryId,
        page: _currentPage,
      );

      if (products.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(products);
        _currentPage++;
      }
    } catch (e) {
      _setError('فشل تحميل منتجات الفئة');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل المزيد من المنتجات
  Future<void> loadMore({ProductFilter? filter}) async {
    await loadProducts(filter: filter);
  }

  /// تعيين المنتج المحدد
  void setSelectedProduct(ProductModel? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// مسح المنتجات
  void clearProducts() {
    _products.clear();
    _currentPage = 1;
    _hasMore = true;
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

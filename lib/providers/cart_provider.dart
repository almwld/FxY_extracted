import 'package:flutter/material.dart';
import '../models/product/product_model.dart';

/// عنصر السلة
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}

/// مزود السلة
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  /// عدد المنتجات الكلي
  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// المجموع الكلي
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  /// إضافة منتج للسلة
  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  /// إزالة منتج من السلة
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// تحديث الكمية
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  /// زيادة الكمية
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// تقليل الكمية
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeFromCart(productId);
      }
    }
  }

  /// مسح السلة
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// التحقق مما إذا كان المنتج في السلة
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// الحصول على كمية منتج
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: ProductModel(
        id: '',
        name: '',
        price: 0,
        quantity: 0,
        images: [],
        categoryId: '',
        tags: [],
        sellerId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ), quantity: 0),
    );
    return item.quantity;
  }

  /// تعيين حالة التحميل
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

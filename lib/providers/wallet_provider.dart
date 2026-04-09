import 'package:flutter/material.dart';
import '../models/wallet/wallet_model.dart';
import '../models/wallet/wallet_transaction.dart';
import '../services/supabase/wallet_service.dart';

/// مزود المحفظة
class WalletProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  
  WalletModel? _wallet;
  List<WalletTransaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  WalletModel? get wallet => _wallet;
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isEmpty => _transactions.isEmpty;
  
  double get balance => _wallet?.balance ?? 0.0;
  bool get hasBalance => balance > 0;
  String get currency => _wallet?.currency ?? 'YER';

  /// تحميل المحفظة
  Future<void> loadWallet(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _wallet = await _walletService.getWallet(userId);
      
      if (_wallet == null) {
        // إنشاء محفظة جديدة
        _wallet = await _walletService.createWallet(userId);
      }
    } catch (e) {
      _setError('فشل تحميل المحفظة');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل المعاملات
  Future<void> loadTransactions(
    String userId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _transactions.clear();
    }

    if (!_hasMore || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final transactions = await _walletService.getTransactions(
        userId,
        page: _currentPage,
      );

      if (transactions.isEmpty) {
        _hasMore = false;
      } else {
        _transactions.addAll(transactions);
        _currentPage++;
      }
    } catch (e) {
      _setError('فشل تحميل المعاملات');
    } finally {
      _setLoading(false);
    }
  }

  /// إيداع
  Future<bool> deposit({
    required String walletId,
    required String userId,
    required double amount,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final transaction = await _walletService.deposit(
        walletId: walletId,
        userId: userId,
        amount: amount,
        description: description,
      );

      _transactions.insert(0, transaction);
      await loadWallet(userId);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل الإيداع');
      _setLoading(false);
      return false;
    }
  }

  /// سحب
  Future<bool> withdraw({
    required String walletId,
    required String userId,
    required double amount,
    String? description,
  }) async {
    if (balance < amount) {
      _setError('رصيد غير كافٍ');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final transaction = await _walletService.withdraw(
        walletId: walletId,
        userId: userId,
        amount: amount,
        description: description,
      );

      _transactions.insert(0, transaction);
      await loadWallet(userId);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل السحب');
      _setLoading(false);
      return false;
    }
  }

  /// تحويل
  Future<bool> transfer({
    required String walletId,
    required String userId,
    required String recipientId,
    required String recipientName,
    required double amount,
    String? description,
  }) async {
    if (balance < amount) {
      _setError('رصيد غير كافٍ');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final transaction = await _walletService.transfer(
        walletId: walletId,
        userId: userId,
        recipientId: recipientId,
        recipientName: recipientName,
        amount: amount,
        description: description,
      );

      _transactions.insert(0, transaction);
      await loadWallet(userId);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل التحويل');
      _setLoading(false);
      return false;
    }
  }

  /// تحديث الرصيد
  void updateBalance(double newBalance) {
    if (_wallet != null) {
      _wallet = _wallet!.copyWith(balance: newBalance);
      notifyListeners();
    }
  }

  /// مسح المعاملات
  void clearTransactions() {
    _transactions.clear();
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

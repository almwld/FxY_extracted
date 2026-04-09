import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/wallet/wallet_model.dart';
import '../../models/wallet/wallet_transaction.dart';
import '../../models/wallet/wallet_card.dart';
import '../../models/wallet/wallet_bank_account.dart';

/// خدمة المحفظة
class WalletService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// ========== المحفظة ==========

  /// الحصول على محفظة المستخدم
  Future<WalletModel?> getWallet(String userId) async {
    final response = await _supabase
        .from('wallets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return WalletModel.fromJson(response);
  }

  /// إنشاء محفظة جديدة
  Future<WalletModel> createWallet(String userId) async {
    final wallet = WalletModel(
      id: '',
      userId: userId,
      balance: 0.0,
      currency: 'YER',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final response = await _supabase
        .from('wallets')
        .insert(wallet.toJson())
        .select()
        .single();

    return WalletModel.fromJson(response);
  }

  /// ========== المعاملات ==========

  /// إيداع
  Future<WalletTransaction> deposit({
    required String walletId,
    required String userId,
    required double amount,
    String? description,
    String? paymentMethod,
  }) async {
    // الحصول على الرصيد الحالي
    final wallet = await getWallet(userId);
    if (wallet == null) throw Exception('Wallet not found');

    final balanceBefore = wallet.balance;
    final balanceAfter = balanceBefore + amount;

    // إنشاء المعاملة
    final transaction = WalletTransaction(
      id: '',
      walletId: walletId,
      userId: userId,
      type: 'deposit',
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      description: description ?? 'إيداع',
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    final response = await _supabase
        .from('wallet_transactions')
        .insert(transaction.toJson())
        .select()
        .single();

    // تحديث الرصيد
    await _updateBalance(walletId, balanceAfter);

    return WalletTransaction.fromJson(response);
  }

  /// سحب
  Future<WalletTransaction> withdraw({
    required String walletId,
    required String userId,
    required double amount,
    String? description,
    String? withdrawalMethod,
  }) async {
    // الحصول على الرصيد الحالي
    final wallet = await getWallet(userId);
    if (wallet == null) throw Exception('Wallet not found');

    if (wallet.balance < amount) {
      throw Exception('Insufficient balance');
    }

    final balanceBefore = wallet.balance;
    final balanceAfter = balanceBefore - amount;

    // إنشاء المعاملة
    final transaction = WalletTransaction(
      id: '',
      walletId: walletId,
      userId: userId,
      type: 'withdraw',
      amount: -amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      description: description ?? 'سحب',
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    final response = await _supabase
        .from('wallet_transactions')
        .insert(transaction.toJson())
        .select()
        .single();

    // تحديث الرصيد
    await _updateBalance(walletId, balanceAfter);

    return WalletTransaction.fromJson(response);
  }

  /// تحويل
  Future<WalletTransaction> transfer({
    required String walletId,
    required String userId,
    required String recipientId,
    required String recipientName,
    required double amount,
    String? description,
  }) async {
    // الحصول على الرصيد الحالي
    final wallet = await getWallet(userId);
    if (wallet == null) throw Exception('Wallet not found');

    if (wallet.balance < amount) {
      throw Exception('Insufficient balance');
    }

    final balanceBefore = wallet.balance;
    final balanceAfter = balanceBefore - amount;

    // إنشاء المعاملة
    final transaction = WalletTransaction(
      id: '',
      walletId: walletId,
      userId: userId,
      type: 'transfer',
      amount: -amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      description: description ?? 'تحويل إلى $recipientName',
      recipientId: recipientId,
      recipientName: recipientName,
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    final response = await _supabase
        .from('wallet_transactions')
        .insert(transaction.toJson())
        .select()
        .single();

    // تحديث الرصيد
    await _updateBalance(walletId, balanceAfter);

    // إضافة للمستلم
    await _addToRecipient(recipientId, amount, userId);

    return WalletTransaction.fromJson(response);
  }

  /// تحديث الرصيد
  Future<void> _updateBalance(String walletId, double newBalance) async {
    await _supabase.from('wallets').update({
      'balance': newBalance,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', walletId);
  }

  /// إضافة للمستلم
  Future<void> _addToRecipient(
    String recipientId,
    double amount,
    String senderId,
  ) async {
    final recipientWallet = await getWallet(recipientId);
    if (recipientWallet == null) return;

    final newBalance = recipientWallet.balance + amount;
    await _updateBalance(recipientWallet.id, newBalance);

    // إنشاء معاملة للمستلم
    final transaction = WalletTransaction(
      id: '',
      walletId: recipientWallet.id,
      userId: recipientId,
      type: 'transfer',
      amount: amount,
      balanceBefore: recipientWallet.balance,
      balanceAfter: newBalance,
      description: 'استلام تحويل',
      recipientId: senderId,
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    await _supabase.from('wallet_transactions').insert(transaction.toJson());
  }

  /// الحصول على معاملات المستخدم
  Future<List<WalletTransaction>> getTransactions(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('wallet_transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => WalletTransaction.fromJson(json))
        .toList();
  }

  /// ========== البطاقات ==========

  /// إضافة بطاقة
  Future<WalletCard> addCard(WalletCard card) async {
    final response = await _supabase
        .from('wallet_cards')
        .insert(card.toJson())
        .select()
        .single();

    return WalletCard.fromJson(response);
  }

  /// الحصول على بطاقات المستخدم
  Future<List<WalletCard>> getCards(String userId) async {
    final response = await _supabase
        .from('wallet_cards')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('is_default', ascending: false);

    return (response as List)
        .map((json) => WalletCard.fromJson(json))
        .toList();
  }

  /// حذف بطاقة
  Future<void> deleteCard(String cardId) async {
    await _supabase.from('wallet_cards').delete().eq('id', cardId);
  }

  /// ========== الحسابات البنكية ==========

  /// إضافة حساب بنكي
  Future<WalletBankAccount> addBankAccount(WalletBankAccount account) async {
    final response = await _supabase
        .from('wallet_bank_accounts')
        .insert(account.toJson())
        .select()
        .single();

    return WalletBankAccount.fromJson(response);
  }

  /// الحصول على حسابات المستخدم
  Future<List<WalletBankAccount>> getBankAccounts(String userId) async {
    final response = await _supabase
        .from('wallet_bank_accounts')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('is_default', ascending: false);

    return (response as List)
        .map((json) => WalletBankAccount.fromJson(json))
        .toList();
  }

  /// حذف حساب بنكي
  Future<void> deleteBankAccount(String accountId) async {
    await _supabase.from('wallet_bank_accounts').delete().eq('id', accountId);
  }

  /// ========== الإحصائيات ==========

  /// الحصول على إحصائيات المحفظة
  Future<Map<String, dynamic>> getWalletStats(String userId) async {
    final transactions = await getTransactions(userId, limit: 1000);

    double totalDeposits = 0;
    double totalWithdrawals = 0;
    double totalTransfers = 0;

    for (final t in transactions) {
      if (t.isDeposit) totalDeposits += t.amount;
      if (t.isWithdraw) totalWithdrawals += t.amount.abs();
      if (t.isTransfer) totalTransfers += t.amount.abs();
    }

    return {
      'total_deposits': totalDeposits,
      'total_withdrawals': totalWithdrawals,
      'total_transfers': totalTransfers,
      'transaction_count': transactions.length,
    };
  }
}

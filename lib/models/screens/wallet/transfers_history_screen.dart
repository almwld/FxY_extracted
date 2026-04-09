import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/wallet/wallet_transaction.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/wallet/transaction_card.dart';

/// شاشة سجل التحويلات
/// تعرض جميع تحويلات المحفظة للمستخدم
class TransfersHistoryScreen extends StatefulWidget {
  const TransfersHistoryScreen({super.key});

  @override
  State<TransfersHistoryScreen> createState() => _TransfersHistoryScreenState();
}

class _TransfersHistoryScreenState extends State<TransfersHistoryScreen> {
  String _selectedPeriod = 'all';
  final List<Map<String, dynamic>> _periods = [
    {'id': 'all', 'name': 'الكل'},
    {'id': 'today', 'name': 'اليوم'},
    {'id': 'week', 'name': 'هذا الأسبوع'},
    {'id': 'month', 'name': 'هذا الشهر'},
    {'id': 'year', 'name': 'هذه السنة'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTransfers();
  }

  /// تحميل التحويلات
  Future<void> _loadTransfers() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.loadTransactions();
  }

  /// تصفية التحويلات حسب الفترة
  List<WalletTransaction> _filterTransfers(List<WalletTransaction> transactions) {
    final transfers = transactions.where((t) => t.type == 'transfer').toList();
    
    if (_selectedPeriod == 'all') return transfers;
    
    final now = DateTime.now();
    return transfers.where((t) {
      switch (_selectedPeriod) {
        case 'today':
          return t.createdAt.year == now.year &&
                 t.createdAt.month == now.month &&
                 t.createdAt.day == now.day;
        case 'week':
          final weekAgo = now.subtract(const Duration(days: 7));
          return t.createdAt.isAfter(weekAgo);
        case 'month':
          return t.createdAt.year == now.year && t.createdAt.month == now.month;
        case 'year':
          return t.createdAt.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  /// حساب إجمالي التحويلات المرسلة
  double _calculateTotalSent(List<WalletTransaction> transfers) {
    return transfers
        .where((t) => t.amount < 0)
        .fold(0, (sum, t) => sum + t.amount.abs());
  }

  /// حساب إجمالي التحويلات المستلمة
  double _calculateTotalReceived(List<WalletTransaction> transfers) {
    return transfers
        .where((t) => t.amount > 0)
        .fold(0, (sum, t) => sum + t.amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    final transfers = _filterTransfers(walletProvider.transactions);
    final totalSent = _calculateTotalSent(transfers);
    final totalReceived = _calculateTotalReceived(transfers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل التحويلات'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) {
              return _periods.map((period) {
                return PopupMenuItem(
                  value: period['id'] as String,
                  child: Text(period['name'] as String),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ملخص التحويلات
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'مرسل',
                    totalSent,
                    Icons.arrow_upward,
                    AppColors.error,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'مستلم',
                    totalReceived,
                    Icons.arrow_downward,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(),
          
          // قائمة التحويلات
          Expanded(
            child: walletProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : transfers.isEmpty
                    ? _buildEmptyState(theme)
                    : RefreshIndicator(
                        onRefresh: _loadTransfers,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: transfers.length,
                          itemBuilder: (context, index) {
                            final transfer = transfers[index];
                            return TransactionCard(
                              transaction: transfer,
                              showDetails: true,
                            ).animate().fadeIn(delay: (index * 50).ms).slideY();
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر الملخص
  Widget _buildSummaryItem(
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${amount.toStringAsFixed(2)} ر.ي',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swap_horiz_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تحويلات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر تحويلاتك هنا عند إجرائها',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

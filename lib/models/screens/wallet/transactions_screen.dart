import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/wallet/wallet_transaction.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/wallet/transaction_card.dart';

/// شاشة سجل المعاملات
/// تعرض جميع معاملات المحفظة للمستخدم
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'all';
  final List<Map<String, dynamic>> _filters = [
    {'id': 'all', 'name': 'الكل'},
    {'id': 'deposit', 'name': 'إيداع'},
    {'id': 'withdraw', 'name': 'سحب'},
    {'id': 'transfer', 'name': 'تحويل'},
    {'id': 'payment', 'name': 'دفع'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  /// تحميل المعاملات
  Future<void> _loadTransactions() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.loadTransactions();
  }

  /// تصفية المعاملات
  List<WalletTransaction> _filterTransactions(List<WalletTransaction> transactions) {
    if (_selectedFilter == 'all') return transactions;
    return transactions.where((t) => t.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    final transactions = _filterTransactions(walletProvider.transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التصفية
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter['id'];
                
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(filter['name'] as String),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter['id'] as String;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(),
          
          // قائمة المعاملات
          Expanded(
            child: walletProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? _buildEmptyState(theme)
                    : RefreshIndicator(
                        onRefresh: _loadTransactions,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return TransactionCard(
                              transaction: transaction,
                            ).animate().fadeIn(delay: (index * 50).ms).slideY();
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد معاملات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر معاملاتك هنا عند إجرائها',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  /// عرض Bottom Sheet للتصفية
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تصفية المعاملات',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ..._filters.map((filter) {
                return ListTile(
                  title: Text(filter['name'] as String),
                  trailing: _selectedFilter == filter['id']
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter['id'] as String;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

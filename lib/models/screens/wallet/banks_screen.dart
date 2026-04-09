import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/wallet/wallet_bank_account.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_button.dart';

/// شاشة البنوك
/// تعرض قائمة البنوك المرتبطة بالمحفظة
class BanksScreen extends StatefulWidget {
  const BanksScreen({super.key});

  @override
  State<BanksScreen> createState() => _BanksScreenState();
}

class _BanksScreenState extends State<BanksScreen> {
  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
  }

  /// تحميل الحسابات البنكية
  Future<void> _loadBankAccounts() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.loadBankAccounts();
  }

  /// حذف حساب بنكي
  Future<void> _deleteBankAccount(String accountId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الحساب'),
          content: const Text('هل أنت متأكد من حذف هذا الحساب البنكي؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('حذف', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final walletProvider = context.read<WalletProvider>();
        await walletProvider.deleteBankAccount(accountId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف الحساب بنجاح')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    final bankAccounts = walletProvider.bankAccounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الحسابات البنكية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-bank-account');
            },
          ),
        ],
      ),
      body: walletProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bankAccounts.isEmpty
              ? _buildEmptyState(theme)
              : RefreshIndicator(
                  onRefresh: _loadBankAccounts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bankAccounts.length,
                    itemBuilder: (context, index) {
                      final account = bankAccounts[index];
                      return _BankAccountCard(
                        account: account,
                        onDelete: () => _deleteBankAccount(account.id),
                      ).animate().fadeIn(delay: (index * 100).ms).slideY();
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-bank-account');
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة حساب'),
      ).animate().scale(delay: 500.ms),
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد حسابات بنكية',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف حسابك البنكي لسهولة السحب والإيداع',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'إضافة حساب بنكي',
            onPressed: () {
              Navigator.pushNamed(context, '/add-bank-account');
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

/// بطاقة الحساب البنكي
class _BankAccountCard extends StatelessWidget {
  final WalletBankAccount account;
  final VoidCallback onDelete;

  const _BankAccountCard({
    required this.account,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.accountType ?? 'حساب جاري',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رقم الحساب',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.maskedAccountNumber,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                if (account.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'افتراضي',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

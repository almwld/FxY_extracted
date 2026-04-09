import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/wallet/wallet_balance_card.dart';
import '../../widgets/wallet/service_grid_item.dart';

/// شاشة محفظة كاش
/// تعرض تفاصيل محفظة كاش والخدمات المتاحة
class CashWalletScreen extends StatelessWidget {
  const CashWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظة كاش'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/transactions');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الرصيد
            WalletBalanceCard(
              balance: walletProvider.balance,
              currency: 'YER',
              walletName: 'كاش',
              onDeposit: () {
                Navigator.pushNamed(context, '/deposit');
              },
              onWithdraw: () {
                Navigator.pushNamed(context, '/withdraw');
              },
              onTransfer: () {
                Navigator.pushNamed(context, '/transfer');
              },
            ).animate().fadeIn().slideY(),
            
            const SizedBox(height: 32),
            
            // عنوان الخدمات
            Text(
              'الخدمات',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(),
            
            const SizedBox(height: 16),
            
            // شبكة الخدمات
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                ServiceGridItem(
                  icon: Icons.arrow_downward,
                  label: 'إيداع',
                  color: AppColors.success,
                  onTap: () => Navigator.pushNamed(context, '/deposit'),
                ),
                ServiceGridItem(
                  icon: Icons.arrow_upward,
                  label: 'سحب',
                  color: AppColors.error,
                  onTap: () => Navigator.pushNamed(context, '/withdraw'),
                ),
                ServiceGridItem(
                  icon: Icons.swap_horiz,
                  label: 'تحويل',
                  color: AppColors.info,
                  onTap: () => Navigator.pushNamed(context, '/transfer'),
                ),
                ServiceGridItem(
                  icon: Icons.receipt,
                  label: 'فواتير',
                  color: AppColors.warning,
                  onTap: () => Navigator.pushNamed(context, '/bill-payment'),
                ),
                ServiceGridItem(
                  icon: Icons.phone_android,
                  label: 'شحن',
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/recharge'),
                ),
                ServiceGridItem(
                  icon: Icons.history,
                  label: 'سجل',
                  color: AppColors.textSecondary,
                  onTap: () => Navigator.pushNamed(context, '/transactions'),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 32),
            
            // عنوان آخر المعاملات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر المعاملات',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transactions');
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideX(),
            
            const SizedBox(height: 16),
            
            // قائمة آخر المعاملات
            if (walletProvider.recentTransactions.isEmpty)
              _buildEmptyTransactions(theme)
            else
              ...walletProvider.recentTransactions.take(5).map((transaction) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction.amount > 0
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      child: Icon(
                        transaction.amount > 0
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.amount > 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    title: Text(transaction.description),
                    subtitle: Text(
                      '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
                    ),
                    trailing: Text(
                      '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: transaction.amount > 0
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  /// بناء حالة فارغة للمعاملات
  Widget _buildEmptyTransactions(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد معاملات حديثة',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

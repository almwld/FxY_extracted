import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/wallet/wallet_balance_card.dart';
import '../../widgets/wallet/service_grid_item.dart';

/// شاشة محفظة واي باي (YPay Wallet)
/// تعرض تفاصيل محفظة واي باي والخدمات المتاحة
class YPayScreen extends StatelessWidget {
  const YPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('YPay'),
        backgroundColor: Colors.blue,
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
              walletName: 'YPay',
              primaryColor: Colors.blue,
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
                  icon: Icons.qr_code,
                  label: 'QR',
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/qr-code'),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 32),
            
            // نقاط الولاء
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'نقاط الولاء',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1,250',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'نقطة',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Redeem points
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('استبدال'),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(),
          ],
        ),
      ),
    );
  }
}

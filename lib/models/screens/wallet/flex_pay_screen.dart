import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/wallet/wallet_balance_card.dart';
import '../../widgets/wallet/service_grid_item.dart';

/// شاشة محفظة فليكس باي (FlexPay Wallet)
/// المحفظة الرقمية الرسمية لتطبيق Flex Yemen
class FlexPayScreen extends StatelessWidget {
  const FlexPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlexPay'),
        backgroundColor: AppColors.primary,
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
              walletName: 'FlexPay',
              primaryColor: AppColors.primary,
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
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/qr-code'),
                ),
                ServiceGridItem(
                  icon: Icons.card_giftcard,
                  label: 'هدايا',
                  color: Colors.pink,
                  onTap: () => Navigator.pushNamed(context, '/gift-cards'),
                ),
                ServiceGridItem(
                  icon: Icons.currency_exchange,
                  label: 'صرف',
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/currency-exchange'),
                ),
                ServiceGridItem(
                  icon: Icons.account_balance,
                  label: 'بنوك',
                  color: Colors.indigo,
                  onTap: () => Navigator.pushNamed(context, '/banks'),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 32),
            
            // نقاط الولاء
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.goldColor, AppColors.goldDark],
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
                        'نقاط FlexPay',
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
                            '2,500',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'القيمة',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            '25,000 ر.ي',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Redeem points
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.goldDark,
                      ),
                      child: const Text('استبدال النقاط'),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(),
            
            const SizedBox(height: 32),
            
            // كود الإحالة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'كود الإحالة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FLEX2024',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Copy referral code
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'شارك الكود مع أصدقائك واحصل على 1000 نقطة لكل إحالة ناجحة',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(),
          ],
        ),
      ),
    );
  }
}

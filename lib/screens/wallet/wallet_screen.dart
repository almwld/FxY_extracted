import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_widget.dart';

/// شاشة المحفظة
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final walletProvider = context.read<WalletProvider>();
    
    if (authProvider.user != null) {
      await walletProvider.loadWallet(authProvider.user!.id);
      await walletProvider.loadTransactions(authProvider.user!.id);
    }
  }

  Future<void> _refresh() async {
    final authProvider = context.read<AuthProvider>();
    final walletProvider = context.read<WalletProvider>();
    
    if (authProvider.user != null) {
      await walletProvider.loadWallet(authProvider.user!.id);
      await walletProvider.loadTransactions(authProvider.user!.id, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wallet),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.transactions);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.goldColor,
        child: Consumer<WalletProvider>(
          builder: (context, walletProvider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // بطاقة الرصيد
                  _buildBalanceCard(walletProvider),
                  const SizedBox(height: 24),
                  
                  // خدمات سريعة
                  _buildQuickServices(),
                  const SizedBox(height: 24),
                  
                  // المعاملات الأخيرة
                  _buildRecentTransactions(walletProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletProvider walletProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldColor, AppColors.goldDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الرصيد المتاح',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'نشط',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(walletProvider.balance),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add,
                  label: 'إيداع',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.deposit);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.remove,
                  label: 'سحب',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.withdraw);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.swap_horiz,
                  label: 'تحويل',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.transfer);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServices() {
    final services = [
      {'icon': Icons.phone_android, 'label': 'شحن', 'route': AppRoutes.recharge},
      {'icon': Icons.receipt, 'label': 'فواتير', 'route': AppRoutes.billPayment},
      {'icon': Icons.card_giftcard, 'label': 'هدايا', 'route': AppRoutes.giftCards},
      {'icon': Icons.qr_code, 'label': 'QR', 'route': AppRoutes.qrCode},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خدمات سريعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: services.map((service) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(service['route'] as String);
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.goldColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: AppColors.goldColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(service['label'] as String),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(WalletProvider walletProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'المعاملات الأخيرة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.transactions);
              },
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (walletProvider.isLoading && walletProvider.isEmpty)
          const LoadingWidget()
        else if (walletProvider.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد معاملات',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: walletProvider.transactions.length > 5
                ? 5
                : walletProvider.transactions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final transaction = walletProvider.transactions[index];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: transaction.isIncoming
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    transaction.isIncoming
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: transaction.isIncoming ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(transaction.typeDisplay),
                subtitle: Text(
                  Formatters.formatDateTime(transaction.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Text(
                  transaction.formattedAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: transaction.isIncoming ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

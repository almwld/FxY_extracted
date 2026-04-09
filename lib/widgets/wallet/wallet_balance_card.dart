import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
class WalletBalanceCard extends StatelessWidget {
  final double balance; final String? currency; final VoidCallback? onDeposit; final VoidCallback? onWithdraw;
  const WalletBalanceCard({super.key, required this.balance, this.currency = 'ر.ي', this.onDeposit, this.onWithdraw});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.goldColor, AppTheme.goldDark]), borderRadius: BorderRadius.circular(20)), child: Column(children: [const Text('رصيد المحفظة', style: TextStyle(color: Colors.white)), const SizedBox(height: 8), Text('$balance $currency', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 16), Row(children: [Expanded(child: ElevatedButton(onPressed: onDeposit, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.goldColor), child: const Text('إيداع'))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: onWithdraw, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.goldColor), child: const Text('سحب')))]))]);
}

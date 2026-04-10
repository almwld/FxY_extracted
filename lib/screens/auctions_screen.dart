import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuctionsScreen extends StatelessWidget {
  const AuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(title: const Text('المزادات'), backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
      body: const Center(child: Text('سيتم إضافة المزادات قريباً')),
    );
  }
}

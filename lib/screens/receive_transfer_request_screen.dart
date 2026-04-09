import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/simple_app_bar.dart';

class ReceiveTransferRequestScreen extends StatelessWidget {
  const ReceiveTransferRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: const SimpleAppBar(title: 'استلام حوالة'),
      body: const Center(
        child: Text('سيتم إضافة صفحة استلام الحوالات قريباً'),
      ),
    );
  }
}

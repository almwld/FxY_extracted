import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/simple_app_bar.dart';

class RequestServiceScreen extends StatelessWidget {
  const RequestServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: const SimpleAppBar(title: 'طلب خدمة'),
      body: const Center(
        child: Text('سيتم إضافة صفحة طلب الخدمة قريباً'),
      ),
    );
  }
}

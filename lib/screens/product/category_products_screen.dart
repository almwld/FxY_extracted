import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(title: Text(categoryName), backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
      body: Center(child: Text('منتجات قسم $categoryName سيتم إضافتها قريباً')),
    );
  }
}

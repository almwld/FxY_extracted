import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// شاشة إدارة الفئات
/// تعرض قائمة الفئات وتمكن المشرف من إدارتها
class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key});

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        itemBuilder: (context, index) {
          return _CategoryCard(
            name: 'فئة ${index + 1}',
            productsCount: (index + 1) * 10,
            icon: Icons.category,
            onTap: () {},
          ).animate().fadeIn(delay: (index * 100).ms).slideX();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// بطاقة الفئة
class _CategoryCard extends StatelessWidget {
  final String name;
  final int productsCount;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.productsCount,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(name),
        subtitle: Text('$productsCount منتج'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
              onPressed: () {},
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// شاشة إدارة الإعلانات
/// تعرض قائمة الإعلانات وتمكن المشرف من إدارتها
class AdminAds extends StatefulWidget {
  const AdminAds({super.key});

  @override
  State<AdminAds> createState() => _AdminAdsState();
}

class _AdminAdsState extends State<AdminAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإعلانات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _AdCard(
            title: 'إعلان ${index + 1}',
            status: index % 3 == 0 ? 'منتهي' : 'نشط',
            views: (index + 1) * 100,
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

/// بطاقة الإعلان
class _AdCard extends StatelessWidget {
  final String title;
  final String status;
  final int views;
  final VoidCallback onTap;

  const _AdCard({
    required this.title,
    required this.status,
    required this.views,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'نشط';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.campaign, color: AppColors.primary),
        ),
        title: Text(title),
        subtitle: Text('المشاهدات: $views'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.success : AppColors.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

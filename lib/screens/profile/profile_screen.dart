import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_widget.dart';

/// شاشة الملف الشخصي
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // معلومات المستخدم
            _buildUserInfo(context, user),
            const SizedBox(height: 24),
            
            // الإحصائيات
            _buildStats(),
            const SizedBox(height: 24),
            
            // القائمة
            _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldColor, AppColors.goldDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // الصورة
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: user?.avatarUrl != null
                ? NetworkImage(user!.avatarUrl!)
                : null,
            child: user?.avatarUrl == null
                ? const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.goldColor,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          // الاسم
          Text(
            user?.displayName ?? 'ضيف',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          // البريد
          Text(
            user?.email ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          // زر تعديل
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.editProfile);
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('تعديل الملف'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      {'value': '12', 'label': 'طلب'},
      {'value': '5', 'label': 'مفضل'},
      {'value': '3', 'label': 'إعلان'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                stat['value']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(stat['label']!),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenu(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': AppStrings.myOrders,
        'route': AppRoutes.myOrders,
      },
      {
        'icon': Icons.favorite_outline,
        'title': AppStrings.favorites,
        'route': AppRoutes.favorites,
      },
      {
        'icon': Icons.location_on_outlined,
        'title': AppStrings.addresses,
        'route': AppRoutes.addresses,
      },
      {
        'icon': Icons.payment_outlined,
        'title': AppStrings.paymentMethods,
        'route': AppRoutes.paymentMethods,
      },
      {
        'icon': Icons.campaign_outlined,
        'title': AppStrings.myAds,
        'route': AppRoutes.myAds,
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'الدعم',
        'route': AppRoutes.helpSupport,
      },
      {
        'icon': Icons.logout,
        'title': AppStrings.logout,
        'color': Colors.red,
        'onTap': () => _showLogoutDialog(context),
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return ListTile(
          leading: Icon(
            item['icon'] as IconData,
            color: item['color'] as Color? ?? AppColors.goldColor,
          ),
          title: Text(item['title'] as String),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: item['onTap'] as VoidCallback? ??
              () {
                Navigator.of(context).pushNamed(item['route'] as String);
              },
        );
      }).toList(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<AuthProvider>().signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

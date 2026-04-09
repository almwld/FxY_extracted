import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/pro/stats_card.dart';

/// لوحة تحكم المشرف
/// تعرض إحصائيات ونظرة عامة على النظام
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المشرف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الترحيب
            Text(
              'مرحباً، المشرف',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().slideX(),
            
            const SizedBox(height: 24),
            
            // إحصائيات سريعة
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                StatsCard(
                  title: 'المستخدمين',
                  value: '1,234',
                  icon: Icons.people,
                  color: Colors.blue,
                  trend: '+12%',
                ),
                StatsCard(
                  title: 'الطلبات',
                  value: '567',
                  icon: Icons.shopping_cart,
                  color: Colors.green,
                  trend: '+8%',
                ),
                StatsCard(
                  title: 'المنتجات',
                  value: '3,456',
                  icon: Icons.inventory,
                  color: Colors.orange,
                  trend: '+15%',
                ),
                StatsCard(
                  title: 'الإيرادات',
                  value: '2.5M ر.ي',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  trend: '+20%',
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 24),
            
            // رسم بياني للمبيعات
            Text(
              'المبيعات الشهرية',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms).slideX(),
            
            const SizedBox(height: 16),
            
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4.5),
                        const FlSpot(5, 6),
                      ],
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 24),
            
            // روابط سريعة
            Text(
              'روابط سريعة',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 500.ms).slideX(),
            
            const SizedBox(height: 16),
            
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _QuickLinkTile(
                  icon: Icons.people,
                  title: 'إدارة المستخدمين',
                  subtitle: 'عرض وإدارة حسابات المستخدمين',
                  onTap: () => Navigator.pushNamed(context, '/admin-users'),
                ),
                _QuickLinkTile(
                  icon: Icons.inventory,
                  title: 'إدارة المنتجات',
                  subtitle: 'عرض وإدارة المنتجات',
                  onTap: () => Navigator.pushNamed(context, '/admin-products'),
                ),
                _QuickLinkTile(
                  icon: Icons.shopping_cart,
                  title: 'إدارة الطلبات',
                  subtitle: 'عرض وإدارة الطلبات',
                  onTap: () => Navigator.pushNamed(context, '/admin-orders'),
                ),
                _QuickLinkTile(
                  icon: Icons.category,
                  title: 'إدارة الفئات',
                  subtitle: 'عرض وإدارة الفئات',
                  onTap: () => Navigator.pushNamed(context, '/admin-categories'),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

/// عنصر رابط سريع
class _QuickLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/pro/stats_card.dart';

/// شاشة التقارير
/// تعرض تقارير وإحصائيات التطبيق
class AdminReports extends StatelessWidget {
  const AdminReports({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات عامة
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                StatsCard(
                  title: 'إجمالي المبيعات',
                  value: '15.5M ر.ي',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
                StatsCard(
                  title: 'إجمالي الطلبات',
                  value: '5,432',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                ),
                StatsCard(
                  title: 'المستخدمين الجدد',
                  value: '1,234',
                  icon: Icons.people,
                  color: Colors.orange,
                ),
                StatsCard(
                  title: 'متوسط الطلب',
                  value: '2,850 ر.ي',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                ),
              ],
            ).animate().fadeIn(),
            
            const SizedBox(height: 24),
            
            // رسم بياني للمبيعات
            Text(
              'المبيعات اليومية',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(),
            
            const SizedBox(height: 16),
            
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  barGroups: [
                    _makeGroupData(0, 5),
                    _makeGroupData(1, 8),
                    _makeGroupData(2, 6),
                    _makeGroupData(3, 10),
                    _makeGroupData(4, 7),
                    _makeGroupData(5, 12),
                    _makeGroupData(6, 9),
                  ],
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 24),
            
            // أفضل المنتجات مبيعاً
            Text(
              'أفضل المنتجات مبيعاً',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms).slideX(),
            
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _TopProductCard(
                  rank: index + 1,
                  name: 'منتج ${index + 1}',
                  sales: '${(5 - index) * 100}',
                ).animate().fadeIn(delay: (500 + index * 100).ms).slideX();
              },
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

/// بطاقة أفضل منتج
class _TopProductCard extends StatelessWidget {
  final int rank;
  final String name;
  final String sales;

  const _TopProductCard({
    required this.rank,
    required this.name,
    required this.sales,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rank <= 3 ? AppColors.goldColor : AppColors.primary.withOpacity(0.1),
          child: Text(
            '$rank',
            style: TextStyle(
              color: rank <= 3 ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name),
        trailing: Text(
          '$sales مبيعة',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
      ),
    );
  }
}

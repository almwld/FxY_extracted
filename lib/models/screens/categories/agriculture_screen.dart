import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/product/product_card_grid.dart';

/// شاشة فئة الزراعة
/// تعرض منتجات الزراعة والمستلزمات الزراعية
class AgricultureScreen extends StatelessWidget {
  const AgricultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الزراعة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade300],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'منتجات زراعية طازجة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().fadeIn().slideY(),
            
            const SizedBox(height: 24),
            
            // الأقسام الفرعية
            const SectionHeader(title: 'الأقسام').animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 16),
            
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _SubCategoryChip(
                    icon: Icons.eco,
                    label: 'بذور',
                    color: Colors.green,
                  ),
                  _SubCategoryChip(
                    icon: Icons.water_drop,
                    label: 'مبيدات',
                    color: Colors.blue,
                  ),
                  _SubCategoryChip(
                    icon: Icons.yard,
                    label: 'أسمدة',
                    color: Colors.orange,
                  ),
                  _SubCategoryChip(
                    icon: Icons.agriculture,
                    label: 'معدات',
                    color: Colors.brown,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 24),
            
            // المنتجات
            const SectionHeader(title: 'منتجات مميزة').animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return ProductCardGrid(
                  product: null,
                  onTap: () {},
                ).animate().fadeIn(delay: (500 + index * 100).ms).scale();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// شريحة القسم الفرعي
class _SubCategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SubCategoryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

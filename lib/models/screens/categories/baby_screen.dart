import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/product/product_card_grid.dart';

/// شاشة فئة منتجات الأطفال
/// تعرض منتجات أطفال
class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجات الأطفال'),
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
                  colors: [Colors.pink.shade600, Colors.pink.shade300],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'منتجات الأطفال',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().fadeIn().slideY(),

            const SizedBox(height: 24),

            // المنتجات المميزة
            const SectionHeader(title: 'منتجات مميزة').animate().fadeIn(delay: 200.ms),

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
                ).animate().fadeIn(delay: (300 + index * 100).ms).scale();
              },
            ),
          ],
        ),
      ),
    );
  }
}

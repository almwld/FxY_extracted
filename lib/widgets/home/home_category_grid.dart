import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/product_provider.dart';

/// شبكة الفئات في الصفحة الرئيسية
class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final categories = productProvider.categories.take(8).toList();

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.categoryProducts,
                    arguments: category.id,
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.goldColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: category.iconUrl != null
                            ? Image.network(category.iconUrl!)
                            : Icon(
                                _getCategoryIcon(index),
                                color: AppColors.goldColor,
                                size: 32,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(int index) {
    final icons = [
      Icons.phone_android,
      Icons.checkroom,
      Icons.chair,
      Icons.face,
      Icons.sports_basketball,
      Icons.restaurant,
      Icons.directions_car,
      Icons.apartment,
    ];
    return icons[index % icons.length];
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/home/home_slider.dart';
import '../../widgets/home/home_category_grid.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/common/loading_widget.dart';

/// الشاشة الرئيسية
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    await Future.wait([
      productProvider.loadFeaturedProducts(),
      productProvider.loadCategories(),
      productProvider.loadProducts(),
    ]);
  }

  Future<void> _refresh() async {
    final productProvider = context.read<ProductProvider>();
    await productProvider.loadFeaturedProducts(refresh: true);
    await productProvider.loadCategories();
    await productProvider.loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appNameAr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.goldColor,
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.isLoading && productProvider.isEmpty) {
              return const LoadingWidget();
            }

            return CustomScrollView(
              slivers: [
                // السلايدر
                const SliverToBoxAdapter(
                  child: HomeSlider(),
                ),
                
                // الفئات
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'الفئات',
                    onSeeAll: () {
                      Navigator.of(context).pushNamed(AppRoutes.allCategories);
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: HomeCategoryGrid(),
                ),
                
                // المنتجات المميزة
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'منتجات مميزة',
                    onSeeAll: () {
                      Navigator.of(context).pushNamed(AppRoutes.products);
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = productProvider.featuredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.productDetail,
                              arguments: product.id,
                            );
                          },
                        );
                      },
                      childCount: productProvider.featuredProducts.length > 4
                          ? 4
                          : productProvider.featuredProducts.length,
                    ),
                  ),
                ),
                
                // أحدث المنتجات
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'أحدث المنتجات',
                    onSeeAll: () {
                      Navigator.of(context).pushNamed(AppRoutes.products);
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = productProvider.products[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductCard(
                            product: product,
                            isHorizontal: true,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.productDetail,
                                arguments: product.id,
                              );
                            },
                          ),
                        );
                      },
                      childCount: productProvider.products.length > 5
                          ? 5
                          : productProvider.products.length,
                    ),
                  ),
                ),
                
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 24),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/product_card.dart';

/// شاشة المنتجات
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    await productProvider.loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final productProvider = context.read<ProductProvider>();
      if (!productProvider.isLoading && productProvider.hasMore) {
        productProvider.loadMore();
      }
    }
  }

  Future<void> _refresh() async {
    final productProvider = context.read<ProductProvider>();
    await productProvider.loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading && productProvider.isEmpty) {
            return const LoadingWidget();
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.goldColor,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: productProvider.products.length +
                  (productProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= productProvider.products.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final product = productProvider.products[index];
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
            ),
          );
        },
      ),
    );
  }
}

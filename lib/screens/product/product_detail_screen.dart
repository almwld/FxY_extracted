import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/product/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

/// شاشة تفاصيل المنتج
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productProvider = context.read<ProductProvider>();
    await productProvider.loadProductById(widget.productId);
  }

  void _addToCart(ProductModel product) {
    final cartProvider = context.read<CartProvider>();
    for (int i = 0; i < _quantity; i++) {
      cartProvider.addToCart(product);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت الإضافة للسلة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final product = productProvider.selectedProduct;

          if (productProvider.isLoading || product == null) {
            return const LoadingWidget();
          }

          return CustomScrollView(
            slivers: [
              // AppBar مع صورة
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // الصورة الرئيسية
                      PageView.builder(
                        itemCount: product.images.isEmpty ? 1 : product.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: product.images.isNotEmpty
                                ? Image.network(
                                    product.images[index],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                          );
                        },
                      ),
                      // مؤشر الصور
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _selectedImageIndex == index
                                      ? AppColors.goldColor
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // المحتوى
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم والسعر
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.formatCurrency(product.price),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldColor,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  Formatters.formatCurrency(product.compareAtPrice!),
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // التقييم
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating.toStringAsFixed(1)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount} تقييم)',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // الوصف
                      const Text(
                        'الوصف',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ?? 'لا يوجد وصف',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // الكمية
                      const Text(
                        'الكمية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final product = productProvider.selectedProduct;
              if (product == null) return const SizedBox.shrink();

              return Row(
                children: [
                  // زر المفضلة
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  // زر إضافة للسلة
                  Expanded(
                    child: CustomButton(
                      text: 'أضف للسلة',
                      icon: Icons.shopping_cart,
                      onPressed: () => _addToCart(product),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

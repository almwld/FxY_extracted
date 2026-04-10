import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/supabase/product_service.dart';
import '../../providers/cart_provider.dart';
import '../home/home_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  Map<String, dynamic>? _product;
  bool _isLoading = true;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await _productService.getProduct(widget.productId);
    setState(() {
      _product = product?.toJson();
      _isLoading = false;
    });
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(_product!['id'], _product!['name'], _product!['price'], _quantity, _product!['images'][0]);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة المنتج إلى السلة'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_product == null) {
      return const Scaffold(body: Center(child: Text('المنتج غير موجود')));
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(title: const Text('تفاصيل المنتج'), backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_product!['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${_product!['price']} ريال', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.goldColor)),
                        const SizedBox(height: 16),
                        if (_product!['description'] != null)
                          Text(_product!['description'], style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('الكمية:'),
                            IconButton(onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null), icon: const Icon(Icons.remove)),
                            Text('$_quantity', style: const TextStyle(fontSize: 18)),
                            IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
                child: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = _product!['images'] as List? ?? [];
    if (images.isEmpty) {
      return Container(height: 300, color: Colors.grey[300], child: const Icon(Icons.image, size: 50));
    }
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) => CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (_, __) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
          errorWidget: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
        ),
      ),
    );
  }
}

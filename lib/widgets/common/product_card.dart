import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;
  
  const ProductCard({
    super.key, 
    required this.product, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // استخراج البيانات من المنتج (سواء كان Map أو ProductModel)
    final String productName = product is Map 
        ? (product['name'] ?? product['title'] ?? 'منتج') 
        : (product.name ?? product.title ?? 'منتج');
    
    final double productPrice = product is Map 
        ? (product['price'] ?? 0).toDouble() 
        : (product.price ?? 0).toDouble();
    
    final String imageUrl = product is Map 
        ? (product['images'] != null && product['images'].isNotEmpty ? product['images'][0] : '')
        : (product.images != null && product.images.isNotEmpty ? product.images[0] : '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(height: 130, color: Colors.grey[300]),
                      errorWidget: (_, __, ___) => Container(height: 130, color: Colors.grey[300], child: const Icon(Icons.image)),
                    )
                  : Container(height: 130, color: Colors.grey[300], child: const Icon(Icons.image)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${productPrice.toStringAsFixed(0)} ريال',
                    style: TextStyle(
                      color: AppTheme.goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

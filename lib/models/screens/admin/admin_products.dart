import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// شاشة إدارة المنتجات
/// تعرض قائمة المنتجات وتمكن المشرف من إدارتها
class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث عن منتج...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ).animate().fadeIn(),
          
          // قائمة المنتجات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _ProductCard(
                  name: 'منتج ${index + 1}',
                  price: '${(index + 1) * 1000} ر.ي',
                  stock: index % 5 == 0 ? 0 : (index + 1) * 10,
                  onTap: () {},
                ).animate().fadeIn(delay: (index * 100).ms).slideX();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// بطاقة المنتج
class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final int stock;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.stock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final outOfStock = stock == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: AppColors.primary),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(price),
            Text(
              outOfStock ? 'نفذت الكمية' : 'المخزون: $stock',
              style: TextStyle(
                color: outOfStock ? AppColors.error : AppColors.success,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            // TODO: Handle menu actions
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('تعديل')),
            const PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

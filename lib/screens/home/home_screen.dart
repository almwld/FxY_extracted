import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/product_card.dart';
import '../product/category_products_screen.dart';
import '../all_ads_screen.dart';
import '../auctions_screen.dart';
import '../login_screen.dart';
import '../register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;
  
  final List<Map<String, dynamic>> _carouselItems = [
    {'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800', 'title': 'مندي يمني', 'subtitle': 'لحم ضأن مع أرز', 'categoryId': 'restaurants', 'discount': 'خصم 20%'},
    {'image': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800', 'title': 'عقارات فاخرة', 'subtitle': 'فلل وشقق', 'categoryId': 'real_estate', 'discount': 'خصم 30%'},
    {'image': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800', 'title': 'سيارات جديدة', 'subtitle': 'أحدث الموديلات', 'categoryId': 'cars', 'discount': 'خصم 25%'},
    {'image': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800', 'title': 'إلكترونيات', 'subtitle': 'هواتف وكومبيوترات', 'categoryId': 'electronics', 'discount': 'خصم 40%'},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'id': 'real_estate', 'name': 'عقارات', 'icon': Icons.house, 'colorValue': 0xFF2196F3},
    {'id': 'cars', 'name': 'سيارات', 'icon': Icons.directions_car, 'colorValue': 0xFF4CAF50},
    {'id': 'electronics', 'name': 'إلكترونيات', 'icon': Icons.electrical_services, 'colorValue': 0xFF9C27B0},
    {'id': 'fashion', 'name': 'أزياء', 'icon': Icons.checkroom, 'colorValue': 0xFFE91E63},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadFeaturedProducts();
      context.read<ProductProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('فلكس يمن', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.goldColor,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            icon: const Icon(Icons.login, size: 18, color: Colors.black),
            label: const Text('دخول', style: TextStyle(color: Colors.black, fontSize: 14)),
            style: TextButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.goldColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0),
            child: const Text('إنشاء حساب', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productProvider.loadFeaturedProducts(refresh: true);
          await productProvider.loadProducts(refresh: true);
        },
        color: AppTheme.goldColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCarousel(),
              const SizedBox(height: 16),
              _buildMazadAlJanabi(),
              const SizedBox(height: 24),
              _buildSectionHeader('الفئات الرئيسية', 'عرض الكل'),
              _buildMainCategories(),
              const SizedBox(height: 24),
              _buildSectionHeader('منتجات مميزة', ''),
              productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductsGrid(productProvider.featuredProducts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 180, autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.9, onPageChanged: (index, reason) => setState(() => _currentCarouselIndex = index)),
          items: _carouselItems.map((item) => Builder(builder: (context) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsScreen(categoryId: item['categoryId'], categoryName: item['title']))),
            child: Container(
              width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)])),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppTheme.goldColor, borderRadius: BorderRadius.circular(12)), child: Text(item['discount'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 4), Text(item['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(item['subtitle'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ))).toList(),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: _carouselItems.asMap().entries.map((entry) => Container(width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(shape: BoxShape.circle, color: _currentCarouselIndex == entry.key ? AppTheme.goldColor : Colors.grey.withOpacity(0.5)))).toList()),
      ],
    );
  }

  Widget _buildMazadAlJanabi() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.goldColor, AppTheme.goldDark]), borderRadius: BorderRadius.circular(15)),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('مزاد الجنابي', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const Text('أكبر مزاد للسيوف التراثية', style: TextStyle(color: Colors.white70)), const SizedBox(height: 8), ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuctionsScreen())), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.goldColor), child: const Text('شارك الآن'))])), const Icon(Icons.emoji_events, size: 60, color: Colors.white)]),
    );
  }

  Widget _buildSectionHeader(String title, String? seeAll) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), if (seeAll != null && seeAll.isNotEmpty) TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllAdsScreen())), child: Text(seeAll, style: TextStyle(color: AppTheme.goldColor)))]) );
  }

  Widget _buildMainCategories() {
    return SizedBox(height: 100, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _categories.length, itemBuilder: (context, index) {
      final cat = _categories[index];
      final colorValue = cat['colorValue'] as int;
      final iconData = cat['icon'] as IconData;
      final catId = cat['id'] as String;
      final catName = cat['name'] as String;
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsScreen(categoryId: catId, categoryName: catName))),
        child: Container(width: 80, margin: const EdgeInsets.symmetric(horizontal: 8), child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Color(colorValue).withOpacity(0.1), shape: BoxShape.circle), child: Icon(iconData, color: Color(colorValue), size: 30)), const SizedBox(height: 8), Text(catName, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)])),
      );
    }));
  }

  Widget _buildProductsGrid(List<dynamic> products) {
    if (products.isEmpty) {
      return const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('لا توجد منتجات')));
    }
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: products.length > 4 ? 4 : products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index], onTap: () {}),
    );
  }
}

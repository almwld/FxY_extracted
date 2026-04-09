import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_category.dart';
import '../../models/product/product_review.dart';
import '../../models/product/product_filter.dart';

/// خدمة المنتجات
class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// الحصول على جميع المنتجات
  Future<List<ProductModel>> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    var query = _supabase.from('products').select();

    if (filter != null) {
      if (filter.categoryId != null) {
        query = query.eq('category_id', filter.categoryId);
      }
      if (filter.minPrice != null) {
        query = query.gte('price', filter.minPrice);
      }
      if (filter.maxPrice != null) {
        query = query.lte('price', filter.maxPrice);
      }
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        query = query.ilike('name', '%${filter.searchQuery}%');
      }
      if (filter.isFeatured == true) {
        query = query.eq('is_featured', true);
      }
      if (filter.onSale == true) {
        query = query.eq('is_on_sale', true);
      }
    }

    final response = await query
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// الحصول على منتج بواسطة المعرف
  Future<ProductModel?> getProductById(String productId) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('id', productId)
        .single();

    if (response == null) return null;
    return ProductModel.fromJson(response);
  }

  /// إنشاء منتج جديد
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await _supabase
        .from('products')
        .insert(product.toJson())
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  /// تحديث منتج
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _supabase
        .from('products')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  /// حذف منتج
  Future<void> deleteProduct(String productId) async {
    await _supabase.from('products').delete().eq('id', productId);
  }

  /// الحصول على منتجات البائع
  Future<List<ProductModel>> getSellerProducts(String sellerId) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('seller_id', sellerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// الحصول على المنتجات المميزة
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('is_active', true)
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// الحصول على المنتجات الأكثر مبيعاً
  Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('is_active', true)
        .order('sales_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// البحث في المنتجات
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('is_active', true)
        .or('name.ilike.%$query%,description.ilike.%$query%');

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// ========== الفئات ==========

  /// الحصول على جميع الفئات
  Future<List<ProductCategory>> getCategories() async {
    final response = await _supabase
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List)
        .map((json) => ProductCategory.fromJson(json))
        .toList();
  }

  /// الحصول على فئة بواسطة المعرف
  Future<ProductCategory?> getCategoryById(String categoryId) async {
    final response = await _supabase
        .from('categories')
        .select()
        .eq('id', categoryId)
        .single();

    if (response == null) return null;
    return ProductCategory.fromJson(response);
  }

  /// الحصول على منتجات الفئة
  Future<List<ProductModel>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('products')
        .select()
        .eq('category_id', categoryId)
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// ========== التقييمات ==========

  /// الحصول على تقييمات المنتج
  Future<List<ProductReview>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _supabase
        .from('reviews')
        .select()
        .eq('product_id', productId)
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => ProductReview.fromJson(json))
        .toList();
  }

  /// إضافة تقييم
  Future<ProductReview> addReview(ProductReview review) async {
    final response = await _supabase
        .from('reviews')
        .insert(review.toJson())
        .select()
        .single();

    // تحديث متوسط التقييم
    await _updateProductRating(review.productId);

    return ProductReview.fromJson(response);
  }

  /// تحديث متوسط تقييم المنتج
  Future<void> _updateProductRating(String productId) async {
    final response = await _supabase
        .from('reviews')
        .select('rating')
        .eq('product_id', productId)
        .eq('is_active', true);

    if (response.isEmpty) return;

    final ratings = (response as List).map((r) => r['rating'] as int).toList();
    final average = ratings.reduce((a, b) => a + b) / ratings.length;

    await _supabase.from('products').update({
      'rating': average,
      'review_count': ratings.length,
    }).eq('id', productId);
  }

  /// ========== المفضلة ==========

  /// إضافة إلى المفضلة
  Future<void> addToFavorites(String userId, String productId) async {
    await _supabase.from('favorites').insert({
      'user_id': userId,
      'product_id': productId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// إزالة من المفضلة
  Future<void> removeFromFavorites(String userId, String productId) async {
    await _supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  /// الحصول على المفضلة
  Future<List<ProductModel>> getFavorites(String userId) async {
    final response = await _supabase
        .from('favorites')
        .select('product_id')
        .eq('user_id', userId);

    final productIds = (response as List)
        .map((f) => f['product_id'] as String)
        .toList();

    if (productIds.isEmpty) return [];

    final productsResponse = await _supabase
        .from('products')
        .select()
        .inFilter('id', productIds);

    return (productsResponse as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// التحقق مما إذا كان المنتج في المفضلة
  Future<bool> isFavorite(String userId, String productId) async {
    final response = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return response != null;
  }
}

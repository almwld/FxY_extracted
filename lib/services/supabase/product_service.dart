import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product_model.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('is_available', true)
          .order('created_at', ascending: false);
      
      return (response as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      print('❌ خطأ في جلب المنتجات: $e');
      return [];
    }
  }

  Future<ProductModel?> getProduct(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('id', id)
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      print('❌ خطأ في جلب المنتج: $e');
      return null;
    }
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول');
    
    await _supabase.from('products').insert({
      ...product,
      'seller_id': userId,
    });
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _supabase.from('products').update(data).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _supabase.from('products').delete().eq('id', id);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product/product_model.dart';
class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<List<ProductModel>> getProducts() async {
    final response = await _supabase.from('products').select();
    return (response as List).map((p) => ProductModel.fromJson(p)).toList();
  }
  Future<ProductModel?> getProduct(String id) async {
    final response = await _supabase.from('products').select().eq('id', id).single();
    return ProductModel.fromJson(response);
  }
}

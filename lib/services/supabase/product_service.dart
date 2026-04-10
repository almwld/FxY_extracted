import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product/product_model.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*, seller:profiles!seller_id(name, avatar_url)')
          .eq('is_available', true)
          .order('created_at', ascending: false);

      return (response as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      return _getMockProducts();
    }
  }

  Future<ProductModel?> getProduct(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*, seller:profiles!seller_id(name, avatar_url)')
          .eq('id', id)
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> _getMockProducts() {
    return List.generate(10, (index) => ProductModel(
      id: '${index + 1}',
      title: 'منتج مميز ${index + 1}',
      name: 'منتج ${index + 1}',
      description: 'وصف المنتج رقم ${index + 1}',
      price: 1000.0 * (index + 1),
      oldPrice: 1500.0 * (index + 1),
      images: ['https://picsum.photos/300/300?random=$index'],
      category: 'electronics',
      stock: 10,
      isAvailable: true,
      createdAt: DateTime.now(),
    ));
  }
}

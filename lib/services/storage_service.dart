import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> pickImages({int maxCount = 5}) async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isEmpty) return [];
    return pickedFiles.take(maxCount).map((file) => File(file.path)).toList();
  }

  Future<File?> pickSingleImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future<List<String>> uploadProductImages(List<File> images, String productId) async {
    List<String> imageUrls = [];
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final fileExt = file.path.split('.').last;
      final fileName = 'products/$productId/${DateTime.now().millisecondsSinceEpoch}_$i.$fileExt';
      await _supabase.storage.from('products').upload(fileName, file);
      final imageUrl = _supabase.storage.from('products').getPublicUrl(fileName);
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  Future<void> deleteImage(String url) async {
    final fileName = url.split('/').last;
    await _supabase.storage.from('products').remove([fileName]);
  }
}

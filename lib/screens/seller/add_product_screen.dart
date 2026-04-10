import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/supabase/product_service.dart';
import '../../services/storage_service.dart';
import '../../providers/product_provider.dart';
import '../home/home_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  
  String _selectedCategory = 'electronics';
  List<File> _selectedImages = [];
  bool _isSubmitting = false;
  
  final List<Map<String, String>> _categories = [
    {'id': 'electronics', 'name': 'إلكترونيات'},
    {'id': 'fashion', 'name': 'أزياء'},
    {'id': 'furniture', 'name': 'أثاث'},
    {'id': 'cars', 'name': 'سيارات'},
    {'id': 'real_estate', 'name': 'عقارات'},
    {'id': 'restaurants', 'name': 'مطاعم'},
  ];

  Future<void> _pickImages() async {
    final images = await StorageService().pickImages(maxCount: 5 - _selectedImages.length);
    setState(() => _selectedImages.addAll(images));
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة واحدة على الأقل')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final productService = ProductService();
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final imageUrls = await StorageService().uploadProductImages(_selectedImages, tempId);
      
      await productService.addProduct({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'images': imageUrls,
        'stock': int.parse(_stockController.text),
        'description': _descriptionController.text,
      });

      await context.read<ProductProvider>().loadProducts(refresh: true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المنتج بنجاح'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      appBar: AppBar(title: const Text('إضافة منتج'), backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'السعر (ريال)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'الرجاء إدخال السعر' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'الكمية', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'الرجاء إدخال الكمية' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'القسم', border: OutlineInputBorder()),
                items: _categories.map((c) => DropdownMenuItem(value: c['id'], child: Text(c['name']!))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v.toString()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldColor, foregroundColor: Colors.black),
                  child: _isSubmitting ? const CircularProgressIndicator(strokeWidth: 2) : const Text('إضافة المنتج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الصور', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == _selectedImages.length) {
                return GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100, height: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add_photo_alternate, size: 40),
                  ),
                );
              }
              return Stack(children: [
                Container(
                  width: 100, height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: FileImage(_selectedImages[index]), fit: BoxFit.cover)),
                ),
                Positioned(
                  top: 0, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedImages.removeAt(index)),
                    child: const CircleAvatar(radius: 14, backgroundColor: Colors.red, child: Icon(Icons.close, size: 16, color: Colors.white)),
                  ),
                ),
              ]);
            },
          ),
        ),
      ],
    );
  }
}

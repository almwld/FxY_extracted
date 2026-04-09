import 'package:flutter/material.dart';
class CategoryProductsScreen extends StatelessWidget {
  final String categoryId; final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryId, required this.categoryName});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(categoryName)), body: const Center(child: Text('Products')));
}

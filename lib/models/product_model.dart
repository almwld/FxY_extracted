class ProductModel {
  final String id;
  final String title;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final List<String> images;
  final String category;
  final String? sellerId;
  final String? sellerName;
  final double? rating;
  final int? reviewCount;
  final int stock;
  final bool isAvailable;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.images,
    required this.category,
    this.sellerId,
    this.sellerName,
    this.rating,
    this.reviewCount,
    required this.stock,
    required this.isAvailable,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['old_price']?.toDouble(),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      category: json['category'] ?? '',
      sellerId: json['seller_id']?.toString(),
      sellerName: json['seller_name'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
      stock: json['stock'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  String get formattedPrice => '${price.toStringAsFixed(0)} ريال';
  String get formattedOldPrice => oldPrice != null ? '${oldPrice!.toStringAsFixed(0)} ريال' : '';
  double get discountPercentage => oldPrice != null && oldPrice! > 0 ? ((oldPrice! - price) / oldPrice!) * 100 : 0;
  String? get mainImage => images.isNotEmpty ? images[0] : null;
  bool get hasDiscount => oldPrice != null && oldPrice! > price;
}

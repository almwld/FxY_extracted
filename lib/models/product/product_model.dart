/// نموذج المنتج
class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? compareAtPrice;
  final String currency;
  final int quantity;
  final String? sku;
  final String? barcode;
  final double? weight;
  final String? weightUnit;
  final List<String> images;
  final String? thumbnail;
  final String categoryId;
  final String? subcategoryId;
  final List<String> tags;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? variants;
  final String sellerId;
  final String? sellerName;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final bool isFeatured;
  final bool isOnSale;
  final DateTime? saleStartsAt;
  final DateTime? saleEndsAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.compareAtPrice,
    this.currency = 'YER',
    required this.quantity,
    this.sku,
    this.barcode,
    this.weight,
    this.weightUnit,
    required this.images,
    this.thumbnail,
    required this.categoryId,
    this.subcategoryId,
    required this.tags,
    this.attributes,
    this.variants,
    required this.sellerId,
    this.sellerName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.isOnSale = false,
    this.saleStartsAt,
    this.saleEndsAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: json['compare_at_price'] != null
          ? (json['compare_at_price'] as num).toDouble()
          : null,
      currency: json['currency'] as String? ?? 'YER',
      quantity: json['quantity'] as int,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      weightUnit: json['weight_unit'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      thumbnail: json['thumbnail'] as String?,
      categoryId: json['category_id'] as String,
      subcategoryId: json['subcategory_id'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      attributes: json['attributes'] as Map<String, dynamic>?,
      variants: json['variants'] as Map<String, dynamic>?,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      isOnSale: json['is_on_sale'] as bool? ?? false,
      saleStartsAt: json['sale_starts_at'] != null
          ? DateTime.parse(json['sale_starts_at'] as String)
          : null,
      saleEndsAt: json['sale_ends_at'] != null
          ? DateTime.parse(json['sale_ends_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'compare_at_price': compareAtPrice,
      'currency': currency,
      'quantity': quantity,
      'sku': sku,
      'barcode': barcode,
      'weight': weight,
      'weight_unit': weightUnit,
      'images': images,
      'thumbnail': thumbnail,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'tags': tags,
      'attributes': attributes,
      'variants': variants,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'rating': rating,
      'review_count': reviewCount,
      'is_active': isActive,
      'is_featured': isFeatured,
      'is_on_sale': isOnSale,
      'sale_starts_at': saleStartsAt?.toIso8601String(),
      'sale_ends_at': saleEndsAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? compareAtPrice,
    String? currency,
    int? quantity,
    String? sku,
    String? barcode,
    double? weight,
    String? weightUnit,
    List<String>? images,
    String? thumbnail,
    String? categoryId,
    String? subcategoryId,
    List<String>? tags,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? variants,
    String? sellerId,
    String? sellerName,
    double? rating,
    int? reviewCount,
    bool? isActive,
    bool? isFeatured,
    bool? isOnSale,
    DateTime? saleStartsAt,
    DateTime? saleEndsAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
      variants: variants ?? this.variants,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      saleStartsAt: saleStartsAt ?? this.saleStartsAt,
      saleEndsAt: saleEndsAt ?? this.saleEndsAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  bool get isInStock => quantity > 0;
  bool get isOutOfStock => quantity <= 0;
  bool get hasDiscount => compareAtPrice != null && compareAtPrice! > price;
  double? get discountPercentage => hasDiscount
      ? ((compareAtPrice! - price) / compareAtPrice! * 100)
      : null;
  String? get mainImage => images.isNotEmpty ? images.first : thumbnail;
  double get finalPrice => isOnSale && saleActive ? price : price;
  bool get saleActive {
    if (!isOnSale) return false;
    final now = DateTime.now();
    if (saleStartsAt != null && now.isBefore(saleStartsAt!)) return false;
    if (saleEndsAt != null && now.isAfter(saleEndsAt!)) return false;
    return true;
  }
}

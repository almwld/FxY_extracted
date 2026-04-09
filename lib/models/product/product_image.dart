/// نموذج صورة المنتج
class ProductImage {
  final String id;
  final String productId;
  final String url;
  final String? thumbnailUrl;
  final String? mediumUrl;
  final String? largeUrl;
  final String? altText;
  final int sortOrder;
  final bool isPrimary;
  final DateTime createdAt;

  ProductImage({
    required this.id,
    required this.productId,
    required this.url,
    this.thumbnailUrl,
    this.mediumUrl,
    this.largeUrl,
    this.altText,
    this.sortOrder = 0,
    this.isPrimary = false,
    required this.createdAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      mediumUrl: json['medium_url'] as String?,
      largeUrl: json['large_url'] as String?,
      altText: json['alt_text'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'medium_url': mediumUrl,
      'large_url': largeUrl,
      'alt_text': altText,
      'sort_order': sortOrder,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProductImage copyWith({
    String? id,
    String? productId,
    String? url,
    String? thumbnailUrl,
    String? mediumUrl,
    String? largeUrl,
    String? altText,
    int? sortOrder,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return ProductImage(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediumUrl: mediumUrl ?? this.mediumUrl,
      largeUrl: largeUrl ?? this.largeUrl,
      altText: altText ?? this.altText,
      sortOrder: sortOrder ?? this.sortOrder,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get displayUrl => thumbnailUrl ?? url;
  String get fullUrl => largeUrl ?? mediumUrl ?? url;
}

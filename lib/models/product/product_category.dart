/// نموذج فئة المنتج
class ProductCategory {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final String? parentId;
  final int level;
  final int sortOrder;
  final bool isActive;
  final bool isFeatured;
  final String? metaTitle;
  final String? metaDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.parentId,
    this.level = 0,
    this.sortOrder = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.metaTitle,
    this.metaDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      parentId: json['parent_id'] as String?,
      level: json['level'] as int? ?? 0,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      metaTitle: json['meta_title'] as String?,
      metaDescription: json['meta_description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'parent_id': parentId,
      'level': level,
      'sort_order': sortOrder,
      'is_active': isActive,
      'is_featured': isFeatured,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProductCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? iconUrl,
    String? parentId,
    int? level,
    int? sortOrder,
    bool? isActive,
    bool? isFeatured,
    String? metaTitle,
    String? metaDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isMainCategory => parentId == null;
  bool get isSubCategory => parentId != null;
}

/// قائمة الفئات الرئيسية
class CategoryData {
  static const List<Map<String, dynamic>> mainCategories = [
    {'id': 'electronics', 'name': 'إلكترونيات', 'icon': 'electronics'},
    {'id': 'fashion', 'name': 'أزياء', 'icon': 'fashion'},
    {'id': 'home', 'name': 'منزل وأثاث', 'icon': 'home'},
    {'id': 'beauty', 'name': 'جمال وعناية', 'icon': 'beauty'},
    {'id': 'sports', 'name': 'رياضة ولياقة', 'icon': 'sports'},
    {'id': 'food', 'name': 'مأكولات ومشروبات', 'icon': 'food'},
    {'id': 'cars', 'name': 'سيارات ومركبات', 'icon': 'cars'},
    {'id': 'realestate', 'name': 'عقارات', 'icon': 'realestate'},
    {'id': 'books', 'name': 'كتب وتعليم', 'icon': 'books'},
    {'id': 'toys', 'name': 'ألعاب وأطفال', 'icon': 'toys'},
    {'id': 'health', 'name': 'صحة وطب', 'icon': 'health'},
    {'id': 'pets', 'name': 'حيوانات أليفة', 'icon': 'pets'},
    {'id': 'garden', 'name': 'حدائق وزراعة', 'icon': 'garden'},
    {'id': 'industrial', 'name': 'صناعة ومعدات', 'icon': 'industrial'},
    {'id': 'services', 'name': 'خدمات', 'icon': 'services'},
  ];
}

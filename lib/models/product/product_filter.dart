/// نموذج فلتر المنتجات
class ProductFilter {
  String? categoryId;
  String? subcategoryId;
  double? minPrice;
  double? maxPrice;
  double? minRating;
  String? sortBy;
  String? sortOrder;
  bool? inStock;
  bool? onSale;
  bool? isFeatured;
  String? sellerId;
  List<String>? tags;
  Map<String, dynamic>? attributes;
  String? searchQuery;
  int page;
  int limit;

  ProductFilter({
    this.categoryId,
    this.subcategoryId,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy = 'created_at',
    this.sortOrder = 'desc',
    this.inStock,
    this.onSale,
    this.isFeatured,
    this.sellerId,
    this.tags,
    this.attributes,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
  });

  ProductFilter copyWith({
    String? categoryId,
    String? subcategoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
    bool? inStock,
    bool? onSale,
    bool? isFeatured,
    String? sellerId,
    List<String>? tags,
    Map<String, dynamic>? attributes,
    String? searchQuery,
    int? page,
    int? limit,
  }) {
    return ProductFilter(
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      inStock: inStock ?? this.inStock,
      onSale: onSale ?? this.onSale,
      isFeatured: isFeatured ?? this.isFeatured,
      sellerId: sellerId ?? this.sellerId,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    
    if (categoryId != null) params['category_id'] = categoryId;
    if (subcategoryId != null) params['subcategory_id'] = subcategoryId;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (minRating != null) params['min_rating'] = minRating;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (inStock != null) params['in_stock'] = inStock;
    if (onSale != null) params['on_sale'] = onSale;
    if (isFeatured != null) params['is_featured'] = isFeatured;
    if (sellerId != null) params['seller_id'] = sellerId;
    if (tags != null && tags!.isNotEmpty) params['tags'] = tags!.join(',');
    if (attributes != null) params.addAll(attributes!);
    if (searchQuery != null && searchQuery!.isNotEmpty) params['q'] = searchQuery;
    params['page'] = page;
    params['limit'] = limit;
    
    return params;
  }

  void nextPage() => page++;
  void previousPage() => page = page > 1 ? page - 1 : 1;
  void resetPage() => page = 1;

  bool get hasFilters {
    return categoryId != null ||
           subcategoryId != null ||
           minPrice != null ||
           maxPrice != null ||
           minRating != null ||
           inStock != null ||
           onSale != null ||
           isFeatured != null ||
           sellerId != null ||
           (tags != null && tags!.isNotEmpty) ||
           (searchQuery != null && searchQuery!.isNotEmpty);
  }

  void clearFilters() {
    categoryId = null;
    subcategoryId = null;
    minPrice = null;
    maxPrice = null;
    minRating = null;
    inStock = null;
    onSale = null;
    isFeatured = null;
    sellerId = null;
    tags = null;
    searchQuery = null;
    page = 1;
  }
}

/// خيارات الترتيب
class SortOptions {
  static const Map<String, String> options = {
    'created_at_desc': 'الأحدث',
    'created_at_asc': 'الأقدم',
    'price_asc': 'السعر: من الأقل للأعلى',
    'price_desc': 'السعر: من الأعلى للأقل',
    'name_asc': 'الاسم: أ-ي',
    'name_desc': 'الاسم: ي-أ',
    'rating_desc': 'الأعلى تقييماً',
    'popularity_desc': 'الأكثر شعبية',
  };
}

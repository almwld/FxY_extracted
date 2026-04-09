class ProductFilter {
  String categoryId;
  double? minPrice;
  double? maxPrice;
  String? searchQuery;
  ProductFilter({this.categoryId = '', this.minPrice, this.maxPrice, this.searchQuery});
}

/// نموذج تقييم المنتج
class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String? userName;
  final String? userAvatar;
  final int rating;
  final String? title;
  final String? comment;
  final List<String> images;
  final int helpfulCount;
  final bool isVerifiedPurchase;
  final String? sellerResponse;
  final DateTime? sellerResponseAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    this.userName,
    this.userAvatar,
    required this.rating,
    this.title,
    this.comment,
    required this.images,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
    this.sellerResponse,
    this.sellerResponseAt,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      rating: json['rating'] as int,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      helpfulCount: json['helpful_count'] as int? ?? 0,
      isVerifiedPurchase: json['is_verified_purchase'] as bool? ?? false,
      sellerResponse: json['seller_response'] as String?,
      sellerResponseAt: json['seller_response_at'] != null
          ? DateTime.parse(json['seller_response_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images,
      'helpful_count': helpfulCount,
      'is_verified_purchase': isVerifiedPurchase,
      'seller_response': sellerResponse,
      'seller_response_at': sellerResponseAt?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProductReview copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userAvatar,
    int? rating,
    String? title,
    String? comment,
    List<String>? images,
    int? helpfulCount,
    bool? isVerifiedPurchase,
    String? sellerResponse,
    DateTime? sellerResponseAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductReview(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      sellerResponse: sellerResponse ?? this.sellerResponse,
      sellerResponseAt: sellerResponseAt ?? this.sellerResponseAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get ratingStars => '★' * rating + '☆' * (5 - rating);
  bool get hasImages => images.isNotEmpty;
  bool get hasComment => comment != null && comment!.isNotEmpty;
  bool get hasSellerResponse => sellerResponse != null && sellerResponse!.isNotEmpty;
}

/// ملخص التقييمات
class ReviewSummary {
  final String productId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  ReviewSummary({
    required this.productId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      productId: json['product_id'] as String,
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int,
      ratingDistribution: (json['rating_distribution'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(int.parse(k), v as int)),
    );
  }

  int get fiveStarCount => ratingDistribution[5] ?? 0;
  int get fourStarCount => ratingDistribution[4] ?? 0;
  int get threeStarCount => ratingDistribution[3] ?? 0;
  int get twoStarCount => ratingDistribution[2] ?? 0;
  int get oneStarCount => ratingDistribution[1] ?? 0;

  double get fiveStarPercentage => totalReviews > 0 ? fiveStarCount / totalReviews * 100 : 0;
  double get fourStarPercentage => totalReviews > 0 ? fourStarCount / totalReviews * 100 : 0;
  double get threeStarPercentage => totalReviews > 0 ? threeStarCount / totalReviews * 100 : 0;
  double get twoStarPercentage => totalReviews > 0 ? twoStarCount / totalReviews * 100 : 0;
  double get oneStarPercentage => totalReviews > 0 ? oneStarCount / totalReviews * 100 : 0;
}

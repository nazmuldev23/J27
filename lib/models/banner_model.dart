class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String targetCategoryOrProduct;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.targetCategoryOrProduct = '',
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'targetCategoryOrProduct': targetCategoryOrProduct,
      'isActive': isActive,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map, String id) {
    return BannerModel(
      id: id,
      title: map['title'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      targetCategoryOrProduct: map['targetCategoryOrProduct'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  BannerModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? targetCategoryOrProduct,
    bool? isActive,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      targetCategoryOrProduct: targetCategoryOrProduct ?? this.targetCategoryOrProduct,
      isActive: isActive ?? this.isActive,
    );
  }
}

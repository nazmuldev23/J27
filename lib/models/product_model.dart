class ProductModel {
  final String id;
  final String name;
  final double price;
  final double discountPrice;
  final String categoryId;
  final String description;
  final int stock;
  final List<String> imageUrls;
  final List<String> sizes;
  final List<String> colors;
  final bool isPopular;
  final bool isNew;
  final String offerTag;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice = 0.0,
    required this.categoryId,
    required this.description,
    required this.stock,
    required this.imageUrls,
    this.sizes = const [],
    this.colors = const [],
    this.isPopular = false,
    this.isNew = false,
    this.offerTag = '',
  });

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  double get effectivePrice => hasDiscount ? discountPrice : price;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discountPrice': discountPrice,
      'categoryId': categoryId,
      'description': description,
      'stock': stock,
      'imageUrls': imageUrls,
      'sizes': sizes,
      'colors': colors,
      'isPopular': isPopular,
      'isNew': isNew,
      'offerTag': offerTag,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: map['categoryId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
      sizes: List<String>.from(map['sizes'] as List? ?? []),
      colors: List<String>.from(map['colors'] as List? ?? []),
      isPopular: map['isPopular'] as bool? ?? false,
      isNew: map['isNew'] as bool? ?? false,
      offerTag: map['offerTag'] as String? ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? discountPrice,
    String? categoryId,
    String? description,
    int? stock,
    List<String>? imageUrls,
    List<String>? sizes,
    List<String>? colors,
    bool? isPopular,
    bool? isNew,
    String? offerTag,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      imageUrls: imageUrls ?? this.imageUrls,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      isPopular: isPopular ?? this.isPopular,
      isNew: isNew ?? this.isNew,
      offerTag: offerTag ?? this.offerTag,
    );
  }
}

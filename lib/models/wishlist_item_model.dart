import 'product_model.dart';

class WishlistItemModel {
  final String id;
  final String userId;
  final ProductModel product;

  const WishlistItemModel({
    required this.id,
    required this.userId,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'product': product.toMap(),
    };
  }

  factory WishlistItemModel.fromMap(Map<String, dynamic> map, String id) {
    final prodMap = Map<String, dynamic>.from(map['product'] as Map);
    return WishlistItemModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      product: ProductModel.fromMap(prodMap, prodMap['id'] as String? ?? ''),
    );
  }
}

import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedSize = '',
    this.selectedColor = '',
  });

  double get totalPrice => product.effectivePrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final prodMap = Map<String, dynamic>.from(map['product'] as Map);
    return CartItemModel(
      product: ProductModel.fromMap(prodMap, prodMap['id'] as String? ?? ''),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      selectedSize: map['selectedSize'] as String? ?? '',
      selectedColor: map['selectedColor'] as String? ?? '',
    );
  }

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}

import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final String customerName;
  final String phone;
  final String address;
  final String cityArea;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryCharge;
  final double discountAmount;
  final double totalPrice;
  final String paymentMethod;
  final String status; // Pending, Confirmed, Processing, Shipped, Delivered, Cancelled
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.cityArea,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    this.discountAmount = 0.0,
    required this.totalPrice,
    required this.paymentMethod,
    this.status = 'Pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'cityArea': cityArea,
      'items': items.map((x) => x.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'discountAmount': discountAmount,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      cityArea: map['cityArea'] as String? ?? '',
      items: (map['items'] as List? ?? [])
          .map((x) => CartItemModel.fromMap(Map<String, dynamic>.from(x as Map)))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (map['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash on Delivery',
      status: map['status'] as String? ?? 'Pending',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? customerName,
    String? phone,
    String? address,
    String? cityArea,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryCharge,
    double? discountAmount,
    double? totalPrice,
    String? paymentMethod,
    String? status,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cityArea: cityArea ?? this.cityArea,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      discountAmount: discountAmount ?? this.discountAmount,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

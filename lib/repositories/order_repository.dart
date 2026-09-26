import '../models/order_model.dart';

class OrderRepository {
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'ORD-1001',
      userId: 'cust_1',
      customerName: 'Customer User',
      phone: '+1234567890',
      address: '123 Main Street',
      cityArea: 'Downtown',
      items: [],
      subtotal: 249.99,
      deliveryCharge: 15.00,
      discountAmount: 10.00,
      totalPrice: 254.99,
      paymentMethod: 'Cash on Delivery',
      status: 'Pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    OrderModel(
      id: 'ORD-1002',
      userId: 'cust_1',
      customerName: 'Customer User',
      phone: '+1234567890',
      address: '123 Main Street',
      cityArea: 'Downtown',
      items: [],
      subtotal: 99.00,
      deliveryCharge: 10.00,
      discountAmount: 0.00,
      totalPrice: 109.00,
      paymentMethod: 'Credit Card',
      status: 'Delivered',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<List<OrderModel>> getAllOrders() async {
    return List.from(_orders);
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    return _orders.where((o) => o.userId == userId).toList();
  }

  Future<OrderModel?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createOrder(OrderModel order) async {
    _orders.insert(0, order);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'Cancelled');
  }
}

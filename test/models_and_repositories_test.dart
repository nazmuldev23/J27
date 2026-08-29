import 'package:flutter_test/flutter_test.dart';
import 'package:j27/models/user_model.dart';
import 'package:j27/models/product_model.dart';
import 'package:j27/models/category_model.dart';
import 'package:j27/models/order_model.dart';
import 'package:j27/models/coupon_model.dart';
import 'package:j27/models/banner_model.dart';
import 'package:j27/models/cart_item_model.dart';
import 'package:j27/repositories/auth_repository.dart';
import 'package:j27/repositories/product_repository.dart';
import 'package:j27/repositories/category_repository.dart';
import 'package:j27/repositories/order_repository.dart';
import 'package:j27/repositories/coupon_repository.dart';
import 'package:j27/repositories/banner_repository.dart';
import 'package:j27/repositories/customer_repository.dart';

void main() {
  group('Models Serialization & Logic Tests', () {
    test('UserModel map conversion & admin getter', () {
      final user = const UserModel(
        id: 'u1',
        name: 'Admin User',
        email: 'admin@test.com',
        phone: '123',
        role: 'admin',
      );

      final map = user.toMap();
      final fromMapUser = UserModel.fromMap(map, 'u1');

      expect(fromMapUser.id, 'u1');
      expect(fromMapUser.isAdmin, isTrue);
      expect(fromMapUser.isActive, isTrue);
    });

    test('ProductModel price calculation & map conversion', () {
      final product = const ProductModel(
        id: 'p1',
        name: 'Test Product',
        price: 100.0,
        discountPrice: 80.0,
        categoryId: 'c1',
        description: 'Desc',
        stock: 10,
        imageUrls: [],
      );

      expect(product.hasDiscount, isTrue);
      expect(product.effectivePrice, 80.0);

      final map = product.toMap();
      final restored = ProductModel.fromMap(map, 'p1');
      expect(restored.name, 'Test Product');
      expect(restored.effectivePrice, 80.0);
    });

    test('CouponModel validity logic', () {
      final validCoupon = CouponModel(
        id: 'cp1',
        code: 'SAVE10',
        discountPercent: 10,
        expiryDate: DateTime.now().add(const Duration(days: 1)),
        isEnabled: true,
      );

      expect(validCoupon.isValid, isTrue);

      final expiredCoupon = CouponModel(
        id: 'cp2',
        code: 'OLD',
        discountPercent: 10,
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
        isEnabled: true,
      );

      expect(expiredCoupon.isValid, isFalse);
    });
  });

  group('Repositories Operations Tests', () {
    test('ProductRepository CRUD', () async {
      final repo = ProductRepository();
      final initialProducts = await repo.getAllProducts();
      expect(initialProducts.isNotEmpty, isTrue);

      const newProduct = ProductModel(
        id: 'p_new',
        name: 'New Item',
        price: 50.0,
        categoryId: 'cat_electronics',
        description: 'New Desc',
        stock: 5,
        imageUrls: [],
      );

      await repo.addProduct(newProduct);
      final productsAfterAdd = await repo.getAllProducts();
      expect(productsAfterAdd.length, initialProducts.length + 1);

      await repo.updateStock('p_new', 20);
      final fetched = await repo.getProductById('p_new');
      expect(fetched?.stock, 20);

      await repo.deleteProduct('p_new');
      final afterDelete = await repo.getProductById('p_new');
      expect(afterDelete, isNull);
    });

    test('OrderRepository order creation and status update', () async {
      final repo = OrderRepository();
      final orders = await repo.getAllOrders();
      final initialCount = orders.length;

      final order = OrderModel(
        id: 'ORD-999',
        userId: 'cust_1',
        customerName: 'Test',
        phone: '123',
        address: 'Addr',
        cityArea: 'City',
        items: [],
        subtotal: 50,
        deliveryCharge: 5,
        totalPrice: 55,
        paymentMethod: 'COD',
        createdAt: DateTime.now(),
      );

      await repo.createOrder(order);
      final updatedOrders = await repo.getAllOrders();
      expect(updatedOrders.length, initialCount + 1);

      await repo.updateOrderStatus('ORD-999', 'Shipped');
      final updated = await repo.getOrderById('ORD-999');
      expect(updated?.status, 'Shipped');
    });
  });
}

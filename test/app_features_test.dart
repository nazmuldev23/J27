import 'package:flutter_test/flutter_test.dart';
import 'package:j27/app/app.dart';
import 'package:j27/providers/shop_provider.dart';
import 'package:j27/models/product_model.dart';
import 'package:j27/models/category_model.dart';
import 'package:j27/models/coupon_model.dart';

void main() {
  group('ShopProvider Business Logic Integration Tests', () {
    test('Cart calculations with coupons and subtotal', () async {
      final shop = ShopProvider();
      await Future.delayed(Duration.zero);

      const p1 = ProductModel(
        id: 'p1',
        name: 'Headphones',
        price: 100.0,
        discountPrice: 80.0,
        categoryId: 'cat_electronics',
        description: 'Desc',
        stock: 10,
        imageUrls: [],
      );

      shop.addToCart(p1, quantity: 2);
      expect(shop.cartItems.length, 1);
      expect(shop.cartSubtotal, 160.0); // 80 * 2
      expect(shop.deliveryCharge, 15.0);
      expect(shop.cartTotal, 175.0); // 160 + 15

      // Apply coupon
      final couponApplied = await shop.applyCoupon('WELCOME10'); // 10% off
      expect(couponApplied, isTrue);
      expect(shop.discountAmount, 16.0); // 10% of 160
      expect(shop.cartTotal, 159.0); // 160 - 16 + 15

      // Place order
      final order = await shop.placeOrder(
        customerName: 'Test Customer',
        phone: '1234567890',
        address: '123 Street',
        cityArea: 'Central',
        paymentMethod: 'Cash on Delivery',
      );

      expect(order.customerName, 'Test Customer');
      expect(order.totalPrice, 159.0);
      expect(shop.cartItems, isEmpty); // Cart cleared after checkout
      expect(shop.orders.contains(order), isTrue);
    });

    test('Wishlist toggle operations', () {
      final shop = ShopProvider();
      const p1 = ProductModel(
        id: 'p1',
        name: 'Shoes',
        price: 50.0,
        categoryId: 'cat_fashion',
        description: 'Desc',
        stock: 5,
        imageUrls: [],
      );

      expect(shop.isWishlisted('p1'), isFalse);
      shop.toggleWishlist(p1);
      expect(shop.isWishlisted('p1'), isTrue);
      shop.toggleWishlist(p1);
      expect(shop.isWishlisted('p1'), isFalse);
    });

    test('Admin CRUD operations via ShopProvider', () async {
      final shop = ShopProvider();
      await Future.delayed(Duration.zero);

      // Category CRUD
      final initialCatCount = shop.categories.length;
      await shop.addCategory(const CategoryModel(id: 'c_test', name: 'Test Cat', imageUrl: ''));
      expect(shop.categories.length, initialCatCount + 1);

      // Product CRUD
      final initialProdCount = shop.products.length;
      await shop.addProduct(const ProductModel(
        id: 'p_admin_test',
        name: 'Admin Test Product',
        price: 99.0,
        categoryId: 'c_test',
        description: 'Desc',
        stock: 5,
        imageUrls: [],
      ));
      expect(shop.products.length, initialProdCount + 1);

      // Coupon CRUD
      await shop.addCoupon(CouponModel(
        id: 'cp_test',
        code: 'TEST20',
        discountPercent: 20.0,
        expiryDate: DateTime.now().add(const Duration(days: 10)),
      ));
      expect(shop.coupons.any((c) => c.code == 'TEST20'), isTrue);

      // Order status transition
      final orderId = shop.orders.first.id;
      await shop.updateOrderStatus(orderId, 'Shipped');
      expect(shop.orders.firstWhere((o) => o.id == orderId).status, 'Shipped');
    });
  });

  group('Widget UI Integration Tests', () {
    testWidgets('App renders splash and transitions to main navigation screen', (WidgetTester tester) async {
      await tester.pumpWidget(const J27());
      expect(find.text('Welcome to J27'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('J27 Store'), findsOneWidget);
      expect(find.text('Popular Products'), findsOneWidget);
    });
  });
}

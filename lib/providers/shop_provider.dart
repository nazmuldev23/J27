import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/coupon_model.dart';
import '../models/banner_model.dart';
import '../models/cart_item_model.dart';
import '../models/wishlist_item_model.dart';

import '../repositories/auth_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/coupon_repository.dart';
import '../repositories/banner_repository.dart';
import '../repositories/customer_repository.dart';

import 'auth_provider.dart';

class ShopProvider extends ChangeNotifier {
  final AuthProvider authProvider = AuthProvider();

  final ProductRepository _productRepo = ProductRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();
  final OrderRepository _orderRepo = OrderRepository();
  final CouponRepository _couponRepo = CouponRepository();
  final BannerRepository _bannerRepo = BannerRepository();
  final CustomerRepository _customerRepo = CustomerRepository();

  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<OrderModel> _orders = [];
  List<CouponModel> _coupons = [];
  List<BannerModel> _banners = [];
  List<UserModel> _customers = [];

  final List<CartItemModel> _cartItems = [];
  final List<WishlistItemModel> _wishlistItems = [];

  CouponModel? _appliedCoupon;
  double _deliveryCharge = 15.0;

  ShopProvider() {
    _loadInitialData();
    authProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authProvider.removeListener(notifyListeners);
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    _products = await _productRepo.getAllProducts();
    _categories = await _categoryRepo.getAllCategories();
    _orders = await _orderRepo.getAllOrders();
    _coupons = await _couponRepo.getAllCoupons();
    _banners = await _bannerRepo.getAllBanners();
    _customers = await _customerRepo.getAllCustomers();
    notifyListeners();
  }

  // Getters
  List<ProductModel> get products => List.unmodifiable(_products);
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<CouponModel> get coupons => List.unmodifiable(_coupons);
  List<BannerModel> get banners => List.unmodifiable(_banners);
  List<UserModel> get customers => List.unmodifiable(_customers);

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);
  List<WishlistItemModel> get wishlistItems => List.unmodifiable(_wishlistItems);

  CouponModel? get appliedCoupon => _appliedCoupon;
  double get deliveryCharge => _cartItems.isEmpty ? 0.0 : _deliveryCharge;

  List<ProductModel> get popularProducts => _products.where((p) => p.isPopular).toList();
  List<ProductModel> get newProducts => _products.where((p) => p.isNew).toList();
  List<ProductModel> get offerProducts => _products.where((p) => p.hasDiscount || p.offerTag.isNotEmpty).toList();

  double get cartSubtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (_appliedCoupon == null || !_appliedCoupon!.isValid) return 0.0;
    return (cartSubtotal * _appliedCoupon!.discountPercent) / 100.0;
  }

  double get cartTotal => (cartSubtotal - discountAmount + deliveryCharge).clamp(0.0, double.infinity);

  // Cart Operations
  void addToCart(ProductModel product, {int quantity = 1, String size = '', String color = ''}) {
    final index = _cartItems.indexWhere((it) =>
        it.product.id == product.id && it.selectedSize == size && it.selectedColor == color);

    if (index >= 0) {
      final existing = _cartItems[index];
      _cartItems[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      _cartItems.add(CartItemModel(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity, {String size = '', String color = ''}) {
    final index = _cartItems.indexWhere((it) =>
        it.product.id == productId && it.selectedSize == size && it.selectedColor == color);

    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId, {String size = '', String color = ''}) {
    _cartItems.removeWhere((it) =>
        it.product.id == productId && it.selectedSize == size && it.selectedColor == color);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  Future<bool> applyCoupon(String code) async {
    final coupon = await _couponRepo.getCouponByCode(code);
    if (coupon != null && coupon.isValid) {
      _appliedCoupon = coupon;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Wishlist Operations
  bool isWishlisted(String productId) {
    return _wishlistItems.any((w) => w.product.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    final userId = authProvider.currentUser?.id ?? 'guest';
    final index = _wishlistItems.indexWhere((w) => w.product.id == product.id);
    if (index >= 0) {
      _wishlistItems.removeAt(index);
    } else {
      _wishlistItems.add(WishlistItemModel(
        id: 'w_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        product: product,
      ));
    }
    notifyListeners();
  }

  // Order Placement
  Future<OrderModel> placeOrder({
    required String customerName,
    required String phone,
    required String address,
    required String cityArea,
    required String paymentMethod,
  }) async {
    final user = authProvider.currentUser;
    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: user?.id ?? 'cust_guest',
      customerName: customerName,
      phone: phone,
      address: address,
      cityArea: cityArea,
      items: List.from(_cartItems),
      subtotal: cartSubtotal,
      deliveryCharge: deliveryCharge,
      discountAmount: discountAmount,
      totalPrice: cartTotal,
      paymentMethod: paymentMethod,
      status: 'Pending',
      createdAt: DateTime.now(),
    );

    await _orderRepo.createOrder(order);
    _orders = await _orderRepo.getAllOrders();
    clearCart();
    return order;
  }

  // Admin Product Operations
  Future<void> addProduct(ProductModel product) async {
    await _productRepo.addProduct(product);
    _products = await _productRepo.getAllProducts();
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productRepo.updateProduct(product);
    _products = await _productRepo.getAllProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    await _productRepo.deleteProduct(id);
    _products = await _productRepo.getAllProducts();
    notifyListeners();
  }

  Future<void> updateStock(String productId, int newStock) async {
    await _productRepo.updateStock(productId, newStock);
    _products = await _productRepo.getAllProducts();
    notifyListeners();
  }

  // Admin Category Operations
  Future<void> addCategory(CategoryModel category) async {
    await _categoryRepo.addCategory(category);
    _categories = await _categoryRepo.getAllCategories();
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoryRepo.updateCategory(category);
    _categories = await _categoryRepo.getAllCategories();
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _categoryRepo.deleteCategory(id);
    _categories = await _categoryRepo.getAllCategories();
    notifyListeners();
  }

  // Admin Order Operations
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _orderRepo.updateOrderStatus(orderId, newStatus);
    _orders = await _orderRepo.getAllOrders();
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    await _orderRepo.cancelOrder(orderId);
    _orders = await _orderRepo.getAllOrders();
    notifyListeners();
  }

  // Admin Customer Operations
  Future<void> updateCustomerStatus(String customerId, String status) async {
    await _customerRepo.updateCustomerStatus(customerId, status);
    _customers = await _customerRepo.getAllCustomers();
    notifyListeners();
  }

  // Admin Coupon Operations
  Future<void> addCoupon(CouponModel coupon) async {
    await _couponRepo.addCoupon(coupon);
    _coupons = await _couponRepo.getAllCoupons();
    notifyListeners();
  }

  Future<void> toggleCouponStatus(String id, bool isEnabled) async {
    await _couponRepo.toggleCouponStatus(id, isEnabled);
    _coupons = await _couponRepo.getAllCoupons();
    notifyListeners();
  }

  Future<void> deleteCoupon(String id) async {
    await _couponRepo.deleteCoupon(id);
    _coupons = await _couponRepo.getAllCoupons();
    notifyListeners();
  }

  // Admin Banner Operations
  Future<void> addBanner(BannerModel banner) async {
    await _bannerRepo.addBanner(banner);
    _banners = await _bannerRepo.getAllBanners();
    notifyListeners();
  }

  Future<void> updateBanner(BannerModel banner) async {
    await _bannerRepo.updateBanner(banner);
    _banners = await _bannerRepo.getAllBanners();
    notifyListeners();
  }

  Future<void> deleteBanner(String id) async {
    await _bannerRepo.deleteBanner(id);
    _banners = await _bannerRepo.getAllBanners();
    notifyListeners();
  }

  static ShopProvider of(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<ShopProviderScope>()?.notifier
        : context.findAncestorWidgetOfExactType<ShopProviderScope>()?.notifier;
    assert(provider != null, 'No ShopProviderScope found in context');
    return provider!;
  }
}

class ShopProviderScope extends InheritedNotifier<ShopProvider> {
  const ShopProviderScope({
    super.key,
    required ShopProvider super.notifier,
    required super.child,
  });

  static ShopProvider of(BuildContext context) {
    return ShopProvider.of(context);
  }
}

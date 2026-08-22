import 'package:flutter/material.dart';
import '../data/sample_products.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class ShopProvider extends ChangeNotifier {
  final List<Product> _products = List.from(sampleProducts);
  final List<CartItem> _cartItems = [];
  final Set<String> _favoriteIds = {};
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products {
    return _products.where((prod) {
      final matchesSearch = prod.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prod.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || prod.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get categories {
    final list = _products.map((e) => e.category).toSet().toList();
    list.sort();
    return ['All', ...list];
  }

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotalAmount => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
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
}

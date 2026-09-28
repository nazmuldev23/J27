import '../models/product_model.dart';

class ProductRepository {
  final List<ProductModel> _products = [
    const ProductModel(
      id: 'p1',
      name: 'Wireless Noise Canceling Headphones',
      price: 299.99,
      discountPrice: 249.99,
      categoryId: 'cat_electronics',
      description: 'High-fidelity audio with active noise cancellation and 30-hour battery life.',
      stock: 45,
      imageUrls: [],
      sizes: ['Standard'],
      colors: ['Black', 'Silver', 'Navy'],
      isPopular: true,
      isNew: true,
      offerTag: '20% OFF',
    ),
    const ProductModel(
      id: 'p2',
      name: 'Smart Fitness Watch Series 7',
      price: 199.99,
      discountPrice: 169.99,
      categoryId: 'cat_electronics',
      description: 'Track workouts, heart rate, sleep metrics, and receive instant notifications.',
      stock: 28,
      imageUrls: [],
      sizes: ['40mm', '44mm'],
      colors: ['Graphite', 'Rose Gold', 'Silver'],
      isPopular: true,
      isNew: false,
      offerTag: 'Hot Deal',
    ),
    const ProductModel(
      id: 'p3',
      name: 'Ergonomic Premium Running Shoes',
      price: 120.00,
      discountPrice: 99.00,
      categoryId: 'cat_fashion',
      description: 'Breathable lightweight knit mesh sneakers designed for maximum comfort and mileage.',
      stock: 60,
      imageUrls: [],
      sizes: ['US 8', 'US 9', 'US 10', 'US 11'],
      colors: ['Red', 'Black', 'Blue'],
      isPopular: true,
      isNew: true,
      offerTag: 'Best Seller',
    ),
    const ProductModel(
      id: 'p4',
      name: 'Minimalist Leather Backpack',
      price: 89.99,
      discountPrice: 79.99,
      categoryId: 'cat_fashion',
      description: 'Genuine handcrafted leather backpack with 15-inch laptop compartment.',
      stock: 15,
      imageUrls: [],
      sizes: ['Medium', 'Large'],
      colors: ['Tan Brown', 'Black'],
      isPopular: false,
      isNew: true,
      offerTag: 'New Arrival',
    ),
    const ProductModel(
      id: 'p5',
      name: 'Stainless Steel Insulated Water Bottle',
      price: 29.99,
      discountPrice: 24.99,
      categoryId: 'cat_home',
      description: 'Double-wall vacuum insulation keeps beverages cold for 24 hours or hot for 12 hours.',
      stock: 100,
      imageUrls: [],
      sizes: ['500ml', '750ml', '1000ml'],
      colors: ['Matte Black', 'Ocean Blue', 'White'],
      isPopular: false,
      isNew: false,
      offerTag: '15% OFF',
    ),
  ];

  Future<List<ProductModel>> getAllProducts() async {
    return List.from(_products);
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  Future<List<ProductModel>> getPopularProducts() async {
    return _products.where((p) => p.isPopular).toList();
  }

  Future<List<ProductModel>> getNewProducts() async {
    return _products.where((p) => p.isNew).toList();
  }

  Future<List<ProductModel>> getOfferProducts() async {
    return _products.where((p) => p.hasDiscount || p.offerTag.isNotEmpty).toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    _products.add(product);
  }

  Future<void> updateProduct(ProductModel product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }

  Future<void> updateStock(String productId, int newStock) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(stock: newStock);
    }
  }
}

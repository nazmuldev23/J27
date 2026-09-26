import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../providers/shop_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String _selectedSize = '';
  String _selectedColor = '';

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final isWishlisted = shop.isWishlisted(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.white,
            ),
            onPressed: () => shop.toggleWishlist(widget.product),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Display
                  Container(
                    height: 280,
                    width: double.infinity,
                    color: Colors.indigo.shade50,
                    child: Center(
                      child: Icon(Icons.shopping_bag, size: 100, color: Colors.indigo.shade300),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.product.stock > 0 ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.product.stock > 0 ? 'Stock: ${widget.product.stock}' : 'Out of Stock',
                                style: TextStyle(
                                  color: widget.product.stock > 0 ? Colors.green.shade900 : Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Price and Discount
                        Row(
                          children: [
                            Text(
                              '\$${widget.product.effectivePrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            if (widget.product.hasDiscount) ...[
                              const SizedBox(width: 8),
                              Text(
                                '\$${widget.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SAVE NOW',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const Divider(height: 32),

                        // Sizes Selector if available
                        if (widget.product.sizes.isNotEmpty) ...[
                          const Text('Select Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.product.sizes.map((s) {
                              final isSelected = _selectedSize == s;
                              return ChoiceChip(
                                label: Text(s),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) setState(() => _selectedSize = s);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Colors Selector if available
                        if (widget.product.colors.isNotEmpty) ...[
                          const Text('Select Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.product.colors.map((c) {
                              final isSelected = _selectedColor == c;
                              return ChoiceChip(
                                label: Text(c),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) setState(() => _selectedColor = c);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Quantity selector
                        Row(
                          children: [
                            const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _quantity < widget.product.stock
                                  ? () => setState(() => _quantity++)
                                  : null,
                            ),
                          ],
                        ),

                        const Divider(height: 32),

                        // Description
                        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar Actions (Add to Cart / Buy Now)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.indigo),
                    ),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                    onPressed: widget.product.stock > 0
                        ? () {
                            shop.addToCart(
                              widget.product,
                              quantity: _quantity,
                              size: _selectedSize,
                              color: _selectedColor,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to Cart!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.product.stock > 0
                        ? () {
                            shop.addToCart(
                              widget.product,
                              quantity: _quantity,
                              size: _selectedSize,
                              color: _selectedColor,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CartScreen()),
                            );
                          }
                        : null,
                    child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/product_model.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String? selectedCategoryId;

  const CategoryScreen({super.key, this.selectedCategoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? _activeCategoryFilter;

  @override
  void initState() {
    super.initState();
    _activeCategoryFilter = widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final categories = shop.categories;

    final filteredProducts = _activeCategoryFilter == null
        ? shop.products
        : shop.products
              .where((p) => p.categoryId == _activeCategoryFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories & Products')),
      body: Column(
        children: [
          // Category filter chip bar
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ChoiceChip(
                  label: const Text('All Categories'),
                  selected: _activeCategoryFilter == null,
                  selectedColor: Colors.orange,
                   backgroundColor: Colors.grey.shade200,
                   labelStyle: TextStyle(
                        color: _activeCategoryFilter == null
                            ? Colors.white
                            : Colors.black,
                      ),

                  onSelected: (_) =>
                      setState(() => _activeCategoryFilter = null),
                ),
                const SizedBox(width: 8),
                ...categories.map((cat) {
                  final isSelected = _activeCategoryFilter == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      selectedColor: Colors.orange,

                      // Selected না হলে এই color
                      backgroundColor: Colors.grey.shade200,

                      // Text color
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _activeCategoryFilter = val ? cat.id : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // Product list for category
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products available in this category.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductGridCard(context, shop, product);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridCard(
    BuildContext context,
    ShopProvider shop,
    ProductModel product,
  ) {
    final isWishlisted = shop.isWishlisted(product.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.indigo.shade50,
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Colors.indigo.shade300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => shop.toggleWishlist(product),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.effectivePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

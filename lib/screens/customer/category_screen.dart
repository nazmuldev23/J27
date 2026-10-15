import 'package:flutter/material.dart';
import 'package:j27/screens/customer/widgets/product_card.dart';
import '../../providers/shop_provider.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Categories & Products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
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
                      return ProductCard(product: product, shop: shop);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

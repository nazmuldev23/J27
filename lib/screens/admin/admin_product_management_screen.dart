import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/product_model.dart';

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({super.key});

  @override
  State<AdminProductManagementScreen> createState() => _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState extends State<AdminProductManagementScreen> {
  void _openProductDialog([ProductModel? product]) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product != null ? product.price.toString() : '');
    final discountController = TextEditingController(text: product != null ? product.discountPrice.toString() : '');
    final descController = TextEditingController(text: product?.description ?? '');
    final stockController = TextEditingController(text: product != null ? product.stock.toString() : '');
    final imageController = TextEditingController(text: product != null && product.imageUrls.isNotEmpty ? product.imageUrls.join(', ') : '');
    final sizesController = TextEditingController(text: product != null ? product.sizes.join(', ') : '');
    final colorsController = TextEditingController(text: product != null ? product.colors.join(', ') : '');

    final shop = ShopProviderScope.of(context);
    String selectedCategory = product?.categoryId ?? (shop.categories.isNotEmpty ? shop.categories.first.id : '');
    bool isPopular = product?.isPopular ?? false;
    bool isNew = product?.isNew ?? false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(product == null ? 'Add Product' : 'Edit Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Product Name'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Price (\$)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Discount Price (\$)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedCategory.isNotEmpty ? selectedCategory : null,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: shop.categories.map((c) {
                        return DropdownMenuItem(value: c.id, child: Text(c.name));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock Quantity'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(labelText: 'Image URLs (comma separated)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: sizesController,
                      decoration: const InputDecoration(labelText: 'Sizes (comma separated: S, M, L)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: colorsController,
                      decoration: const InputDecoration(labelText: 'Colors (comma separated: Red, Black)'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: isPopular,
                          onChanged: (val) => setDialogState(() => isPopular = val ?? false),
                        ),
                        const Text('Popular Item'),
                        Checkbox(
                          value: isNew,
                          onChanged: (val) => setDialogState(() => isNew = val ?? false),
                        ),
                        const Text('New Arrival'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                ElevatedButton(
                  child: Text(product == null ? 'Add' : 'Save'),
                  onPressed: () async {
                    final newProduct = ProductModel(
                      id: product?.id ?? 'p_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      price: double.tryParse(priceController.text.trim()) ?? 0.0,
                      discountPrice: double.tryParse(discountController.text.trim()) ?? 0.0,
                      categoryId: selectedCategory,
                      description: descController.text.trim(),
                      stock: int.tryParse(stockController.text.trim()) ?? 0,
                      imageUrls: imageController.text.trim().isNotEmpty
                          ? imageController.text.split(',').map((e) => e.trim()).toList()
                          : [],
                      sizes: sizesController.text.trim().isNotEmpty
                          ? sizesController.text.split(',').map((e) => e.trim()).toList()
                          : [],
                      colors: colorsController.text.trim().isNotEmpty
                          ? colorsController.text.split(',').map((e) => e.trim()).toList()
                          : [],
                      isPopular: isPopular,
                      isNew: isNew,
                    );

                    if (product == null) {
                      await shop.addProduct(newProduct);
                    } else {
                      await shop.updateProduct(newProduct);
                    }

                    if (mounted) Navigator.pop(ctx);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openStockUpdateDialog(ProductModel product) {
    final stockController = TextEditingController(text: product.stock.toString());
    final shop = ShopProviderScope.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update Stock for ${product.name}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New Stock Level'),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () async {
              final newStock = int.tryParse(stockController.text.trim()) ?? product.stock;
              await shop.updateStock(product.id, newStock);
              if (mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final products = shop.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openProductDialog(),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.shopping_bag, color: Colors.indigo.shade300),
                    ),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${product.price} | Stock: ${product.stock}'),
                        Text('Category: ${product.categoryId}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.inventory_2_outlined, color: Colors.blue),
                          onPressed: () => _openStockUpdateDialog(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () => _openProductDialog(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await shop.deleteProduct(product.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProductDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

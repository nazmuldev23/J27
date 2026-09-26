import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/category_model.dart';

class AdminCategoryManagementScreen extends StatefulWidget {
  const AdminCategoryManagementScreen({super.key});

  @override
  State<AdminCategoryManagementScreen> createState() => _AdminCategoryManagementScreenState();
}

class _AdminCategoryManagementScreenState extends State<AdminCategoryManagementScreen> {
  void _openCategoryDialog([CategoryModel? category]) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final imageController = TextEditingController(text: category?.imageUrl ?? '');
    final descController = TextEditingController(text: category?.description ?? '');

    final shop = ShopProviderScope.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            child: Text(category == null ? 'Add' : 'Save'),
            onPressed: () async {
              final newCat = CategoryModel(
                id: category?.id ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
                name: nameController.text.trim(),
                imageUrl: imageController.text.trim(),
                description: descController.text.trim(),
              );

              if (category == null) {
                await shop.addCategory(newCat);
              } else {
                await shop.updateCategory(newCat);
              }

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
    final categories = shop.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openCategoryDialog(),
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No categories available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: Text(cat.name[0]),
                    ),
                    title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(cat.description.isNotEmpty ? cat.description : 'No description', maxLines: 1),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () => _openCategoryDialog(cat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await shop.deleteCategory(cat.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCategoryDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

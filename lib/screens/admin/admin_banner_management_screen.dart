import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/banner_model.dart';

class AdminBannerManagementScreen extends StatefulWidget {
  const AdminBannerManagementScreen({super.key});

  @override
  State<AdminBannerManagementScreen> createState() => _AdminBannerManagementScreenState();
}

class _AdminBannerManagementScreenState extends State<AdminBannerManagementScreen> {
  void _openBannerDialog([BannerModel? banner]) {
    final titleController = TextEditingController(text: banner?.title ?? '');
    final imageController = TextEditingController(text: banner?.imageUrl ?? '');
    final targetController = TextEditingController(text: banner?.targetCategoryOrProduct ?? '');
    final shop = ShopProviderScope.of(context);
    bool isActive = banner?.isActive ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(banner == null ? 'Add Banner' : 'Edit Banner'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Banner Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Banner Image URL'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: targetController,
                    decoration: const InputDecoration(labelText: 'Target Category/Product ID'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: isActive,
                        onChanged: (val) => setDialogState(() => isActive = val ?? true),
                      ),
                      const Text('Is Active Banner'),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              ElevatedButton(
                child: Text(banner == null ? 'Add' : 'Save'),
                onPressed: () async {
                  final newBanner = BannerModel(
                    id: banner?.id ?? 'b_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text.trim(),
                    imageUrl: imageController.text.trim(),
                    targetCategoryOrProduct: targetController.text.trim(),
                    isActive: isActive,
                  );

                  if (banner == null) {
                    await shop.addBanner(newBanner);
                  } else {
                    await shop.updateBanner(newBanner);
                  }

                  if (mounted) Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final banners = shop.banners;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openBannerDialog(),
          ),
        ],
      ),
      body: banners.isEmpty
          ? const Center(child: Text('No banners available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: banners.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final banner = banners[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Center(child: Icon(Icons.view_carousel, size: 40, color: Colors.indigo.shade300)),
                      ),
                      ListTile(
                        title: Text(banner.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Status: ${banner.isActive ? "Active" : "Inactive"}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.amber),
                              onPressed: () => _openBannerDialog(banner),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await shop.deleteBanner(banner.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBannerDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

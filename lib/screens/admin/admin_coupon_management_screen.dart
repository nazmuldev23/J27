import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/coupon_model.dart';

class AdminCouponManagementScreen extends StatefulWidget {
  const AdminCouponManagementScreen({super.key});

  @override
  State<AdminCouponManagementScreen> createState() => _AdminCouponManagementScreenState();
}

class _AdminCouponManagementScreenState extends State<AdminCouponManagementScreen> {
  void _openAddCouponDialog() {
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    DateTime expiryDate = DateTime.now().add(const Duration(days: 30));
    final shop = ShopProviderScope.of(context);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Create New Coupon'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Coupon Code (e.g. SAVE20)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Discount Percentage (%)'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Expiry: ${expiryDate.toString().split(' ').first}'),
                      TextButton(
                        child: const Text('Select Date'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: expiryDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setDialogState(() => expiryDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  final code = codeController.text.trim().toUpperCase();
                  final discount = double.tryParse(discountController.text.trim()) ?? 0.0;
                  if (code.isNotEmpty && discount > 0) {
                    final coupon = CouponModel(
                      id: 'cp_${DateTime.now().millisecondsSinceEpoch}',
                      code: code,
                      discountPercent: discount,
                      expiryDate: expiryDate,
                      isEnabled: true,
                    );
                    await shop.addCoupon(coupon);
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
    final coupons = shop.coupons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddCouponDialog(),
          ),
        ],
      ),
      body: coupons.isEmpty
          ? const Center(child: Text('No coupons created.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coupon = coupons[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade100,
                      child: const Icon(Icons.confirmation_number, color: Colors.red),
                    ),
                    title: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discount: ${coupon.discountPercent}% OFF'),
                        Text('Expiry: ${coupon.expiryDate.toString().split(' ').first}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: coupon.isEnabled,
                          activeColor: Colors.green,
                          onChanged: (val) async {
                            await shop.toggleCouponStatus(coupon.id, val);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await shop.deleteCoupon(coupon.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddCouponDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

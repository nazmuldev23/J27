import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../../models/order_model.dart';

class AdminOrderManagementScreen extends StatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  State<AdminOrderManagementScreen> createState() => _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState extends State<AdminOrderManagementScreen> {
  final List<String> _statuses = ['Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  void _showStatusChangeDialog(OrderModel order) {
    final shop = ShopProviderScope.of(context);
    String selectedStatus = order.status;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Change Status for #${order.id}'),
        content: DropdownButtonFormField<String>(
          value: _statuses.contains(selectedStatus) ? selectedStatus : 'Pending',
          items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) {
            if (val != null) selectedStatus = val;
          },
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            child: const Text('Update Status'),
            onPressed: () async {
              await shop.updateOrderStatus(order.id, selectedStatus);
              if (mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showOrderDetailsDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Order #${order.id} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customer: ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Phone: ${order.phone}'),
              Text('Address: ${order.address}, ${order.cityArea}'),
              Text('Payment: ${order.paymentMethod}'),
              Text('Status: ${order.status}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(height: 20),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.map((it) => Text('• ${it.product.name} x${it.quantity} (\$${it.totalPrice})')),
              const Divider(height: 20),
              Text('Total Price: \$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        actions: [
          TextButton(child: const Text('Close'), onPressed: () => Navigator.pop(ctx)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final orders = shop.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text('Customer: ${order.customerName} (${order.phone})'),
                        Text('Status: ${order.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.indigo),
                          onPressed: () => _showStatusChangeDialog(order),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.grey),
                          onPressed: () => _showOrderDetailsDialog(order),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                          onPressed: () async {
                            await shop.cancelOrder(order.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

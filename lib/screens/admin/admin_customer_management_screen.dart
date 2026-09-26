import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';

class AdminCustomerManagementScreen extends StatelessWidget {
  const AdminCustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final customers = shop.customers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
      ),
      body: customers.isEmpty
          ? const Center(child: Text('No customers found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: customers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final customer = customers[index];
                final customerOrders = shop.orders.where((o) => o.userId == customer.id).length;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        customer.name.isNotEmpty ? customer.name[0] : 'C',
                        style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${customer.email}'),
                        Text('Phone: ${customer.phone}'),
                        Text('Total Orders: $customerOrders'),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: customer.isActive ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Status: ${customer.accountStatus.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: customer.isActive ? Colors.green.shade900 : Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      value: customer.isActive,
                      activeColor: Colors.teal,
                      onChanged: (val) async {
                        final newStatus = val ? 'active' : 'disabled';
                        await shop.updateCustomerStatus(customer.id, newStatus);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

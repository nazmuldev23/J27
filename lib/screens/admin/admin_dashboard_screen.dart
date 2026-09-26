import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import 'admin_product_management_screen.dart';
import 'admin_category_management_screen.dart';
import 'admin_order_management_screen.dart';
import 'admin_customer_management_screen.dart';
import 'admin_coupon_management_screen.dart';
import 'admin_banner_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);

    final totalProducts = shop.products.length;
    final totalOrders = shop.orders.length;
    final pendingOrders = shop.orders.where((o) => o.status.toLowerCase() == 'pending').length;
    final completedOrders = shop.orders.where((o) => o.status.toLowerCase() == 'delivered').length;
    final totalCustomers = shop.customers.length;
    final totalSales = shop.orders
        .where((o) => o.status.toLowerCase() != 'cancelled')
        .fold(0.0, (sum, o) => sum + o.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dashboard Refreshed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Store Dashboard Metrics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Grid of Metrics Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildMetricCard('Total Products', '$totalProducts', Icons.inventory_2, Colors.blue),
                _buildMetricCard('Total Orders', '$totalOrders', Icons.shopping_bag, Colors.purple),
                _buildMetricCard('Pending Orders', '$pendingOrders', Icons.pending_actions, Colors.orange),
                _buildMetricCard('Completed Orders', '$completedOrders', Icons.check_circle, Colors.green),
                _buildMetricCard('Total Customers', '$totalCustomers', Icons.people, Colors.teal),
                _buildMetricCard('Total Sales', '\$${totalSales.toStringAsFixed(2)}', Icons.attach_money, Colors.indigo),
              ],
            ),

            const SizedBox(height: 28),
            const Text(
              'Management Modules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Navigation Module Buttons
            _buildAdminMenuTile(
              context: context,
              icon: Icons.storefront,
              title: 'Product Management',
              subtitle: 'Add, edit, delete products & stock',
              color: Colors.blue,
              destination: const AdminProductManagementScreen(),
            ),
            _buildAdminMenuTile(
              context: context,
              icon: Icons.category,
              title: 'Category Management',
              subtitle: 'Add, edit, delete categories',
              color: Colors.orange,
              destination: const AdminCategoryManagementScreen(),
            ),
            _buildAdminMenuTile(
              context: context,
              icon: Icons.list_alt,
              title: 'Order Management',
              subtitle: 'View orders & change status lifecycle',
              color: Colors.purple,
              destination: const AdminOrderManagementScreen(),
            ),
            _buildAdminMenuTile(
              context: context,
              icon: Icons.people,
              title: 'Customer Management',
              subtitle: 'Customer list & account status',
              color: Colors.teal,
              destination: const AdminCustomerManagementScreen(),
            ),
            _buildAdminMenuTile(
              context: context,
              icon: Icons.confirmation_number,
              title: 'Coupon Management',
              subtitle: 'Create promo codes & expiry dates',
              color: Colors.red,
              destination: const AdminCouponManagementScreen(),
            ),
            _buildAdminMenuTile(
              context: context,
              icon: Icons.view_carousel,
              title: 'Banner Management',
              subtitle: 'Promotional home banners',
              color: Colors.indigo,
              destination: const AdminBannerManagementScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget destination,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}

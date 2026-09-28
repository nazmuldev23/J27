import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import '../auth/login_screen.dart';
import 'my_orders_screen.dart';
import 'wishlist_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopProviderScope.of(context);
    final user = shop.authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('You are not logged in', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Log In / Register'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Header
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: user.isAdmin ? Colors.purple.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      user.isAdmin ? 'Role: ADMIN' : 'Role: Customer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: user.isAdmin ? Colors.purple.shade900 : Colors.blue.shade900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  // Quick Links
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
                    title: const Text('My Orders'),
                    subtitle: const Text('Check status of active & completed orders'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.favorite_border, color: Colors.red),
                    title: const Text('Wishlist'),
                    subtitle: const Text('View saved favorite items'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WishlistScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: Colors.indigo),
                    title: const Text('Delivery Address'),
                    subtitle: Text(user.address.isNotEmpty ? user.address : 'No default address set'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(),

                  // Admin Switcher Option if Admin or Demo Mode
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Colors.purple),
                    title: const Text('Admin Panel Dashboard'),
                    subtitle: const Text('Manage Store, Products, Orders, Customers'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () async {
                        await shop.authProvider.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out successfully.')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

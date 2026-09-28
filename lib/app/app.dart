import 'package:flutter/material.dart';
import 'package:j27/screens/customer/wishlist_screen.dart';
import '../providers/shop_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/splash_screen.dart';

class J27 extends StatefulWidget {
  const J27({super.key});

  @override
  State<J27> createState() => _J27State();
}

class _J27State extends State<J27> {
  late final ShopProvider _shopProvider;

  @override
  void initState() {
    super.initState();
    _shopProvider = ShopProvider();
  }

  @override
  void dispose() {
    _shopProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShopProviderScope(
      notifier: _shopProvider,
      child: MaterialApp(
        title: 'J27 E-Commerce',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            )
          ),
          iconTheme: IconThemeData(
            color: Colors.lightBlue
          )
        ),

        home: const SplashScreen(),

        routes: {
          LoginScreen.name: (context) => const LoginScreen(),
          MainNavigationScreen.name: (context) => const MainNavigationScreen(),
          WishlistScreen.name: (context)=> const  WishlistScreen(),

        },
      ),
    );
  }
}
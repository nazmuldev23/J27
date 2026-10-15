import 'package:flutter/material.dart';

import 'package:j27/providers/shop_provider.dart';
import 'package:j27/screens/splash_screen.dart';

import '../widgets/global_background.dart';
import 'app_theme.dart';
import 'app_routing.dart';

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
        // App Theme
        theme: AppTheme.lightTheme.copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          )
        ),
        builder: (context, child) {
          return GlobalBackground(child: child ?? const SizedBox.shrink());
        },
        // Initial Screen
        home: const SplashScreen(),

        // Named Routes
        routes: AppRouting.routes,
      ),
    );
  }
}

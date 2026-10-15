import 'package:flutter/material.dart';

import 'package:j27/screens/auth/login_screen.dart';
import 'package:j27/screens/main_navigation_screen.dart';
import 'package:j27/screens/customer/profile_screen.dart';
import 'package:j27/screens/customer/wishlist_screen.dart';

class AppRouting {
  AppRouting._();

  static Map<String, WidgetBuilder> get routes {
    return {
      LoginScreen.name: (context) => const LoginScreen(),

      MainNavigationScreen.name:
          (context) => const MainNavigationScreen(),

      WishlistScreen.name:
          (context) => const WishlistScreen(),

      ProfileScreen.name:
          (context) => const ProfileScreen(),
    };
  }
}

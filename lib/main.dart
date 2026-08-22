import 'package:flutter/material.dart';
import 'package:j27/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try initializing Firebase if available, catch error gracefully if options are unconfigured
  try {
    // Firebase initialization can be performed here when options are configured
  } catch (e) {
    debugPrint('Firebase initialization skipped or failed: $e');
  }

  runApp(const J27());
}

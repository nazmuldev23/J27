import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:j27/app/app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const J27());
}

import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            Text("Welcome to J27",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

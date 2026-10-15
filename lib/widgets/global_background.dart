import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  final Widget child;

  const GlobalBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Light background
        const ColoredBox(
          color: Color(0xFFFFFAFC),
        ),

        // Background image
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.20,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Background error: $error');
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),

        // Screen content
        child,
      ],
    );
  }
}
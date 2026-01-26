// app_scaling.dart
import 'package:flutter/material.dart';

class AppScaling {
  static double get scaleFactor {
    final screenHeight = WidgetsBinding.instance.window.physicalSize.height;
    // Si hauteur > 1200px, garder taille normale, sinon réduire
    return screenHeight > 1200 ? 1.0 : 0.85;
  }

  static double scaled(double value) => value * scaleFactor;
}

// Widget pour appliquer le scaling
class ScaledWidget extends StatelessWidget {
  final Widget child;

  const ScaledWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(scale: AppScaling.scaleFactor, child: child);
  }
}

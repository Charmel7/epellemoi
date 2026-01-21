// widgets/background/typographic_background.dart
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TypographicBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const TypographicBackground({
    super.key,
    required this.child,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond de base
        Container(decoration: BoxDecoration(gradient: AppColors.degradeBleu)),

        // Éléments typographiques
        _buildTypographicElements(),

        // Contenu principal
        child,
      ],
    );
  }

  Widget _buildTypographicElements() {
    const List<String> symbols = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'Æ',
      'Œ',
      'Ç',
      'É',
      'È',
      'À',
      'Ù',
      'Ê',
      'Î',
      'Ô',
      'Û',
      'Ë',
      'Ï',
      'Ü',
    ];

    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              children: List.generate(40, (index) {
                final random = Random(index);
                final symbol = symbols[random.nextInt(symbols.length)];
                final size = 20.0 + random.nextDouble() * 60.0;
                final rotation = random.nextDouble() * 360;
                final opacity = 0.03 + random.nextDouble() * 0.07;

                return Positioned(
                  left: random.nextDouble() * width,
                  top: random.nextDouble() * height,
                  child: Transform.rotate(
                    angle: rotation * (3.1415926535 / 180),
                    child: Opacity(
                      opacity: opacity * this.opacity,
                      child: Text(
                        symbol,
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: size,
                          color: AppColors.blancIvoire,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

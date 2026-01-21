// ui/widgets/background/animated_typography_background.dart
import 'package:flutter/material.dart';

class AnimatedTypographyBackground extends StatefulWidget {
  final Widget child;

  const AnimatedTypographyBackground({super.key, required this.child});

  @override
  State<AnimatedTypographyBackground> createState() =>
      _AnimatedTypographyBackgroundState();
}

class _AnimatedTypographyBackgroundState
    extends State<AnimatedTypographyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(
                  0xFF0B1E3A,
                ).withOpacity(0.95 + _animation.value * 0.05),
                const Color(
                  0xFF051223,
                ).withOpacity(0.9 + _animation.value * 0.1),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Effet de particules typographiques
              _buildFloatingLetters(),

              // Motifs subtils
              _buildGeometricPatterns(),

              // Lueur ambiante
              _buildAmbientGlow(_animation.value),

              // Contenu principal
              widget.child,
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingLetters() {
    const List<String> letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'M',
      'N',
      'O',
      'P',
      'Q',
    ];

    return IgnorePointer(
      child: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: List.generate(15, (index) {
                final letter = letters[index % letters.length];
                final size = 24 + (index % 5) * 12;
                final opacity = 0.02 + (index % 3) * 0.01;

                return Positioned(
                  left: _randomPosition(index, constraints.maxWidth),
                  top: _randomPosition(index * 2, constraints.maxHeight),
                  child: AnimatedOpacity(
                    duration: Duration(seconds: 10 + index),
                    opacity: opacity,
                    child: Transform.rotate(
                      angle: index * 0.1,
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: size.toDouble(),
                          color: Colors.white.withOpacity(0.1),
                          fontWeight: FontWeight.w100,
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

  Widget _buildGeometricPatterns() {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GeometricPatternPainter(),
        size: const Size(double.infinity, double.infinity),
      ),
    );
  }

  Widget _buildAmbientGlow(double animationValue) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5 + animationValue * 0.1,
          colors: [
            const Color(0xFFC9A24D).withOpacity(0.03),
            const Color(0xFFC9A24D).withOpacity(0.01),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  double _randomPosition(int seed, double max) {
    final random = (seed * 123.456) % max;
    return random;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9A24D).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Grille subtile
    const step = 50.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

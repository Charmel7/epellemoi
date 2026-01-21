// ui/widgets/common/premium_card.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final IconData? titleIcon;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final bool avecReflection;

  const PremiumCard({
    super.key,
    required this.child,
    this.title,
    this.titleIcon,
    this.borderColor,
    this.padding = const EdgeInsets.all(24),
    this.avecReflection = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bleuMarineClair.withOpacity(0.8),
            AppColors.bleuMarine.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: (borderColor ?? AppColors.or).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: (borderColor ?? AppColors.or).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Effet de reflet
          if (avecReflection) _buildReflectionEffect(),

          // Contenu
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) _buildTitle(),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        if (titleIcon != null) Icon(titleIcon, color: AppColors.or, size: 20),
        if (titleIcon != null) const SizedBox(width: 10),
        Text(
          title!,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionEffect() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// widgets/common/styled_frame.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';

// widgets/common/styled_frame.dart - VERSION SIMPLIFIÉE
class StyledFrame extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? borderRadius;
  final bool avecOmbre;
  final bool avecBordureDouble;
  final EdgeInsetsGeometry? padding;

  const StyledFrame({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.avecOmbre = true,
    this.avecBordureDouble = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double rayon = borderRadius ?? AppConstants.rayonMoyen;

    Widget content = Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.bleuMarine.withOpacity(0.8),
        borderRadius: BorderRadius.circular(rayon),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bleuMarineClair30, AppColors.bleuMarine70],
        ),
        boxShadow: avecOmbre ? _buildShadow() : null,
        // CORRECTION: Utiliser Border pour la bordure simple
        border: avecBordureDouble
            ? Border.all(
                color: AppColors.or,
                width: AppConstants.epaisseurBordure,
              )
            : null,
      ),
      child: child,
    );

    // Ajouter un padding si spécifié
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(rayon),
      child: content,
    );
  }

  List<BoxShadow> _buildShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: AppColors.or.withOpacity(0.1),
        blurRadius: 5,
        spreadRadius: 1,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

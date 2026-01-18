import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constant.dart';

class DualScreenLayout extends StatelessWidget {
  final Widget adminPanel;
  final Widget projectionPanel;

  const DualScreenLayout({
    super.key,
    required this.adminPanel,
    required this.projectionPanel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Row(
          children: [
            // Écran Admin (Gauche)
            Expanded(
              child: Container(color: AppColors.bleuMarine, child: adminPanel),
            ),

            // Séparateur
            Container(
              width: AppConstants.largeurSeparateur,
              color: AppColors.or,
            ),

            // Écran Projection (Droite)
            Expanded(
              child: Container(color: Colors.black, child: projectionPanel),
            ),
          ],
        ),
      ),
    );
  }
}

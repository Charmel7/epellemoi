// Nouvelle version de dual_screen_layout.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

import '../../core/constants/app_colors.dart';

class DualScreenLayout extends StatefulWidget {
  final Widget adminPanel;
  final Widget projectionPanel;
  final bool isProductionMode;

  const DualScreenLayout({
    super.key,
    required this.adminPanel,
    required this.projectionPanel,
    this.isProductionMode = false,
  });

  @override
  State<DualScreenLayout> createState() => _DualScreenLayoutState();
}

class _DualScreenLayoutState extends State<DualScreenLayout> {
  late List<Display> _screens;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    try {
      _screens = await screenRetriever.getAllDisplays();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Erreur détection écrans: $e');
      _screens = [];
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!widget.isProductionMode || _screens.length < 2) {
      // MODE DÉVELOPPEMENT ou un seul écran
      return _buildDevelopmentLayout();
    }

    // MODE PRODUCTION avec 2+ écrans
    return _buildProductionLayout();
  }

  Widget _buildDevelopmentLayout() {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          // Admin - 50%
          Expanded(
            child: Container(
              color: AppColors.bleuMarine,
              child: widget.adminPanel,
            ),
          ),

          // Séparateur visible
          Container(
            width: 4,
            color: AppColors.or,
            child: Center(
              child: Container(width: 2, color: Colors.white.withOpacity(0.3)),
            ),
          ),

          // Projection - 50%
          Expanded(
            child: Container(
              color: Colors.black,
              child: widget.projectionPanel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionLayout() {
    final screen1 = _screens[0]; // Écran PC (admin)
    final screen2 = _screens[1]; // Écran Projecteur (projection)

    final totalWidth = screen1.size.width + screen2.size.width;
    final totalHeight = math.max(screen1.size.height, screen2.size.height);

    // Calculer les proportions basées sur les résolutions réelles
    final adminWidthRatio = screen1.size.width / totalWidth;
    final projectionWidthRatio = screen2.size.width / totalWidth;

    return Container(
      width: totalWidth,
      height: totalHeight,
      color: Colors.black,
      child: Row(
        children: [
          // ÉCRAN PC (Admin) - PLEIN ÉCRAN
          SizedBox(
            width: screen1.size.width,
            height: totalHeight,
            child: Container(
              color: AppColors.bleuMarine,
              child: widget.adminPanel,
            ),
          ),

          // ÉCRAN PROJECTEUR (Projection) - PLEIN ÉCRAN
          SizedBox(
            width: screen2.size.width,
            height: totalHeight,
            child: Container(
              color: Colors.black,
              child: widget.projectionPanel,
            ),
          ),
        ],
      ),
    );
  }
}

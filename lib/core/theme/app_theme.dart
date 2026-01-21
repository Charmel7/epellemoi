// core/theme/app_theme.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get premiumTheme {
    return ThemeData.dark().copyWith(
      // Couleurs principales
      primaryColor: AppColors.or,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.serifTitle.copyWith(fontSize: 24),
        iconTheme: const IconThemeData(color: AppColors.or, size: 32),
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.or,
          foregroundColor: AppColors.bleuMarineFonce,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: AppColors.or.withOpacity(0.5),
          textStyle: AppTextStyles.sansSerifMedium.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Cartes
      cardTheme: CardThemeData(
        color: AppColors.bleuMarine.withOpacity(0.7),
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.or.withOpacity(0.3), width: 1),
        ),
        shadowColor: Colors.black.withOpacity(0.5),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bleuMarineClair.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.or, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.or.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.or, width: 2),
        ),
        labelStyle: AppTextStyles.sansSerifMedium.copyWith(
          color: AppColors.blancIvoire,
        ),
        hintStyle: AppTextStyles.sansSerifSmall.copyWith(
          color: AppColors.blancIvoire.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),

      // Diviseurs
      dividerTheme: DividerThemeData(
        color: AppColors.or.withOpacity(0.3),
        thickness: 1,
        space: 20,
      ),
    );
  }

  // Dégradé de fond premium
  static BoxDecoration get backgroundGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.bleuMarineFonce,
          AppColors.bleuMarine,
          AppColors.bleuMarineClair.withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  // Effet de lumière ambiante
  static List<BoxShadow> get ambientLight {
    return [
      BoxShadow(
        color: AppColors.or.withOpacity(0.1),
        blurRadius: 100,
        spreadRadius: 20,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppColors.bleuMarineClair.withOpacity(0.05),
        blurRadius: 50,
        spreadRadius: 10,
        offset: const Offset(0, 30),
      ),
    ];
  }
}

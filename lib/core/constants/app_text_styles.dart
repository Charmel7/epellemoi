// app_text_styles.dart (avec styles de compatibilité)
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // === SERIF - Prestige académique ===
  // Pour les mots officiels, titres, en-têtes
  static TextStyle serifDisplayLarge = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 72,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.1,
  );

  static TextStyle serifDisplayMedium = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 48,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static TextStyle serifTitle = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    color: AppColors.or,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  // === SANS-SERIF - Modernité lisible ===
  // Pour l'interface, le chrono, les contrôles
  static TextStyle sansSerifLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
  );

  static TextStyle sansSerifMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    color: AppColors.blancIvoire,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static TextStyle sansSerifSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: AppColors.blancIvoire.withOpacity(0.8),
    fontWeight: FontWeight.w300,
  );

  // === ÉPELLATION - Affichage spécial ===
  static TextStyle epellationLetter = TextStyle(
    fontFamily: 'Inter',
    fontSize: 80,
    color: AppColors.or,
    fontWeight: FontWeight.w700,
    letterSpacing: 12.0,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(2, 2),
      ),
    ],
  );

  // === CHRONOMÈTRE - Urgence visuelle ===
  static TextStyle chronometer = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 64,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w700,
    letterSpacing: 3.0,
  );

  // === STYLES DE COMPATIBILITÉ (pour les anciens fichiers) ===

  // Pour les mots officiels (Serif - prestigieux) - Ancien
  static TextStyle serifTitre = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static TextStyle serifSousTitre = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 20,
    color: AppColors.blancFroid.withOpacity(0.7),
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
  );

  // Pour l'épellation (Sans-Serif - moderne) - Ancien
  static TextStyle sansSerifLettre = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    color: AppColors.or,
    fontWeight: FontWeight.w700,
    letterSpacing: 10.0,
  );

  // Ancien style (utilisé dans projection_screen.dart)
  static TextStyle sansSerifGrand = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    color: AppColors.blancFroid,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  // === MÉTHODES UTILITAIRES ===

  // Obtient le style équivalent dans le nouveau système
  static TextStyle get equivalentSerifTitre => serifTitle;

  static TextStyle get equivalentSansSerifGrand => sansSerifLarge;

  static TextStyle get equivalentSansSerifLettre => TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    color: AppColors.or,
    fontWeight: FontWeight.w700,
    letterSpacing: 8.0,
  );
}

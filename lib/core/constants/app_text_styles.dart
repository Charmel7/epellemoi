import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Pour les mots officiels (Serif - prestigieux)
  static TextStyle serifTitre = TextStyle(
    fontFamily: 'Serif',
    fontSize: 28,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle serifSousTitre = TextStyle(
    fontFamily: 'Serif',
    fontSize: 20,
    color: Colors.white70,
  );

  // Pour l'épellation (Sans-Serif - moderne)
  static TextStyle sansSerifLettre = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 48,
    color: AppColors.or,
    fontWeight: FontWeight.bold,
    letterSpacing: 10,
  );

  static TextStyle sansSerifGrand = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 72,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );
}

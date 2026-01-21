import 'package:flutter/material.dart';

// app_colors.dart (extended)
class AppColors {
  // Couleurs principales
  static const Color bleuMarine = Color(0xFF0B1E3A); // Bleu nuit profond
  static const Color bleuMarineClair = Color(0xFF1A345B); // Bleu nuit clair
  static const Color bleuMarineFonce = Color(
    0xFF051223,
  ); // Bleu nuit très foncé

  static const Color or = Color(0xFFC9A24D); // Or satiné
  static const Color orClair = Color(0xFFDEC17A); // Or clair (highlights)
  static const Color orFonce = Color(0xFFB0893A); // Or foncé (ombres)

  static const Color blancIvoire = Color(0xFFF8F5EC); // Blanc cassé
  static const Color blancFroid = Color(0xFFFFFFFF); // Blanc pur pour texte
  static const Color bleuMarineClair30 = Color(0x4D1A365D); // 30% d'opacité
  static const Color bleuMarine70 = Color(0xB3001529); // 70% d'opacité

  // États et feedback
  static const Color vertSuccess = Color(0xFF2ECC71); // Vert succès
  static const Color rougeErreur = Color(0xFFE74C3C); // Rouge erreur
  static const Color orangeAttention = Color(0xFFF39C12); // Orange attention
  static const Color bleuAction = Color(0xFF3498DB); // Bleu action

  // Dégradés premium
  static const LinearGradient degradeOr = LinearGradient(
    colors: [orClair, or, orFonce],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient degradeBleu = LinearGradient(
    colors: [bleuMarineClair, bleuMarine, bleuMarineFonce],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

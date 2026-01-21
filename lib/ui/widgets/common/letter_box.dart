import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/constants/app_text_styles.dart';

// 2. Modifier letter_box.dart pour supporter la vérification

class LetterBox extends StatelessWidget {
  final String lettre;
  final bool estVide;
  final bool estActif;
  final bool estCorrecte; // NOUVEAU

  const LetterBox({
    super.key,
    required this.lettre,
    this.estVide = false,
    this.estActif = false,
    this.estCorrecte = true, // Par défaut correct
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer la couleur basée sur la correction
    Color couleurBordure;
    Color couleurTexte;

    if (estActif) {
      couleurBordure = AppColors.or;
      couleurTexte = AppColors.or;
    } else if (!estCorrecte) {
      couleurBordure = AppColors.rougeErreur;
      couleurTexte = AppColors.rougeErreur;
    } else {
      couleurBordure = Colors.white24;
      couleurTexte = Colors.white;
    }

    return Container(
      width: AppConstants.largeurLettre,
      height: AppConstants.hauteurLettre,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: estVide ? Colors.transparent : AppColors.bleuMarineClair,
        border: Border.all(color: couleurBordure, width: estActif ? 3 : 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: estActif
            ? [
                BoxShadow(
                  color: AppColors.or.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          estVide ? '' : lettre,
          style: AppTextStyles.epellationLetter.copyWith(
            color: couleurTexte,
            fontSize: 64, // Taille ajustée
          ),
        ),
      ),
    );
  }
}

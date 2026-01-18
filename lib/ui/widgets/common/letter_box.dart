import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/constants/app_text_styles.dart';

class LetterBox extends StatelessWidget {
  final String lettre;
  final bool estVide;
  final bool estActif;

  const LetterBox({
    super.key,
    required this.lettre,
    this.estVide = false,
    this.estActif = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.largeurLettre,
      height: AppConstants.hauteurLettre,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: estVide ? Colors.transparent : AppColors.bleuMarineClair,
        border: Border.all(
          color: estActif ? AppColors.or : Colors.white24,
          width: estActif ? 3 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          estVide ? '' : lettre,
          style: AppTextStyles.sansSerifLettre.copyWith(
            color: estActif ? AppColors.or : Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:epellemoi/core/models/phase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/competition_service.dart';
import '../../widgets/common/chronometer.dart';
import '../../widgets/common/letter_box.dart';
import '../../widgets/common/reveal_animation.dart';

class ProjectionScreen extends StatelessWidget {
  const ProjectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final competition = Provider.of<CompetitionService>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, AppColors.bleuMarineFonce],
        ),
      ),
      child: Column(
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              border: Border(bottom: BorderSide(color: AppColors.or, width: 2)),
            ),
            child: Column(
              children: [
                Text(
                  competition.phaseActuelle.nomMajuscules,
                  style: AppTextStyles.serifTitre.copyWith(
                    fontSize: 28,
                    color: AppColors.or,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  competition.candidatActuel?.nom.toUpperCase() ??
                      'SÉLECTIONNEZ UN CANDIDAT',
                  style: AppTextStyles.sansSerifGrand.copyWith(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Zone centrale
          Expanded(
            child: Center(
              child: competition.motRevele
                  ? RevealAnimation(
                      mot: competition.motActuel?.orthographeOfficielle ?? '',
                    )
                  : _buildEpellation(competition),
            ),
          ),

          // Pied de page
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              border: Border(top: BorderSide(color: AppColors.or, width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chronomètre
                ChronometerWidget(seconds: competition.chronoRestant),

                // Score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.or, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SCORE',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '${competition.candidatActuel?.score ?? 0}',
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.or,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpellation(CompetitionService competition) {
    final motLength = competition.motActuel?.orthographeOfficielle.length ?? 0;
    final saisie = competition.epellationSaisie;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Titre
        Text(
          'ÉPELLATION EN DIRECT',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 40),

        // Lettres
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(motLength, (index) {
            if (index < saisie.length) {
              return LetterBox(
                lettre: saisie[index],
                estActif: index == saisie.length - 1,
              );
            } else {
              return LetterBox(lettre: '', estVide: true);
            }
          }),
        ),

        const SizedBox(height: 40),

        // Indicateur de progression
        Text(
          '${saisie.length} / $motLength lettres',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }
}

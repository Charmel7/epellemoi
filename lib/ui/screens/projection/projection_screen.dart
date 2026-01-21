import 'package:epellemoi/core/models/phase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/services/competition_service.dart';
import '../../widgets/animations/premium_entrance.dart';
import '../../widgets/common/animated_timer.dart';
import '../../widgets/common/letter_box.dart';

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
          colors: [
            Color(0xFF051223),
            Color(0xFF0B1E3A),
            Color(0xFF1A345B).withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Effet de particules
          _buildParticles(),

          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.bleuMarineFonce, AppColors.bleuMarine],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        AppConstants.nomCompetition,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          color: AppColors.or,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        AppConstants.edition,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // En-tête avec animation
              PremiumEntrance(
                delay: Duration.zero,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Phase du concours
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFC9A24D).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFC9A24D)),
                        ),
                        child: Text(
                          competition.phaseActuelle.nomMajuscules,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 24,
                            color: Color(0xFFC9A24D),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nom du candidat
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Colors.white, Color(0xFFC9A24D)],
                          ).createShader(bounds);
                        },
                        child: Text(
                          competition.candidatActuel?.nom.toUpperCase() ??
                              'EN ATTENTE',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Zone d'épellation
              Expanded(
                child: Center(
                  child: competition.motRevele
                      ? _buildRevealedWord(competition)
                      : _buildLiveSpelling(competition),
                ),
              ),

              // Pied de page
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chronomètre
                    _buildTimer(competition),

                    // Score
                    _buildScore(competition),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticles() {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(painter: _ParticlesPainter()),
      ),
    );
  }

  // Dans projection_screen.dart - modifier _buildRevealedWord

  Widget _buildRevealedWord(CompetitionService competition) {
    final mot = competition.motActuel?.orthographeOfficielle ?? '';
    final estCorrect = competition.epellationEstCorrecte;

    return PremiumEntrance(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              (estCorrect ? Colors.green : Colors.red).withOpacity(0.2),
              (estCorrect ? Colors.green : Colors.red).withOpacity(0.1),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: estCorrect ? Colors.green : Colors.red,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (estCorrect ? Colors.green : Colors.red).withOpacity(0.4),
              blurRadius: 50,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  estCorrect ? Icons.check_circle : Icons.error,
                  color: estCorrect ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Text(
                  estCorrect ? 'CORRECT' : 'INCORRECT',
                  style: TextStyle(
                    fontSize: 24,
                    color: estCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              mot.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 72,
                color: estCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveSpelling(CompetitionService competition) {
    final saisie = competition.epellationSaisie;
    final motOfficiel = competition.motActuel?.orthographeOfficielle ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Titre
        PremiumEntrance(
          child: Text(
            'ÉPELLATION EN DIRECT',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white70,
              letterSpacing: 3,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        const SizedBox(height: 50),

        // AFFICHAGE DYNAMIQUE : UNIQUEMENT les lettres saisies
        if (saisie.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(saisie.length, (index) {
              bool estCorrecte = false;
              if (index < motOfficiel.length) {
                estCorrecte =
                    saisie[index].toUpperCase() ==
                    motOfficiel[index].toUpperCase();
              }

              return LetterBox(
                lettre: saisie[index],
                estActif: index == saisie.length - 1,
                estCorrecte: estCorrecte, // Nouveau paramètre
              );
            }),
          )
        else
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'En attente de la première lettre...',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ),

        const SizedBox(height: 40),

        // Indicateur de progression
        /*  Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            motOfficiel.isNotEmpty
                ? '${saisie.length} / ${motOfficiel.length} lettres'
                : 'Chargement...',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFC9A24D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),*/
      ],
    );
  }

  // Dans projection_screen.dart - remplacer _buildTimer

  // Dans projection_screen.dart - remplacer _buildTimer par :

  Widget _buildTimer(CompetitionService competition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bleuMarineFonce.withOpacity(0.7),
            AppColors.bleuMarine.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.or.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TEMPS RESTANT',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          AnimatedTimer(seconds: competition.chronoRestant, size: 120),
          const SizedBox(height: 10),
          Text(
            competition.chronoRestant > 1 ? 'secondes' : 'seconde',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScore(CompetitionService competition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFC9A24D).withOpacity(0.2),
            Color(0xFFC9A24D).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFC9A24D), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFC9A24D).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'SCORE ACTUEL',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${competition.candidatActuel?.score ?? 0}',
            style: TextStyle(
              fontSize: 56,
              color: Color(0xFFC9A24D),
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final rng = _Random(42);

    for (int i = 0; i < 50; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 2 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Effet de scintillement
    final glowPaint = Paint()
      ..color = Color(0xFFC9A24D).withOpacity(0.02)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    for (int i = 0; i < 10; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 20 + 5;

      canvas.drawCircle(Offset(x, y), radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Random {
  double _seed;

  _Random(this._seed);

  double nextDouble() {
    _seed = (_seed * 9301 + 49297) % 233280;
    return _seed / 233280;
  }
}

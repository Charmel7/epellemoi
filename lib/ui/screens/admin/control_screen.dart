import 'package:epellemoi/core/models/phase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/competition_service.dart';

class ControlScreen extends StatefulWidget {
  final VoidCallback onReinitialiser;
  final bool isProductionMode;

  const ControlScreen({
    super.key,
    required this.onReinitialiser,
    this.isProductionMode = false, // VALEUR PAR DÉFAUT
  });

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late CompetitionService _competition;

  @override
  void initState() {
    super.initState();
    _competition = context.read<CompetitionService>();
  }

  @override
  // Dans control_screen.dart - MODIFIER la méthode build()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Barre supérieure avec bouton de retour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => _showResetDialog(context),
                      tooltip: 'Retour à la configuration',
                    ),

                    // Titre
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'CONSOLE DE RÉGIE',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phase: ${_competition.phaseActuelle.nom}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.or,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Indicateurs
                    Consumer<CompetitionService>(
                      builder: (context, competition, child) {
                        final candidatActuel = competition.candidatActuel;
                        return Row(
                          children: [
                            if (candidatActuel != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.or.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.or),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      candidatActuel.nom,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Score: ${candidatActuel.score}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Contenu principal
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Panneau gauche (Fiche prononceur + Saisie)
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildPronouncerCard(),
                              const SizedBox(height: 16),
                              _buildInputCard(),
                              const SizedBox(height: 16),
                              _buildControlButtons(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Panneau droit (Liste des candidats)
                      Expanded(flex: 1, child: _buildCandidatesPanel()),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // POINT 3: Indicateur de mode production en overlay
          if (widget.isProductionMode)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.tv, size: 14, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      'PRODUCTION',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bleuMarineClair.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.or.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton retour configuration
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () => _showResetDialog(context),
            tooltip: 'Retour à la configuration',
          ),

          // Titre
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CONSOLE DE RÉGIE',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Phase: ${_competition.phaseActuelle.nom}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.or,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Indicateurs
          Consumer<CompetitionService>(
            builder: (context, competition, child) {
              final candidatActuel = competition.candidatActuel;
              return Row(
                children: [
                  if (candidatActuel != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.or.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.or),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            candidatActuel.nom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Score: ${candidatActuel.score}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPronouncerCard() {
    return Card(
      elevation: 8,
      color: AppColors.bleuMarine.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.or.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FICHE PRONONCEUR',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Consumer<CompetitionService>(
                  builder: (context, competition, child) {
                    if (competition.motActuel == null) {
                      return Container();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple),
                      ),
                      child: Text(
                        'Niveau ${competition.motActuel!.niveauDifficulte}/5',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mot actuel
            Consumer<CompetitionService>(
              builder: (context, competition, child) {
                final mot = competition.motActuel?.mot ?? 'AUCUN MOT';
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.or),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'MOT À ÉPELLER',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mot.toUpperCase(),
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.or,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          fontFamily: 'Georgia',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Informations du mot
            Consumer<CompetitionService>(
              builder: (context, competition, child) {
                final mot = competition.motActuel;
                if (mot == null) {
                  return const Center(
                    child: Text(
                      'Aucun mot sélectionné',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Définition
                    _buildInfoSection(
                      icon: Icons.info_outline,
                      title: 'DÉFINITION',
                      content: mot.definition,
                    ),
                    const SizedBox(height: 16),

                    // Exemple
                    _buildInfoSection(
                      icon: Icons.format_quote,
                      title: 'EXEMPLE',
                      content: mot.exemple,
                      isItalic: true,
                    ),
                    const SizedBox(height: 16),

                    // Métadonnées
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildMetadataChip(
                          label: mot.categorie,
                          color: Colors.blue,
                        ),
                        _buildMetadataChip(
                          label: mot.natureGrammaticale,
                          color: Colors.purple,
                        ),
                        if (mot.etymologie.isNotEmpty)
                          _buildMetadataChip(
                            label: mot.etymologie,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    bool isItalic = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content.isNotEmpty ? content : 'Non disponible',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 8,
      color: AppColors.bleuMarine.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.or.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SAISIE D\'ÉPELLATION',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Champ de saisie amélioré
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Courier New',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tapez les lettres dictées...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 1,
                    onChanged: (value) {
                      _handleTextInput(value);
                    },
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 16),

                  // Boutons de contrôle de saisie
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _competition.supprimerLettre(),
                          icon: const Icon(Icons.backspace, size: 20),
                          label: const Text('RETOUR'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _competition.ajouterLettre(' '),
                          icon: const Icon(Icons.space_bar, size: 20),
                          label: const Text('ESPACE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _competition.effacerEpellation(),
                          icon: const Icon(Icons.clear_all, size: 20),
                          label: const Text('EFFACER'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Aperçu visuel
            Consumer<CompetitionService>(
              builder: (context, competition, child) {
                final saisie = competition.epellationSaisie;
                final motOfficiel =
                    competition.motActuel?.orthographeOfficielle ?? '';

                if (saisie.isEmpty) {
                  return Center(
                    child: Text(
                      'En attente de saisie...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APERÇU:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: saisie.split('').asMap().entries.map((entry) {
                          final index = entry.key;
                          final lettre = entry.value;
                          final estCorrecte =
                              index < motOfficiel.length &&
                              lettre.toUpperCase() ==
                                  motOfficiel[index].toUpperCase();

                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: estCorrecte
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: estCorrecte ? Colors.green : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                lettre == ' ' ? '␣' : lettre,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Indicateur de progression
                    LinearProgressIndicator(
                      value: motOfficiel.isNotEmpty
                          ? saisie.length / motOfficiel.length
                          : 0,
                      backgroundColor: Colors.white24,
                      color: AppColors.or,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progression:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '${saisie.length}/${motOfficiel.length}',
                          style: TextStyle(
                            color: AppColors.or,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleTextInput(String value) {
    final uppercaseValue = value.toUpperCase();
    final currentSaisie = _competition.epellationSaisie.toUpperCase();

    // Ignorer si identique
    if (uppercaseValue == currentSaisie) return;

    // Si nouvel input est plus long
    if (uppercaseValue.length > currentSaisie.length) {
      final nouvellesLettres = uppercaseValue.substring(currentSaisie.length);
      for (final lettre in nouvellesLettres.split('')) {
        if (lettre.isNotEmpty) {
          _competition.ajouterLettre(lettre);
        }
      }
    }
    // Si nouvel input est plus court (retour arrière)
    else if (uppercaseValue.length < currentSaisie.length) {
      // Vérifier si c'est une suppression à la fin (mot commençant pareil)
      if (currentSaisie.startsWith(uppercaseValue)) {
        final difference = currentSaisie.length - uppercaseValue.length;
        for (int i = 0; i < difference; i++) {
          _competition.supprimerLettre();
        }
      } else {
        // Suppression au milieu -> tout effacer et réécrire
        _competition.effacerEpellation();
        for (final lettre in uppercaseValue.split('')) {
          if (lettre.isNotEmpty) {
            _competition.ajouterLettre(lettre);
          }
        }
      }
    }
    // Même longueur mais contenu différent (collage)
    else {
      _competition.effacerEpellation();
      for (final lettre in uppercaseValue.split('')) {
        if (lettre.isNotEmpty) {
          _competition.ajouterLettre(lettre);
        }
      }
    }
  }

  Widget _buildControlButtons() {
    return Card(
      elevation: 8,
      color: AppColors.bleuMarine.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.or.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'CONTRÔLES DU JEU',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),

            // Première ligne de boutons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _competition.tirerMotAleatoire,
                    icon: const Icon(Icons.skip_next, size: 24),
                    label: const Text('MOT SUIVANT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bleuMarineClair,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _competition.revelerMot();
                      _competition.mettreEnPauseChrono();
                    },
                    icon: const Icon(Icons.visibility, size: 24),
                    label: const Text('RÉVÉLER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _competition.reinitialiserChrono();
                      _competition.demarrerChrono();
                    },
                    icon: const Icon(Icons.restart_alt, size: 24),
                    label: const Text('CHRONO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Deuxième ligne de boutons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _competition.marquerCorrect();
                      _competition.tirerMotAleatoire();
                    },
                    icon: const Icon(Icons.check_circle, size: 24),
                    label: const Text('CORRECT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _competition.marquerIncorrect();
                      _competition.tirerMotAleatoire();
                    },
                    icon: const Icon(Icons.cancel, size: 24),
                    label: const Text('INCORRECT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidatesPanel() {
    return Card(
      elevation: 8,
      color: AppColors.bleuMarine.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.or.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CANDIDATS',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Consumer<CompetitionService>(
                  builder: (context, competition, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bleuMarineFonce,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${competition.candidats.length} participants',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),

            // Liste des candidats
            Expanded(
              child: Consumer<CompetitionService>(
                builder: (context, competition, child) {
                  if (competition.candidats.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun candidat',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: competition.candidats.length,
                    itemBuilder: (context, index) {
                      final candidat = competition.candidats[index];
                      final estActif =
                          competition.candidatActuel?.id == candidat.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () =>
                              competition.selectionnerCandidat(candidat.id),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: estActif
                                  ? AppColors.or.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: estActif
                                    ? AppColors.or
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Numéro
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: estActif
                                        ? AppColors.or
                                        : AppColors.bleuMarineClair,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: estActif
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Nom et score
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        candidat.nom,
                                        style: TextStyle(
                                          color: estActif
                                              ? AppColors.or
                                              : Colors.white,
                                          fontWeight: estActif
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Score: ${candidat.score}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Indicateur actif
                                if (estActif)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.or,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bleuMarine,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.or, width: 2),
        ),
        title: const Text(
          'Retour à la configuration',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Voulez-vous retourner à l\'écran de configuration ?\n'
          'La partie en cours ne sera pas sauvegardée.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onReinitialiser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Retour configuration',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

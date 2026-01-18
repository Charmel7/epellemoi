import 'package:epellemoi/core/models/phase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/competition_service.dart';

class ControlScreen extends StatefulWidget {
  final VoidCallback onReinitialiser;

  const ControlScreen({super.key, required this.onReinitialiser});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final TextEditingController _saisieController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Synchroniser le contrôleur avec l'état initial
    _saisieController.text = context
        .read<CompetitionService>()
        .epellationSaisie;

    // Écouter les changements du service
    context.read<CompetitionService>().addListener(
      _updateControllerFromService,
    );
  }

  void _updateControllerFromService() {
    final service = context.read<CompetitionService>();
    if (_saisieController.text != service.epellationSaisie) {
      _saisieController.text = service.epellationSaisie;
    }
  }

  @override
  void dispose() {
    context.read<CompetitionService>().removeListener(
      _updateControllerFromService,
    );
    _saisieController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final competition = Provider.of<CompetitionService>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Barre supérieure avec bouton de retour
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Retour à la configuration'),
                        content: Text(
                          'Voulez-vous retourner à l\'écran de configuration ? '
                          'La partie en cours ne sera pas sauvegardée.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.onReinitialiser();
                            },
                            child: Text(
                              'Retour',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Text(
                  'CONSOLE DE RÉGIE',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Indicateur de phase
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.or.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.or),
                  ),
                  child: Text(
                    competition.phaseActuelle.nom,
                    style: TextStyle(
                      color: AppColors.or,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Fiche Prononceur
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'FICHE PRONONCEUR',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (competition.motActuel != null)
                                  Text(
                                    'Niveau: ${competition.motActuel!.niveauDifficulte}/5',
                                    style: TextStyle(color: AppColors.or),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Mot actuel
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.or),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'MOT ACTUEL',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    competition.motActuel?.mot.toUpperCase() ??
                                        'AUCUN MOT',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: AppColors.or,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Définition et exemple
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info,
                                              size: 16,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'DÉFINITION',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          competition.motActuel?.definition ??
                                              'Aucune définition disponible',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.format_quote,
                                              size: 16,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'EXEMPLE',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          competition.motActuel?.exemple ??
                                              'Aucun exemple disponible',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Informations supplémentaires
                            if (competition.motActuel != null)
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  Chip(
                                    label: Text(
                                      competition.motActuel!.categorie,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      competition.motActuel!.natureGrammaticale,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.purple.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  if (competition
                                      .motActuel!
                                      .etymologie
                                      .isNotEmpty)
                                    Chip(
                                      label: Text(
                                        competition.motActuel!.etymologie,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Saisie d'épellation
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAISIE EN DIRECT',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Champ de saisie
                            TextField(
                              controller: _saisieController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText:
                                    'Tapez les lettres dictées... (Appuyez sur ESPACE pour séparer)',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white10,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.backspace,
                                        color: Colors.white,
                                      ),
                                      tooltip: 'Effacer dernière lettre',
                                      onPressed: () {
                                        competition.supprimerLettre();
                                        _saisieController.text =
                                            competition.epellationSaisie;
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear_all,
                                        color: Colors.white,
                                      ),
                                      tooltip: 'Effacer tout',
                                      onPressed: () {
                                        competition.effacerEpellation();
                                        _saisieController.clear();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.space_bar,
                                        color: Colors.white,
                                      ),
                                      tooltip: 'Ajouter un espace',
                                      onPressed: () {
                                        competition.ajouterLettre(' ');
                                        _saisieController.text =
                                            competition.epellationSaisie;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                              onChanged: (value) {
                                // Synchroniser avec le service
                                final nouvelleSaisie = value.toUpperCase();

                                // Si la différence est d'une lettre, l'ajouter
                                if (nouvelleSaisie.length >
                                    competition.epellationSaisie.length) {
                                  final nouvelleLettre = nouvelleSaisie
                                      .substring(nouvelleSaisie.length - 1);
                                  competition.ajouterLettre(nouvelleLettre);
                                }
                                // Si la différence est une suppression
                                else if (nouvelleSaisie.length <
                                    competition.epellationSaisie.length) {
                                  competition.supprimerLettre();
                                }
                              },
                              onSubmitted: (value) {
                                // Réinitialiser le champ mais garder l'épellation
                                _saisieController.clear();
                              },
                            ),

                            const SizedBox(height: 10),

                            // Aperçu des lettres
                            if (competition.epellationSaisie.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: competition.epellationSaisie
                                      .split('')
                                      .map((lettre) {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.bleuMarineClair,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            lettre == ' ' ? '␣' : lettre,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                              ),

                            const SizedBox(height: 10),

                            // Indicateur de progression
                            if (competition.motActuel != null)
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value:
                                          competition.epellationSaisie.length /
                                          competition
                                              .motActuel!
                                              .orthographeOfficielle
                                              .length,
                                      backgroundColor: Colors.white24,
                                      color: AppColors.or,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${competition.epellationSaisie.length}/${competition.motActuel!.orthographeOfficielle.length}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Boutons de contrôle
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: competition.tirerMotAleatoire,
                                  icon: Icon(Icons.skip_next),
                                  label: Text('MOT SUIVANT'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.or,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    competition.revelerMot();
                                    competition.mettreEnPauseChrono();
                                  },
                                  icon: Icon(Icons.visibility),
                                  label: Text('RÉVÉLER'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    competition.reinitialiserChrono();
                                    competition.demarrerChrono();
                                  },
                                  icon: Icon(Icons.restart_alt),
                                  label: Text('REDÉMARRER CHRONO'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    competition.marquerCorrect();
                                    competition.tirerMotAleatoire();
                                    _saisieController.clear();
                                  },
                                  icon: Icon(Icons.check),
                                  label: Text('CORRECT + SUIVANT'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    competition.marquerIncorrect();
                                    competition.tirerMotAleatoire();
                                    _saisieController.clear();
                                  },
                                  icon: Icon(Icons.close),
                                  label: Text('INCORRECT + SUIVANT'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Liste des candidats
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CANDIDATS (${competition.candidats.length})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cliquez pour sélectionner',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: competition.candidats.length,
                      itemBuilder: (context, index) {
                        final candidat = competition.candidats[index];
                        final estActif =
                            competition.candidatActuel?.id == candidat.id;

                        return GestureDetector(
                          onTap: () {
                            competition.selectionnerCandidat(candidat.id);
                          },
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: estActif
                                  ? AppColors.or.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: estActif ? AppColors.or : Colors.white24,
                                width: estActif ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Score: ${candidat.score}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

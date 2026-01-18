import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/models/candidate.dart';
import '../../../core/models/phase.dart';
import '../../../core/services/competition_service.dart';

// Dans config_screen.dart
class ConfigScreen extends StatefulWidget {
  final VoidCallback onConfigurationComplete;

  const ConfigScreen({super.key, required this.onConfigurationComplete});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _candidatController = TextEditingController();
  final TextEditingController _cheminController = TextEditingController();
  Phase _selectedPhase = Phase.qualifications;
  String? _nomFichierCharge;
  int? _nombreMotsCharges;
  bool _chargementEnCours = false;
  String _cheminFichier = '';
  String _statutChargement = 'Prêt';

  @override
  void initState() {
    super.initState();
    _initialiserCheminParDefaut();
  }

  Future<void> _initialiserCheminParDefaut() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final cheminParDefaut = '${documentsDir.path}/mots.csv';

    setState(() {
      _cheminFichier = cheminParDefaut;
      _cheminController.text = cheminParDefaut;
    });
  }

  @override
  Widget build(BuildContext context) {
    final competition = Provider.of<CompetitionService>(context);

    bool configurationEstPrete() {
      return competition.mots.isNotEmpty && competition.candidats.isNotEmpty;
    }

    return Scaffold(
      backgroundColor: Color(0xFF001529),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFD4AF37), width: 2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.spellcheck, color: Color(0xFFD4AF37), size: 40),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ÉPELLE-MOI',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Console de Régie - Mode Développement',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Indicateurs de statut
            Row(
              children: [
                _buildStatusIndicator(
                  label: 'MOTS',
                  isReady: competition.mots.isNotEmpty,
                  count: competition.mots.length,
                ),
                const SizedBox(width: 15),
                _buildStatusIndicator(
                  label: 'CANDIDATS',
                  isReady: competition.candidats.isNotEmpty,
                  count: competition.candidats.length,
                ),
                const SizedBox(width: 15),
                _buildStatusIndicator(
                  label: 'PHASE',
                  isReady: true,
                  text: _selectedPhase.nom,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Section CSV - CHARGEMENT DE FICHIER
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.file_upload,
                                  color: Color(0xFFD4AF37),
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'CHARGEMENT DU FICHIER CSV',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Instructions
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF0A1A2F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Instructions :',
                                    style: TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '1. Placez votre fichier CSV dans un dossier accessible',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '2. Cliquez sur "Parcourir..." pour le sélectionner',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '3. Cliquez sur "CHARGER LE FICHIER"',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Champ du chemin
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chemin du fichier CSV :',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _cheminController,
                                          decoration: InputDecoration(
                                            hintText: 'C:/Users/.../mots.csv',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white10,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 14,
                                                ),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await _selectionnerFichier();
                                        },
                                        icon: Icon(Icons.folder_open, size: 18),
                                        label: Text('Parcourir...'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF1A365D),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Boutons d'action
                            if (_chargementEnCours)
                              Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFD4AF37),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Chargement en cours...',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            if (_cheminController.text
                                                .trim()
                                                .isNotEmpty) {
                                              await _chargerFichierCsv(
                                                context,
                                                competition,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Veuillez sélectionner un fichier',
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.upload_file,
                                            size: 22,
                                          ),
                                          label: Text('CHARGER LE FICHIER CSV'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFD4AF37),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _creerExempleCSV();
                                          },
                                          icon: Icon(
                                            Icons.lightbulb_outline,
                                            size: 18,
                                          ),
                                          label: Text(
                                            'CRÉER UN FICHIER D\'EXEMPLE',
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.blue,
                                            side: BorderSide(
                                              color: Colors.blue,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            // Statut du chargement
                            if (_nomFichierCharge != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fichier chargé avec succès',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '$_nomFichierCharge',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (_statutChargement != 'Prêt')
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.orange,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _statutChargement,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section Candidats
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Color(0xFFD4AF37),
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'GESTION DES CANDIDATS',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Champ d'ajout de candidat
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _candidatController,
                                    decoration: InputDecoration(
                                      hintText: 'Nom du candidat',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white10,
                                      prefixIcon: Icon(
                                        Icons.person_add,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    onSubmitted: (value) {
                                      _ajouterCandidat(value, competition);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _ajouterCandidat(
                                      _candidatController.text,
                                      competition,
                                    );
                                  },
                                  child: Text('AJOUTER'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD4AF37),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Liste des candidats
                            if (competition.candidats.isNotEmpty)
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                  itemCount: competition.candidats.length,
                                  itemBuilder: (context, index) {
                                    final candidat =
                                        competition.candidats[index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Color(0xFFD4AF37),
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          candidat.nom,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white70,
                                          ),
                                          onPressed: () {
                                            _supprimerCandidat(
                                              candidat,
                                              competition,
                                              context,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white24,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Colors.white54,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Aucun candidat ajouté',
                                        style: TextStyle(color: Colors.white54),
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

                    // Section Phase
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: Color(0xFFD4AF37),
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'PHASE DU CONCOURS',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: DropdownButton<Phase>(
                                value: _selectedPhase,
                                dropdownColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                underline: SizedBox(),
                                isExpanded: true,
                                onChanged: (Phase? nouvellePhase) {
                                  if (nouvellePhase != null) {
                                    setState(() {
                                      _selectedPhase = nouvellePhase;
                                    });
                                    competition.changerPhase(nouvellePhase);
                                  }
                                },
                                items: Phase.values.map((Phase phase) {
                                  return DropdownMenuItem<Phase>(
                                    value: phase,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(phase.nom),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF0A1A2F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getPhaseDescription(_selectedPhase),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Barre inférieure
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUT DE LA CONFIGURATION',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          configurationEstPrete()
                              ? '✅ PRÊT À DÉMARRER'
                              : '⏳ CONFIGURATION INCOMPLÈTE',
                          style: TextStyle(
                            color: configurationEstPrete()
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dans config_screen.dart - À LA LIGNE 541
                  ElevatedButton.icon(
                    onPressed: configurationEstPrete()
                        ? () {
                            // CORRECTION: Ajouter cette logique
                            print('=== DÉBUT CONFIGURATION ===');
                            print('Nombre de mots: ${competition.mots.length}');
                            print(
                              'Nombre de candidats: ${competition.candidats.length}',
                            );

                            if (competition.candidats.isNotEmpty &&
                                competition.candidatActuel == null) {
                              competition.selectionnerCandidat(
                                competition.candidats.first.id,
                              );
                            }

                            competition.tirerMotAleatoire();

                            print('Mot actuel: ${competition.motActuel?.mot}');
                            print(
                              'Candidat actuel: ${competition.candidatActuel?.nom}',
                            );

                            // Afficher un message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Configuration terminée ! Passage au mode contrôle...',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // CORRECTION CRITIQUE: Ajouter cet appel
                            widget.onConfigurationComplete();

                            print('=== FIN CONFIGURATION ===');
                          }
                        : null,
                    icon: Icon(Icons.play_arrow),
                    label: Text('TERMINER LA CONFIGURATION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: configurationEstPrete()
                          ? Colors.green
                          : Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
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

  Widget _buildStatusIndicator({
    required String label,
    required bool isReady,
    int? count,
    String? text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isReady
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isReady ? Colors.green : Colors.orange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isReady ? Icons.check_circle : Icons.error,
            size: 16,
            color: isReady ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              '($count)',
              style: TextStyle(
                color: isReady ? Colors.green : Colors.orange,
                fontSize: 12,
              ),
            ),
          ],
          if (text != null) ...[
            const SizedBox(width: 4),
            Text(
              ': $text',
              style: TextStyle(
                color: isReady ? Colors.green : Colors.orange,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectionnerFichier() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        dialogTitle: 'Sélectionnez le fichier CSV',
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _cheminController.text = file.path ?? '';
          _statutChargement = 'Fichier sélectionné: ${file.name}';
        });
      }
    } catch (e) {
      setState(() {
        _statutChargement = 'Erreur lors de la sélection: $e';
      });
    }
  }

  Future<void> _chargerFichierCsv(
    BuildContext context,
    CompetitionService competition,
  ) async {
    try {
      setState(() {
        _chargementEnCours = true;
        _statutChargement = 'Chargement en cours...';
      });

      final chemin = _cheminController.text.trim();
      if (chemin.isEmpty) {
        throw Exception('Veuillez sélectionner un fichier');
      }

      final file = File(chemin);
      if (!await file.exists()) {
        throw Exception('Le fichier n\'existe pas: $chemin');
      }

      final csvContent = await file.readAsString();
      await competition.initialiserAvecCsv(csvContent);

      setState(() {
        _nomFichierCharge =
            '${file.path.split('/').last} (${competition.mots.length} mots)';
        _nombreMotsCharges = competition.mots.length;
        _chargementEnCours = false;
        _statutChargement = 'Chargement réussi';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${competition.mots.length} mots chargés avec succès',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _chargementEnCours = false;
        _statutChargement = 'Erreur: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: $e', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _creerExempleCSV() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final fichier = File('${documentsDir.path}/mots_exemple.csv');

      final exempleCsv =
          '''"Mot","Orthographe Officielle","Définition(s)","Exemple de Phrase","Nature Grammaticale","Étymologie","Catégorie","Niveau de Difficulté","Statut"
"aboulie","aboulie","Manque pathologique de volonté","La dépression s'accompagne parfois d'une aboulie paralysante.","Nom (F)","Grec aboulia","SCI (Scientifique)","4","✓"
"acédie","acédie","Paresse spirituelle","L'acédie monastique était considérée comme un péché capital.","Nom (F)","Grec akêdeia","CG (Culture Générale)","5","✓"
"afférent","afférent","Qui conduit vers un centre (en physiologie)","Les nerfs afférents transmettent les informations sensorielles.","Adjectif","Latin afferre","SCI (Scientifique)","4","✓"
"agnation","agnation","Lien de parenté par les hommes seulement","L'agnation déterminait la succession dans le droit romain.","Nom (F)","Latin agnatio","CG (Culture Générale)","5","✓"
"alacrité","alacrité","Entrain prompt et joyeux","Il accepta l'invitation avec alacrité.","Nom (F)","Latin alacritas","LIT (Littéraire)","4","✓"
"anacoluthe","anacoluthe","Rupture dans la construction syntaxique d'une phrase","Cette anacoluthe rend le texte difficile à suivre.","Nom (F)","Grec anakolouthos","LIT (Littéraire)","5","✓"
"anaphrodisiaque","anaphrodisiaque","Qui diminue le désir sexuel","Certains médicaments ont un effet anaphrodisiaque indésirable.","Adjectif","Grec anaphrodisiakos","SCI (Scientifique)","5","✓"
"apocope","apocope","Chute d'un ou plusieurs phonèmes à la fin d'un mot","Ciné est une apocope de cinématographe","Nom (F)","Grec apokopê","LIT (Littéraire)","5","✓"
"apodictique","apodictique","Dont la vérité est absolument démontrable","Son raisonnement apodictique ne laissait place à aucun doute.","Adjectif","Grec apodeiktikos","CG (Culture Générale)","5","✓"
"ataraxie","ataraxie","État de quiétude absolue, absence de troubles","Le sage stoïcien recherche l'ataraxie.","Nom (F)","Grec ataraxia","CG (Culture Générale)","4","✓"''';

      await fichier.writeAsString(exempleCsv);

      setState(() {
        _cheminController.text = fichier.path;
        _statutChargement = 'Fichier d\'exemple créé: ${fichier.path}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Fichier d\'exemple créé: ${fichier.path}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      setState(() {
        _statutChargement = 'Erreur création exemple: $e';
      });
    }
  }

  void _ajouterCandidat(String nom, CompetitionService competition) {
    final nomTrim = nom.trim();
    if (nomTrim.isNotEmpty) {
      competition.ajouterCandidat(nomTrim);
      _candidatController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Candidat ajouté: $nomTrim'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _supprimerCandidat(
    Candidate candidat,
    CompetitionService competition,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le candidat'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${candidat.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              competition.supprimerCandidat(candidat.id);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ Candidat supprimé: ${candidat.nom}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getPhaseDescription(Phase phase) {
    switch (phase) {
      case Phase.qualifications:
        return 'Première phase du concours. Tous les candidats participent.';
      case Phase.eliminatories:
        return 'Phase éliminatoire. Seuls les meilleurs candidats continuent.';
      case Phase.demiFinale:
        return 'Avant-dernière phase. Les finalistes sont déterminés.';
      case Phase.finale:
        return 'Phase ultime. Le champion est désigné.';
    }
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/models/candidate.dart';
import '../../../core/models/phase.dart';
import '../../../core/services/competition_service.dart';
import '../../widgets/header/competition_title.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header fixe
          Container(
            margin: const EdgeInsets.only(bottom: 50, left: 30, top: 10),
            //padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CompetitionTitle(
                  isDarkMode: true,
                  showSubtitle: false,
                  compact: true,
                ),
                const SizedBox(height: 5),
                Text(
                  'CONFIGURATION DU CONCOURS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal avec ScrollView vertical
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicateurs de statut
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatutIndicator(
                            label: 'MOTS',
                            isReady: competition.mots.isNotEmpty,
                            count: competition.mots.length,
                          ),
                          _buildStatutIndicator(
                            label: 'CANDIDATS',
                            isReady: competition.candidats.isNotEmpty,
                            count: competition.candidats.length,
                          ),
                          _buildStatutIndicator(
                            label: 'PHASE',
                            isReady: true,
                            text: _selectedPhase.nom,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Section CSV avec son propre ScrollView si nécessaire
                    _buildSection(
                      title: 'CHARGEMENT DES MOTS',
                      icon: Icons.description,
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fichier CSV',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[50],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _cheminController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'chemin/vers/fichier.csv',
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _selectionnerFichier();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: const Text('PARCOURIR'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    if (_statutChargement != 'Prêt')
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              _statutChargement.contains(
                                                'Erreur',
                                              )
                                              ? Colors.red[50]
                                              : Colors.green[50],
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              _statutChargement.contains(
                                                    'Erreur',
                                                  )
                                                  ? Icons.error
                                                  : Icons.info,
                                              size: 16,
                                              color:
                                                  _statutChargement.contains(
                                                    'Erreur',
                                                  )
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _statutChargement,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      _statutChargement
                                                          .contains('Erreur')
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _chargementEnCours
                                          ? null
                                          : () async {
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
                                                    content: const Text(
                                                      'Veuillez sélectionner un fichier',
                                                    ),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: _chargementEnCours
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'CHARGER LE FICHIER CSV',
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () {
                                      _creerExempleCSV();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                        color: Colors.grey[400]!,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('EXEMPLE'),
                                  ),
                                ],
                              ),
                              if (_nomFichierCharge != null) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.green[100]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                        size: 20,
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
                                                fontSize: 14,
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              _nomFichierCharge!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Section Candidats avec ScrollView
                    _buildSection(
                      title: 'GESTION DES CANDIDATS',
                      icon: Icons.people,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _candidatController,
                                    decoration: InputDecoration(
                                      hintText: 'Nom du candidat',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    onSubmitted: (value) {
                                      _ajouterCandidat(value, competition);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    _ajouterCandidat(
                                      _candidatController.text,
                                      competition,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text('AJOUTER'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Liste des candidats',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 200,
                              minHeight: 100,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: competition.candidats.isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: competition.candidats.length,
                                      itemBuilder: (context, index) {
                                        final candidat =
                                            competition.candidats[index];
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              candidat.nom,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.grey[500],
                                                size: 20,
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
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.people_outline,
                                            size: 48,
                                            color: Colors.grey[300],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Aucun candidat ajouté',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ajoutez des candidats avec le champ ci-dessus',
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Section Phase
                    _buildSection(
                      title: 'PHASE DU CONCOURS',
                      icon: Icons.flag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: DropdownButton<Phase>(
                              value: _selectedPhase,
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              underline: const SizedBox(),
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
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(phase.nom),
                                  ),
                                );
                              }).toList(),

                              alignment: Alignment.topCenter,
                            ),
                          ),

                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              _getPhaseDescription(_selectedPhase),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Barre inférieure fixe
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUT DE LA CONFIGURATION',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        configurationEstPrete()
                            ? '✅ PRÊT À DÉMARRER'
                            : '⏳ CONFIGURATION INCOMPLÈTE',
                        style: TextStyle(
                          color: configurationEstPrete()
                              ? Colors.green[700]
                              : Colors.amber[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: configurationEstPrete()
                      ? () {
                          if (competition.candidats.isNotEmpty &&
                              competition.candidatActuel == null) {
                            competition.selectionnerCandidat(
                              competition.candidats.first.id,
                            );
                          }

                          competition.tirerMotAleatoire();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Configuration terminée ! Passage au mode contrôle...',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          widget.onConfigurationComplete();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: configurationEstPrete()
                        ? Colors.black
                        : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'DÉMARRER LE CONCOURS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatutIndicator({
    required String label,
    required bool isReady,
    int? count,
    String? text,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady ? Colors.black : Colors.grey[200],
            border: Border.all(
              color: isReady ? Colors.black : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              count?.toString() ?? text?.substring(0, 1) ?? '?',
              style: TextStyle(
                fontSize: 20,
                color: isReady ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        if (text != null && count == null) ...[
          const SizedBox(height: 4),
          Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ],
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
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _chargementEnCours = false;
        _statutChargement = 'Erreur: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Erreur: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 5),
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
"afférent","afférent","Qui conduit vers un centre (en physiologie)","Les nerfs afférents transmettent les informations sensorielles.","Adjectif","Latin afferre","SCI (Scientifique)","4","✓"''';

      await fichier.writeAsString(exempleCsv);

      setState(() {
        _cheminController.text = fichier.path;
        _statutChargement = 'Fichier d\'exemple créé: ${fichier.path}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Fichier d\'exemple créé: ${fichier.path}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 4),
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
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
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
        title: const Text('Supprimer le candidat'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${candidat.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              competition.supprimerCandidat(candidat.id);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ Candidat supprimé: ${candidat.nom}'),
                  backgroundColor: Colors.black,
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
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

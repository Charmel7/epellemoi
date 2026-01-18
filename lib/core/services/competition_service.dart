import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/candidate.dart';
import '../models/phase.dart';
import '../models/word.dart';
import 'csv_service.dart';

class CompetitionService extends ChangeNotifier {
  Phase _phaseActuelle = Phase.qualifications;
  List<Candidate> _candidats = [];
  List<Word> _mots = [];
  Candidate? _candidatActuel;
  Word? _motActuel;
  String _epellationSaisie = '';
  bool _motRevele = false;
  int _chronoRestant = 60;
  Timer? _chronoTimer;

  // Getters
  Phase get phaseActuelle => _phaseActuelle;
  List<Candidate> get candidats => _candidats;
  List<Word> get mots => _mots;
  Candidate? get candidatActuel => _candidatActuel;
  Word? get motActuel => _motActuel;
  String get epellationSaisie => _epellationSaisie;
  bool get motRevele => _motRevele;
  int get chronoRestant => _chronoRestant;

  // Initialisation
  Future<void> initialiserAvecCsv(String csvContent) async {
    final csvService = CsvService();
    _mots = await csvService.loadWordsFromCsv(csvContent);
    notifyListeners();
  }

  // Gestion des candidats
  void ajouterCandidat(String nom) {
    _candidats.add(Candidate(nom: nom));
    notifyListeners();
  }

  void supprimerCandidat(String id) {
    _candidats.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void selectionnerCandidat(String id) {
    try {
      _candidatActuel = _candidats.firstWhere((c) => c.id == id);
    } catch (e) {
      // Si le candidat n'existe pas, sélectionner le premier
      if (_candidats.isNotEmpty) {
        _candidatActuel = _candidats.first;
      } else {
        _candidatActuel = null;
      }
    }
    notifyListeners();
  }

  // Gestion des mots
  // Dans competition_service.dart - modifier tirerMotAleatoire
  void tirerMotAleatoire() {
    // Arrêter le timer existant
    _chronoTimer?.cancel();

    if (_mots.isEmpty) return;

    final motsNonUtilises = _mots.where((m) => !m.estUtilise).toList();
    if (motsNonUtilises.isEmpty) {
      for (var mot in _mots) {
        mot.estUtilise = false;
      }
    }

    final motsDisponibles = motsNonUtilises.isNotEmpty
        ? motsNonUtilises
        : _mots;
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % motsDisponibles.length;

    _motActuel = motsDisponibles[randomIndex];
    _motActuel?.estUtilise = true;
    _epellationSaisie = '';
    _motRevele = false;
    _chronoRestant = 60;

    notifyListeners();
    demarrerChrono();
  }

  // Saisie d'épellation
  void ajouterLettre(String lettre) {
    if (lettre.length == 1 && lettre.isNotEmpty) {
      _epellationSaisie += lettre.toUpperCase();
      notifyListeners();
    }
  }

  void supprimerLettre() {
    if (_epellationSaisie.isNotEmpty) {
      _epellationSaisie = _epellationSaisie.substring(
        0,
        _epellationSaisie.length - 1,
      );
      notifyListeners();
    }
  }

  void effacerEpellation() {
    _epellationSaisie = '';
    notifyListeners();
  }

  // Révélation
  void revelerMot() {
    _motRevele = true;
    notifyListeners();
  }

  // Verdict
  void marquerCorrect() {
    if (_candidatActuel != null) {
      _candidatActuel!.score++;
      notifyListeners();
    }
  }

  void marquerIncorrect() {
    if (_candidatActuel != null) {
      // Logique supplémentaire si nécessaire
      notifyListeners();
    }
  }

  // Chronomètre
  void demarrerChrono() {
    _chronoTimer?.cancel();
    _chronoRestant = 60;

    _chronoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_chronoRestant > 0) {
        _chronoRestant--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void reinitialiserChrono() {
    _chronoTimer?.cancel();
    _chronoRestant = 60;
    notifyListeners();
  }

  void mettreEnPauseChrono() {
    _chronoTimer?.cancel();
    notifyListeners();
  }

  Future<bool> chargerMotsDepuisFichier() async {
    try {
      final csvService = CsvService();
      final motsCharges = await csvService.loadWordsFromFile();

      _mots = motsCharges;
      notifyListeners();

      return motsCharges.isNotEmpty;
    } catch (e) {
      print('Erreur lors du chargement du fichier: $e');
      rethrow;
    }
  }

  // Phase
  void changerPhase(Phase nouvellePhase) {
    _phaseActuelle = nouvellePhase;
    notifyListeners();
  }

  // Nettoyage
  @override
  void dispose() {
    _chronoTimer?.cancel();
    super.dispose();
  }
}

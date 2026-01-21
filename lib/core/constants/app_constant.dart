// app_constants.dart (extended)
class AppConstants {
  // Dimensions écrans
  static const double ecranLargeurAdmin = 960; // Écran admin
  static const double ecranLargeurProj = 1920; // Écran projection
  static const double ecranHauteur = 1080; // Hauteur commune

  // Marges et espacements
  static const double margeLarge = 32.0;
  static const double margeMoyenne = 24.0;
  static const double margePetite = 16.0;
  static const double margeMinute = 8.0;

  // Bordures et coins arrondis
  static const double rayonGrand = 24.0;
  static const double rayonMoyen = 16.0;
  static const double rayonPetit = 8.0;
  static const double epaisseurBordure = 2.0;

  // Timer
  static const int dureeParMot = 60; // secondes
  static const int seuilVert = 40; // secondes pour vert
  static const int seuilOrange = 20; // secondes pour orange
  static const int seuilRouge = 10; // secondes pour rouge

  // Animations
  static const Duration animationRapide = Duration(milliseconds: 200);
  static const Duration animationMoyenne = Duration(milliseconds: 500);
  static const Duration animationLente = Duration(milliseconds: 1000);

  // Dimensions lettres épellation
  static const double hauteurLettre = 120.0;
  static const double largeurLettre = 90.0;
  static const double espacementLettres = 16.0;
  // Informations sur la competition
  static const String nomCompetition = ' ÉPELLE-MOI';
  static const String edition = 'ÉDITION 2026';
}

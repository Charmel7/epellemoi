class Word {
  final String mot;
  final String orthographeOfficielle;
  final String definition;
  final String exemple;
  final String natureGrammaticale;
  final String etymologie;
  final String categorie;
  final int niveauDifficulte;
  final bool estValide;
  bool estUtilise;

  Word({
    required this.mot,
    required this.orthographeOfficielle,
    required this.definition,
    required this.exemple,
    required this.natureGrammaticale,
    required this.etymologie,
    required this.categorie,
    required this.niveauDifficulte,
    required this.estValide,
    this.estUtilise = false,
  });

  factory Word.fromCsv(Map<String, dynamic> csvRow) {
    return Word(
      mot: csvRow['Mot']?.toString().trim() ?? '',
      orthographeOfficielle:
          csvRow['Orthographe Officielle']?.toString().trim() ?? '',
      definition: csvRow['Définition(s)']?.toString().trim() ?? '',
      exemple: csvRow['Exemple de Phrase']?.toString().trim() ?? '',
      natureGrammaticale:
          csvRow['Nature Grammaticale']?.toString().trim() ?? '',
      etymologie: csvRow['Étymologie']?.toString().trim() ?? '',
      categorie: csvRow['Catégorie']?.toString().trim() ?? '',
      niveauDifficulte:
          int.tryParse(csvRow['Niveau de Difficulté']?.toString() ?? '3') ?? 3,
      estValide: (csvRow['Statut']?.toString() ?? '') == '✓',
      estUtilise: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Mot': mot,
      'Orthographe Officielle': orthographeOfficielle,
      'Définition(s)': definition,
      'Exemple de Phrase': exemple,
      'Nature Grammaticale': natureGrammaticale,
      'Étymologie': etymologie,
      'Catégorie': categorie,
      'Niveau de Difficulté': niveauDifficulte.toString(),
      'Statut': estValide ? '✓' : '',
      'Utilisé': estUtilise ? 'Oui' : 'Non',
    };
  }
}

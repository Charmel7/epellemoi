import 'package:uuid/uuid.dart';

class Candidate {
  final String id;
  final String nom;
  int score;
  bool estQualifie;
  int tempsRestant;

  Candidate({
    String? id,
    required this.nom,
    this.score = 0,
    this.estQualifie = false,
    this.tempsRestant = 60,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'score': score,
      'estQualifie': estQualifie,
      'tempsRestant': tempsRestant,
    };
  }

  factory Candidate.fromMap(Map<String, dynamic> map) {
    return Candidate(
      id: map['id'],
      nom: map['nom'],
      score: map['score'] ?? 0,
      estQualifie: map['estQualifie'] ?? false,
      tempsRestant: map['tempsRestant'] ?? 60,
    );
  }
}

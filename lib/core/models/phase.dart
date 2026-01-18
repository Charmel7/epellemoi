enum Phase { qualifications, eliminatories, demiFinale, finale }

extension PhaseExtension on Phase {
  String get nom {
    switch (this) {
      case Phase.qualifications:
        return 'Qualifications';
      case Phase.eliminatories:
        return 'Éliminatoires';
      case Phase.demiFinale:
        return 'Demi-finale';
      case Phase.finale:
        return 'Finale';
    }
  }

  String get nomMajuscules => nom.toUpperCase();
}

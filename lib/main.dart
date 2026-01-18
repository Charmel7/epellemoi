// Fichier: main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/competition_service.dart';
import 'ui/layout/dual_screen_layout.dart';
import 'ui/screens/admin/config_screen.dart';
import 'ui/screens/admin/control_screen.dart';
import 'ui/screens/projection/projection_screen.dart';

void main() {
  runApp(const EpelleMoiApp());
}

class EpelleMoiApp extends StatelessWidget {
  const EpelleMoiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // CORRECTION: Créer le service au niveau de l'app pour le conserver
        ChangeNotifierProvider(
          create: (_) => CompetitionService(),
          lazy: false, // Créer immédiatement
        ),
      ],
      child: MaterialApp(
        title: 'Épelle-Moi - Mode Développement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.dark(
            primary: Color(0xFFD4AF37),
            secondary: Color(0xFF001529),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _estConfigure = false;

  @override
  Widget build(BuildContext context) {
    // CORRECTION: Utiliser le service depuis le Provider
    final competitionService = Provider.of<CompetitionService>(context);

    return DualScreenLayout(
      adminPanel: _estConfigure
          ? ControlScreen(
              onReinitialiser: () {
                // CORRECTION: Réinitialiser proprement
                competitionService.dispose();

                // Recréer une nouvelle instance du service
                // Note: En Flutter, on ne peut pas modifier directement le Provider
                // On utilise setState pour changer l'écran
                setState(() {
                  _estConfigure = false;
                });

                // Afficher un message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Retour à la configuration'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            )
          : ConfigScreen(
              onConfigurationComplete: () {
                // CORRECTION: Vérifier que la configuration est valide
                if (competitionService.mots.isNotEmpty &&
                    competitionService.candidats.isNotEmpty) {
                  setState(() {
                    _estConfigure = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Configuration incomplète. Ajoutez des mots et des candidats.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
      projectionPanel: const ProjectionScreen(),
    );
  }
}

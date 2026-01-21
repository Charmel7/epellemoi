// main.dart - VERSION COMPLÈTE ET CORRIGÉE
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

import 'core/constants/app_colors.dart';
import 'core/services/competition_service.dart';
import 'ui/layout/dual_screen_layout.dart';
import 'ui/screens/admin/config_screen.dart';
import 'ui/screens/admin/control_screen.dart';
import 'ui/screens/projection/projection_screen.dart';

void main() async {
  // Initialiser window_manager avant runApp
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  runApp(const EpelleMoiApp());
}

class EpelleMoiApp extends StatelessWidget {
  const EpelleMoiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CompetitionService(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Épelle-Moi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.dark(
            primary: AppColors.or,
            secondary: AppColors.bleuMarine,
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

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  bool _estConfigure = false;
  bool _isProductionMode = false;
  List<Display> _screens = [];
  bool _isLoadingScreens = false;

  @override
  void initState() {
    super.initState();
    _initWindowManager();
    _detectScreens();
  }

  Future<void> _initWindowManager() async {
    windowManager.addListener(this);

    // Configuration initiale de la fenêtre
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setMinimumSize(const Size(1920, 1080));

    // Appliquer le mode actuel
    await _applyDisplayMode(_isProductionMode);
  }

  Future<void> _detectScreens() async {
    setState(() {
      _isLoadingScreens = true;
    });

    try {
      _screens = await screenRetriever.getAllDisplays();
      print('${_screens.length} écran(s) détecté(s)');
    } catch (e) {
      print('Erreur détection écrans: $e');
    }

    setState(() {
      _isLoadingScreens = false;
    });
  }

  Future<void> _applyDisplayMode(bool productionMode) async {
    try {
      if (!productionMode || _screens.length < 2) {
        // MODE DÉVELOPPEMENT ou seul écran
        await windowManager.setSize(const Size(1920, 1080));
        await windowManager.center();
        await windowManager.setFullScreen(false);

        print('Mode développement activé (1920x1080)');
      } else {
        // MODE PRODUCTION avec 2+ écrans
        final screen1 = _screens[0];
        final screen2 = _screens[1];

        // Calculer la fenêtre qui couvre les 2 écrans
        final left = screen1.visiblePosition!.dx;
        final top = math.min(
          screen1.visiblePosition!.dy,
          screen2.visiblePosition!.dy,
        );
        final right = screen2.visiblePosition!.dx + screen2.size.width;
        final bottom = math.max(
          screen1.visiblePosition!.dy + screen1.size.height,
          screen2.visiblePosition!.dy + screen2.size.height,
        );

        final width = right - left;
        final height = bottom - top;

        await windowManager.setBounds(Rect.fromLTWH(left, top, width, height));
        await windowManager.setFullScreen(false);

        print('Mode production activé: ${width.toInt()}x${height.toInt()}');
      }
    } catch (e) {
      print('Erreur application mode: $e');
      // En cas d'erreur, revenir au mode développement
      await windowManager.setSize(const Size(1920, 1080));
      await windowManager.center();
    }
  }

  void _toggleProductionMode(bool value) async {
    setState(() {
      _isProductionMode = value;
    });

    await _applyDisplayMode(value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Mode PRODUCTION activé (étendu sur ${_screens.length} écran(s))'
              : 'Mode DÉVELOPPEMENT activé',
        ),
        backgroundColor: value ? Colors.green : Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final competitionService = Provider.of<CompetitionService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // CONTENU PRINCIPAL
          DualScreenLayout(
            isProductionMode: _isProductionMode,
            adminPanel: _estConfigure
                ? ControlScreen(
                    onReinitialiser: () {
                      setState(() {
                        _estConfigure = false;
                      });
                    },
                    isProductionMode: _isProductionMode,
                  )
                : ConfigScreen(
                    onConfigurationComplete: () {
                      if (competitionService.mots.isNotEmpty &&
                          competitionService.candidats.isNotEmpty) {
                        setState(() {
                          _estConfigure = true;
                        });
                      }
                    },
                  ),
            projectionPanel: const ProjectionScreen(),
          ),

          // OVERLAY EN HAUT À DROITE (Switch mode)
          Positioned(
            top: 20,
            right: 20,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.or),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre
                    Row(
                      children: [
                        Icon(
                          _isProductionMode ? Icons.tv : Icons.desktop_windows,
                          color: AppColors.or,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'MODE:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Switch
                    Switch(
                      value: _isProductionMode,
                      onChanged: _toggleProductionMode,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.orange,
                      activeTrackColor: Colors.green.withOpacity(0.5),
                      inactiveTrackColor: Colors.orange.withOpacity(0.5),
                    ),

                    // Texte du mode
                    Text(
                      _isProductionMode ? 'PRODUCTION' : 'DÉVELOPPEMENT',
                      style: TextStyle(
                        color: _isProductionMode ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),

                    // Info écrans
                    if (_isLoadingScreens)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.or,
                          ),
                        ),
                      )
                    else if (_screens.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${_screens.length} écran(s)',
                          style: TextStyle(color: Colors.white70, fontSize: 9),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // Sauvegarder l'état si nécessaire avant de fermer
    super.onWindowClose();
  }

  @override
  void onWindowResize() {
    print('Fenêtre redimensionnée');
  }

  @override
  void onWindowMove() {
    print('Fenêtre déplacée');
  }
}

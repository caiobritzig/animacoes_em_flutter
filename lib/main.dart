// main.dart
// Ponto de entrada do aplicativo
// ✅ MATERIAL DESIGN 3: useMaterial3: true + ColorScheme.fromSeed()

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/gallery_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Barra de status transparente para imersão total
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const GaleriaAnimacoesApp());
}

class GaleriaAnimacoesApp extends StatelessWidget {
  const GaleriaAnimacoesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeria Espacial',
      debugShowCheckedModeBanner: false,

      // ✅ MATERIAL DESIGN 3
      theme: ThemeData(
        useMaterial3: true, // habilitando M3
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90D9), // azul espacial como cor base
          brightness: Brightness.dark,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),

      home: const GalleryScreen(),
    );
  }
}

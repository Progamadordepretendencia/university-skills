// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/disciplinas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão Universidade',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 2), // Um pequeno estilo para os cards
      ),
      debugShowCheckedModeBanner: false,
      home: const DisciplinasScreen(), // 2. Defina a tela de professores como a inicial
    );
  }
}

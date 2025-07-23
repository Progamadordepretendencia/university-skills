// lib/screens/main_screen.dart (VERSÃO COMPLETA E FINAL)
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/disciplinas_screen.dart';
import 'package:universidade_frontend/screens/professores_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Precisamos de uma GlobalKey para cada tela para podermos chamar seus métodos de refresh
  final GlobalKey<ProfessoresScreenState> _professoresKey = GlobalKey();
  final GlobalKey<DisciplinasScreenState> _disciplinasKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      ProfessoresScreen(key: _professoresKey),
      DisciplinasScreen(key: _disciplinasKey),
    ];
  }

  static const List<String> _titles = <String>[
    'Gerenciar Professores',
    'Gerenciar Disciplinas',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lógica para o FloatingActionButton
  void _onAddButtonPressed() {
    if (_selectedIndex == 0) {
      // Se estamos na tela de professores, chama a função de adicionar professor
      _professoresKey.currentState?.navigateToAddProfessor();
    } else if (_selectedIndex == 1) {
      // Se estamos na tela de disciplinas, chama a função de adicionar disciplina
      _disciplinasKey.currentState?.navigateToAddDisciplina();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // O FloatingActionButton agora vive aqui
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        tooltip: _selectedIndex == 0 ? 'Adicionar Professor' : 'Adicionar Disciplina',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Professores'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Disciplinas'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
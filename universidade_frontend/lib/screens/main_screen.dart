// lib/screens/main_screen.dart (VERSÃO ATUALIZADA)
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/consultas_menu_screen.dart';
import 'package:universidade_frontend/screens/disciplinas_screen.dart';
import 'package:universidade_frontend/screens/professores_screen.dart';
import 'package:universidade_frontend/screens/turmas_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final GlobalKey<ProfessoresScreenState> _professoresKey = GlobalKey();
  final GlobalKey<DisciplinasScreenState> _disciplinasKey = GlobalKey();
  final GlobalKey<TurmasScreenState> _turmasKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      ProfessoresScreen(key: _professoresKey),
      DisciplinasScreen(key: _disciplinasKey),
      TurmasScreen(key: _turmasKey),
      const ConsultasMenuScreen(), 
    ];
  }

  static const List<String> _titles = <String>[
    'Gerenciar Professores',
    'Gerenciar Disciplinas',
    'Histórico de Turmas',
    'Consultas e Relatórios', // <-- NOVO
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddButtonPressed() {
    if (_selectedIndex == 0) {
      _professoresKey.currentState?.navigateToAddProfessor();
    } else if (_selectedIndex == 1) {
      _disciplinasKey.currentState?.navigateToAddDisciplina();
    } else if (_selectedIndex == 2) {
      _turmasKey.currentState?.navigateToAddTurma();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apenas mostra o botão de adicionar nas 3 primeiras telas
    final showFab = _selectedIndex < 3;

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: _onAddButtonPressed,
              tooltip: 'Adicionar',
              child: const Icon(Icons.add),
            )
          : null, // Esconde o botão na tela de consulta
      bottomNavigationBar: BottomNavigationBar(
        // Adicionado para garantir que os itens fiquem visíveis com 4+ abas
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Professores'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Disciplinas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Turmas'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Consultas'), // <-- NOVO
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
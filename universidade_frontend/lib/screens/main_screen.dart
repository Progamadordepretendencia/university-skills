import 'package:flutter/material.dart';
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

  // Adicione a GlobalKey para a nova tela
  final GlobalKey<ProfessoresScreenState> _professoresKey = GlobalKey();
  final GlobalKey<DisciplinasScreenState> _disciplinasKey = GlobalKey();
  final GlobalKey<TurmasScreenState> _turmasKey = GlobalKey(); // <-- NOVO

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Adicione a nova tela à lista
    _screens = <Widget>[
      ProfessoresScreen(key: _professoresKey),
      DisciplinasScreen(key: _disciplinasKey),
      TurmasScreen(key: _turmasKey), 
    ];
  }

  // Adicione o título para a nova tela
  static const List<String> _titles = <String>[
    'Gerenciar Professores',
    'Gerenciar Disciplinas',
    'Histórico de Turmas',
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
    } else if (_selectedIndex == 2) { // <-- NOVO
      _turmasKey.currentState?.navigateToAddTurma();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        tooltip: _titles[_selectedIndex].replaceFirst('Gerenciar ', 'Adicionar '),
        child: const Icon(Icons.add),
      ),
      // Adicione o novo item na barra de navegação
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Professores'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Disciplinas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Turmas'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
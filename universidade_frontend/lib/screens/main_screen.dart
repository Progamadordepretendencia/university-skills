// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/disciplinas_screen.dart';
import 'package:universidade_frontend/screens/professores_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controla qual aba está selecionada (0 = Professores, 1 = Disciplinas)
  int _selectedIndex = 0;

  // Lista das telas que serão exibidas
  static const List<Widget> _screens = <Widget>[
    ProfessoresScreen(),
    DisciplinasScreen(),
  ];

  // Lista dos títulos para a AppBar
  static const List<String> _titles = <String>[
    'Gerenciar Professores',
    'Gerenciar Disciplinas',
  ];

  // Função chamada quando um item da barra de navegação é tocado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // O título da AppBar muda de acordo com a tela selecionada
        title: Text(_titles[_selectedIndex]),
      ),
      // O corpo do Scaffold exibe a tela correspondente ao índice selecionado
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Professores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Disciplinas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

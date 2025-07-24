// lib/screens/consultas_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/consulta_aptidao_screen.dart';
import 'package:universidade_frontend/screens/consulta_historico_screen.dart';

class ConsultasMenuScreen extends StatelessWidget {
  const ConsultasMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Aptidão por Disciplina'),
            subtitle: const Text('Veja quais professores podem ministrar uma disciplina'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ConsultaAptidaoScreen()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Histórico por Professor'),
            subtitle: const Text('Veja o resumo de aulas de um professor'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ConsultaHistoricoScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

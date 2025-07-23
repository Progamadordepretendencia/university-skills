// lib/screens/professores_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/professor_model.dart';

class ProfessoresScreen extends StatefulWidget {
  const ProfessoresScreen({super.key});

  @override
  State<ProfessoresScreen> createState() => _ProfessoresScreenState();
}

class _ProfessoresScreenState extends State<ProfessoresScreen> {
  // Um Future para armazenar o resultado da chamada da API
  late Future<List<Professor>> _professoresFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Inicia a chamada da API assim que a tela é construída
    _professoresFuture = _apiService.fetchProfessores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Professores'),
      ),
      // FutureBuilder é o widget perfeito para lidar com dados assíncronos
      body: FutureBuilder<List<Professor>>(
        future: _professoresFuture,
        builder: (context, snapshot) {
          // 1. Enquanto os dados estão carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Se ocorreu um erro
          else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          // 3. Se os dados chegaram com sucesso, mas estão vazios
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum professor encontrado.'));
          }
          // 4. Se os dados chegaram com sucesso e não estão vazios
          else {
            final professores = snapshot.data!;
            // Usamos ListView.builder para construir a lista de forma otimizada
            return ListView.builder(
              itemCount: professores.length,
              itemBuilder: (context, index) {
                final professor = professores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(professor.nome[0]), // Mostra a inicial do nome
                    ),
                    title: Text(professor.nome),
                    subtitle: Text(professor.email),
                    trailing: Text('ID: ${professor.id}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar a navegação para a tela de adicionar professor
        },
        tooltip: 'Adicionar Professor',
        child: const Icon(Icons.add),
      ),
    );
  }
}

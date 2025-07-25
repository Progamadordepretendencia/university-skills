// lib/screens/professores_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/aptidao_screen.dart';
import 'package:universidade_frontend/screens/professor_form_screen.dart';
import '../services/api_service.dart';
import '../models/professor_model.dart';

class ProfessoresScreen extends StatefulWidget {
  const ProfessoresScreen({super.key});

  @override
  ProfessoresScreenState createState() => ProfessoresScreenState();
}

class ProfessoresScreenState extends State<ProfessoresScreen> {
  late Future<List<Professor>> _professoresFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    refreshProfessores();
  }

  void refreshProfessores() {
    setState(() {
      _professoresFuture = _apiService.fetchProfessores();
    });
  }

  void navigateToAddProfessor() async {
    final result = await Navigator.of(context).push<Professor>(
      MaterialPageRoute(builder: (_) => const ProfessorFormScreen()),
    );

    if (result != null && mounted) {
      try {
        await _apiService.createProfessor(result);
        refreshProfessores();
        showSnackBar('Professor criado com sucesso!');
      } catch (e) {
        showSnackBar('Erro ao criar professor: ${e.toString()}', isError: true);
      }
    }
  }

  void navigateToEditProfessor(Professor professor) async {
    final result = await Navigator.of(context).push<Professor>(
      MaterialPageRoute(builder: (_) => ProfessorFormScreen(professor: professor)),
    );

    if (result != null && mounted) {
      try {
        await _apiService.updateProfessor(result);
        refreshProfessores();
        showSnackBar('Professor atualizado com sucesso!');
      } catch (e) {
        showSnackBar('Erro ao atualizar professor: ${e.toString()}', isError: true);
      }
    }
  }

  void confirmDeleteProfessor(int? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja deletar este professor?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Deletar'),
            onPressed: () {
              Navigator.of(ctx).pop();
              deleteProfessor(id);
            },
          ),
        ],
      ),
    );
  }

  // Método agora é público
  void deleteProfessor(int id) async {
    try {
      await _apiService.deleteProfessor(id);
      refreshProfessores();
      showSnackBar('Professor deletado com sucesso!');
    } catch (e) {
      showSnackBar('Erro ao deletar professor: ${e.toString()}', isError: true);
    }
  }

  // Método agora é público
  void showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Professor>>(
      future: _professoresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum professor encontrado.'));
        } else {
          final professores = snapshot.data!;
          return ListView.builder(
            itemCount: professores.length,
            itemBuilder: (context, index) {
              final professor = professores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(professor.nome.isNotEmpty ? professor.nome[0] : '?')),
                  title: Text(professor.nome),
                  subtitle: Text(professor.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       IconButton(
                        icon: const Icon(Icons.school, color: Colors.orange),
                        tooltip: 'Gerenciar Aptidões',
                       onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (_) => AptidaoScreen(professor: professor),
                               ),
                            );
                         },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => navigateToEditProfessor(professor),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDeleteProfessor(professor.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

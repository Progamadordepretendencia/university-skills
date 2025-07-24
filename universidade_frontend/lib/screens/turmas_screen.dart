// lib/screens/turmas_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/models/turma_model.dart';
import 'package:universidade_frontend/screens/turma_form_screen.dart';
import 'package:universidade_frontend/services/api_service.dart';

class TurmasScreen extends StatefulWidget {
  const TurmasScreen({super.key});
  @override
  TurmasScreenState createState() => TurmasScreenState();
}

class TurmasScreenState extends State<TurmasScreen> {
  late Future<List<Turma>> _turmasFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    refreshTurmas();
  }

  void refreshTurmas() {
    setState(() {
      _turmasFuture = _apiService.fetchTurmas();
    });
  }

  void navigateToAddTurma() async {
    final result = await Navigator.of(context).push<Turma>(
      MaterialPageRoute(builder: (_) => const TurmaFormScreen()),
    );
    if (result != null && mounted) {
      try {
        await _apiService.createTurma(result);
        refreshTurmas();
        showSnackBar('Turma criada com sucesso!');
      } catch (e) {
        showSnackBar('Erro: ${e.toString()}', isError: true);
      }
    }
  }

  void navigateToEditTurma(Turma turma) async {
    final result = await Navigator.of(context).push<Turma>(
      MaterialPageRoute(builder: (_) => TurmaFormScreen(turma: turma)),
    );
    if (result != null && mounted) {
      try {
        await _apiService.updateTurma(result);
        refreshTurmas();
        showSnackBar('Turma atualizada com sucesso!');
      } catch (e) {
        showSnackBar('Erro: ${e.toString()}', isError: true);
      }
    }
  }

  void confirmDeleteTurma(int? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja deletar este registro de turma?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Deletar'),
            onPressed: () {
              Navigator.of(ctx).pop();
              deleteTurma(id);
            },
          ),
        ],
      ),
    );
  }

  void deleteTurma(int id) async {
    try {
      await _apiService.deleteTurma(id);
      refreshTurmas();
      showSnackBar('Turma deletada com sucesso!');
    } catch (e) {
      showSnackBar('Erro: ${e.toString()}', isError: true);
    }
  }

  void showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Turma>>(
      future: _turmasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum registro de turma encontrado.'));
        } else {
          final turmas = snapshot.data!;
          return ListView.builder(
            itemCount: turmas.length,
            itemBuilder: (context, index) {
              final turma = turmas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('${turma.disciplinaNome ?? 'Disciplina não encontrada'} - ${turma.ano}.${turma.semestre}'),
                  subtitle: Text('Professor: ${turma.professorNome ?? 'Não definido'}\nAlunos: ${turma.numeroAlunos} - Carga Horária: ${turma.cargaHorariaEfetiva}h'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => navigateToEditTurma(turma)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => confirmDeleteTurma(turma.id)),
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

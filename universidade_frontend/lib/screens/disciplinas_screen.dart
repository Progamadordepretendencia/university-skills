import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/disciplina_form_screen.dart';
import '../models/disciplina_model.dart';
import '../services/api_service.dart';

class DisciplinasScreen extends StatefulWidget {
  const DisciplinasScreen({super.key});

  @override
  DisciplinasScreenState createState() => DisciplinasScreenState();
}

class DisciplinasScreenState extends State<DisciplinasScreen> {
  late Future<List<Disciplina>> _disciplinasFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    refreshDisciplinas();
  }

  void refreshDisciplinas() {
    setState(() {
      _disciplinasFuture = _apiService.fetchDisciplinas();
    });
  }

  void navigateToAddDisciplina() async {
    final result = await Navigator.of(context).push<Disciplina>(
      MaterialPageRoute(builder: (_) => const DisciplinaFormScreen()),
    );
    if (result != null && mounted) {
      try {
        await _apiService.createDisciplina(result);
        refreshDisciplinas();
        showSnackBar('Disciplina criada com sucesso!');
      } catch (e) {
        showSnackBar('Erro ao criar disciplina: ${e.toString()}', isError: true);
      }
    }
  }

  void navigateToEditDisciplina(Disciplina disciplina) async {
    final result = await Navigator.of(context).push<Disciplina>(
      MaterialPageRoute(builder: (_) => DisciplinaFormScreen(disciplina: disciplina)),
    );
    if (result != null && mounted) {
      try {
        await _apiService.updateDisciplina(result);
        refreshDisciplinas();
        showSnackBar('Disciplina atualizada com sucesso!');
      } catch (e) {
        showSnackBar('Erro ao atualizar disciplina: ${e.toString()}', isError: true);
      }
    }
  }

  void confirmDeleteDisciplina(int? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja deletar esta disciplina?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Deletar'),
            onPressed: () {
              Navigator.of(ctx).pop();
              deleteDisciplina(id);
            },
          ),
        ],
      ),
    );
  }

  void deleteDisciplina(int id) async {
    try {
      await _apiService.deleteDisciplina(id);
      refreshDisciplinas();
      showSnackBar('Disciplina deletada com sucesso!');
    } catch (e) {
      showSnackBar('Erro ao deletar disciplina: ${e.toString()}', isError: true);
    }
  }

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
    // O Scaffold, AppBar e FloatingActionButton foram removidos.
    return FutureBuilder<List<Disciplina>>(
      future: _disciplinasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma disciplina encontrada.'));
        } else {
          final disciplinas = snapshot.data!;
          return ListView.builder(
            itemCount: disciplinas.length,
            itemBuilder: (context, index) {
              final disciplina = disciplinas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(disciplina.codigoDisciplina.isNotEmpty ? disciplina.codigoDisciplina.substring(0, 2) : '?'),
                  ),
                  title: Text(disciplina.nome),
                  subtitle: Text('Código: ${disciplina.codigoDisciplina} - Carga Horária: ${disciplina.cargaHoraria}h'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => navigateToEditDisciplina(disciplina),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDeleteDisciplina(disciplina.id),
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
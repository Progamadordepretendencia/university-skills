// lib/screens/disciplinas_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/disciplina_form_screen.dart';
import '../models/disciplina_model.dart';
import '../services/api_service.dart';

class DisciplinasScreen extends StatefulWidget {
  const DisciplinasScreen({super.key});

  @override
  State<DisciplinasScreen> createState() => _DisciplinasScreenState();
}

class _DisciplinasScreenState extends State<DisciplinasScreen> {
  late Future<List<Disciplina>> _disciplinasFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshDisciplinas();
  }

  void _refreshDisciplinas() {
    setState(() {
      _disciplinasFuture = _apiService.fetchDisciplinas();
    });
  }

  void _navigateToAddDisciplina() async {
    final result = await Navigator.of(context).push<Disciplina>(
      MaterialPageRoute(builder: (_) => const DisciplinaFormScreen()),
    );
    if (result != null) {
      try {
        await _apiService.createDisciplina(result);
        _refreshDisciplinas();
        _showSnackBar('Disciplina criada com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao criar disciplina: ${e.toString()}', isError: true);
      }
    }
  }

  void _navigateToEditDisciplina(Disciplina disciplina) async {
    final result = await Navigator.of(context).push<Disciplina>(
      MaterialPageRoute(builder: (_) => DisciplinaFormScreen(disciplina: disciplina)),
    );
    if (result != null) {
      try {
        await _apiService.updateDisciplina(result);
        _refreshDisciplinas();
        _showSnackBar('Disciplina atualizada com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao atualizar disciplina: ${e.toString()}', isError: true);
      }
    }
  }

  void _confirmDeleteDisciplina(int id) {
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
              _deleteDisciplina(id);
            },
          ),
        ],
      ),
    );
  }

  void _deleteDisciplina(int id) async {
    try {
      await _apiService.deleteDisciplina(id);
      _refreshDisciplinas();
      _showSnackBar('Disciplina deletada com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao deletar disciplina: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Disciplinas'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshDisciplinas),
        ],
      ),
      body: FutureBuilder<List<Disciplina>>(
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
                      child: Text(disciplina.codigoDisciplina.substring(0, 2)),
                    ),
                    title: Text(disciplina.nome),
                    subtitle: Text('Código: ${disciplina.codigoDisciplina} - Carga Horária: ${disciplina.cargaHoraria}h'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToEditDisciplina(disciplina),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteDisciplina(disciplina.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDisciplina,
        tooltip: 'Adicionar Disciplina',
        child: const Icon(Icons.add),
      ),
    );
  }
}

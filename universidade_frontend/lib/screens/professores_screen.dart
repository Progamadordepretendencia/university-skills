// lib/screens/professores_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/screens/professor_form_screen.dart';
import '../services/api_service.dart';
import '../models/professor_model.dart';

class ProfessoresScreen extends StatefulWidget {
  const ProfessoresScreen({super.key});

  @override
  State<ProfessoresScreen> createState() => _ProfessoresScreenState();
}

class _ProfessoresScreenState extends State<ProfessoresScreen> {
  // Agora a lista é um estado, para que possamos atualizá-la
  late Future<List<Professor>> _professoresFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshProfessores();
  }

  // Função para recarregar a lista da API
  void _refreshProfessores() {
    setState(() {
      _professoresFuture = _apiService.fetchProfessores();
    });
  }

  // Navega para a tela de formulário para criar um novo professor
  void _navigateToAddProfessor() async {
    final result = await Navigator.of(context).push<Professor>(
      MaterialPageRoute(builder: (_) => const ProfessorFormScreen()),
    );

    if (result != null) {
      // Se um professor foi retornado, chama a API para criá-lo
      try {
        await _apiService.createProfessor(result);
        _refreshProfessores(); // Recarrega a lista após a criação
        _showSnackBar('Professor criado com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao criar professor: ${e.toString()}', isError: true);
      }
    }
  }

  // Navega para a tela de formulário para editar um professor existente
  void _navigateToEditProfessor(Professor professor) async {
    final result = await Navigator.of(context).push<Professor>(
      MaterialPageRoute(builder: (_) => ProfessorFormScreen(professor: professor)),
    );

    if (result != null) {
      try {
        await _apiService.updateProfessor(result);
        _refreshProfessores();
        _showSnackBar('Professor atualizado com sucesso!');
      } catch (e) {
        _showSnackBar('Erro ao atualizar professor: ${e.toString()}', isError: true);
      }
    }
  }

  // Mostra um diálogo de confirmação antes de deletar
  void _confirmDeleteProfessor(int id) {
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
              _deleteProfessor(id);
            },
          ),
        ],
      ),
    );
  }

  // Chama a API para deletar o professor
  void _deleteProfessor(int id) async {
    try {
      await _apiService.deleteProfessor(id);
      _refreshProfessores();
      _showSnackBar('Professor deletado com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao deletar professor: ${e.toString()}', isError: true);
    }
  }

  // Helper para mostrar uma SnackBar
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
        title: const Text('Gerenciar Professores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfessores,
          ),
        ],
      ),
      body: FutureBuilder<List<Professor>>(
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
                    leading: CircleAvatar(child: Text(professor.nome[0])),
                    title: Text(professor.nome),
                    subtitle: Text(professor.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToEditProfessor(professor),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteProfessor(professor.id),
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
        onPressed: _navigateToAddProfessor,
        tooltip: 'Adicionar Professor',
        child: const Icon(Icons.add),
      ),
    );
  }
}

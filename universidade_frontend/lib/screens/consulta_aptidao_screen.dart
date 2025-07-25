import 'package:flutter/material.dart';
import 'package:universidade_frontend/models/disciplina_model.dart';
import 'package:universidade_frontend/models/professor_model.dart';
import 'package:universidade_frontend/services/api_service.dart';

class ConsultaAptidaoScreen extends StatefulWidget {
  const ConsultaAptidaoScreen({super.key});

  @override
  State<ConsultaAptidaoScreen> createState() => _ConsultaAptidaoScreenState();
}

class _ConsultaAptidaoScreenState extends State<ConsultaAptidaoScreen> {
  final ApiService _apiService = ApiService();
  List<Disciplina>? _disciplinas;
  int? _selectedDisciplinaId;
  List<Professor>? _professoresAptos;
  bool _isLoadingDisciplinas = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchDisciplinas();
  }

  Future<void> _fetchDisciplinas() async {
    try {
      final disciplinas = await _apiService.fetchDisciplinas();
      setState(() {
        _disciplinas = disciplinas;
        _isLoadingDisciplinas = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDisciplinas = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar disciplinas: $e')));
      }
    }
  }

  Future<void> _onDisciplinaSelected(int? disciplinaId) async {
    if (disciplinaId == null) return;

    setState(() {
      _selectedDisciplinaId = disciplinaId;
      _isSearching = true; 
      _professoresAptos = null; 
    });

    try {
      final professores = await _apiService.fetchProfessoresAptos(disciplinaId);
      setState(() {
        _professoresAptos = professores;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao buscar professores: $e')));
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
   
    appBar: AppBar(
      title: const Text('Aptidão por Disciplina'),
    ),
  
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      
          DropdownButtonFormField<int>(
            value: _selectedDisciplinaId,
            hint: _isLoadingDisciplinas
                ? const Text('Carregando disciplinas...')
                : const Text('Selecione uma disciplina'),
            isExpanded: true,
            items: _disciplinas?.map((d) {
              return DropdownMenuItem(value: d.id, child: Text(d.nome));
            }).toList(),
            onChanged: _isLoadingDisciplinas ? null : _onDisciplinaSelected,
            decoration: const InputDecoration(
              labelText: 'Disciplina',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Text('Professores Aptos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: _buildResultsWidget(),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildResultsWidget() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_professoresAptos == null) {
      return const Center(child: Text('Selecione uma disciplina para ver os professores aptos.'));
    }

    if (_professoresAptos!.isEmpty) {
      return const Center(child: Text('Nenhum professor apto encontrado para esta disciplina.'));
    }

    return ListView.builder(
      itemCount: _professoresAptos!.length,
      itemBuilder: (context, index) {
        final professor = _professoresAptos![index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(professor.nome[0])),
            title: Text(professor.nome),
            subtitle: Text(professor.email),
          ),
        );
      },
    );
  }
}

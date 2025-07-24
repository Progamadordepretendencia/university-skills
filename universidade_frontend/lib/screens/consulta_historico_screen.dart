// lib/screens/consulta_historico_screen.dart
import 'package:flutter/material.dart';
import 'package:universidade_frontend/models/historico_model.dart';
import 'package:universidade_frontend/models/professor_model.dart';
import 'package:universidade_frontend/services/api_service.dart';

class ConsultaHistoricoScreen extends StatefulWidget {
  const ConsultaHistoricoScreen({super.key});

  @override
  State<ConsultaHistoricoScreen> createState() => _ConsultaHistoricoScreenState();
}

class _ConsultaHistoricoScreenState extends State<ConsultaHistoricoScreen> {
  final ApiService _apiService = ApiService();

  List<Professor>? _professores;
  int? _selectedProfessorId;
  List<Historico>? _historicoResult;
  bool _isLoadingProfessores = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchProfessores();
  }

  Future<void> _fetchProfessores() async {
    try {
      final professores = await _apiService.fetchProfessores();
      setState(() {
        _professores = professores;
        _isLoadingProfessores = false;
      });
    } catch (e) {
      setState(() { _isLoadingProfessores = false; });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar professores: $e')));
    }
  }

  Future<void> _onProfessorSelected(int? professorId) async {
    if (professorId == null) return;

    setState(() {
      _selectedProfessorId = professorId;
      _isSearching = true;
      _historicoResult = null;
    });

    try {
      final historico = await _apiService.fetchProfessorHistorico(professorId);
      setState(() {
        _historicoResult = historico;
        _isSearching = false;
      });
    } catch (e) {
      setState(() { _isSearching = false; });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao buscar histórico: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico por Professor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedProfessorId,
              hint: _isLoadingProfessores ? const Text('Carregando...') : const Text('Selecione um professor'),
              isExpanded: true,
              items: _professores?.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nome))).toList(),
              onChanged: _isLoadingProfessores ? null : _onProfessorSelected,
              decoration: const InputDecoration(labelText: 'Professor', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Expanded(child: _buildResultsWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsWidget() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_historicoResult == null) {
      return const Center(child: Text('Selecione um professor para ver seu histórico.'));
    }
    if (_historicoResult!.isEmpty) {
      return const Center(child: Text('Nenhum histórico de turmas encontrado para este professor.'));
    }
    return ListView.builder(
      itemCount: _historicoResult!.length,
      itemBuilder: (context, index) {
        final historico = _historicoResult![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  historico.disciplinaNome,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(historico.codigoDisciplina, style: Theme.of(context).textTheme.bodySmall),
                const Divider(height: 24),
                _buildStatRow(Icons.history, 'Turmas Ministradas', historico.quantidadeTurmas.toString()),
                const SizedBox(height: 8),
                _buildStatRow(Icons.schedule, 'Total de Horas', '${historico.totalCargaHoraria}h'),
                const SizedBox(height: 8),
                _buildStatRow(Icons.group, 'Total de Alunos', historico.totalAlunos.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}

// lib/screens/consulta_aptidao_screen.dart
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

  // Variáveis de estado
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

  // Busca a lista de todas as disciplinas para preencher o dropdown
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

  // Chamado quando o usuário seleciona uma disciplina no dropdown
  Future<void> _onDisciplinaSelected(int? disciplinaId) async {
    if (disciplinaId == null) return;

    setState(() {
      _selectedDisciplinaId = disciplinaId;
      _isSearching = true; // Mostra o loading na área de resultados
      _professoresAptos = null; // Limpa resultados antigos
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
  // 1. Adicione o Scaffold como o widget raiz da tela.
  return Scaffold(
    // 2. Adicione uma AppBar. Isso dá um título à tela e um botão de "voltar" automaticamente.
    appBar: AppBar(
      title: const Text('Aptidão por Disciplina'),
    ),
    // 3. O conteúdo anterior da sua tela agora vai dentro da propriedade `body` do Scaffold.
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ... o resto do seu código (Dropdown, Divider, Expanded) continua o mesmo aqui dentro ...
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

  // Widget auxiliar para construir a área de resultados
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

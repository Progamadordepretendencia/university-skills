// lib/screens/turma_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universidade_frontend/models/disciplina_model.dart';
import 'package:universidade_frontend/models/professor_model.dart';
import 'package:universidade_frontend/models/turma_model.dart';
import 'package:universidade_frontend/services/api_service.dart';

class TurmaFormScreen extends StatefulWidget {
  final Turma? turma;
  const TurmaFormScreen({super.key, this.turma});

  @override
  State<TurmaFormScreen> createState() => _TurmaFormScreenState();
}

class _TurmaFormScreenState extends State<TurmaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Controladores para os campos de texto
  late TextEditingController _anoController;
  late TextEditingController _semestreController;
  late TextEditingController _alunosController;
  late TextEditingController _cargaHorariaController;

  // Variáveis para os dropdowns
  List<Professor>? _professores;
  List<Disciplina>? _disciplinas;
  int? _selectedProfessorId;
  int? _selectedDisciplinaId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchDropdownData();
  }

  void _initializeFields() {
    final turma = widget.turma;
    _anoController = TextEditingController(text: turma?.ano.toString() ?? '');
    _semestreController = TextEditingController(text: turma?.semestre.toString() ?? '');
    _alunosController = TextEditingController(text: turma?.numeroAlunos.toString() ?? '');
    _cargaHorariaController = TextEditingController(text: turma?.cargaHorariaEfetiva.toString() ?? '');
    _selectedProfessorId = turma?.professorId;
    _selectedDisciplinaId = turma?.disciplinaId;
  }

  Future<void> _fetchDropdownData() async {
    try {
      final results = await Future.wait([
        _apiService.fetchProfessores(),
        _apiService.fetchDisciplinas(),
      ]);
      setState(() {
        _professores = results[0] as List<Professor>;
        _disciplinas = results[1] as List<Disciplina>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final novaTurma = Turma(
        id: widget.turma?.id,
        professorId: _selectedProfessorId,
        disciplinaId: _selectedDisciplinaId!,
        ano: int.parse(_anoController.text),
        semestre: int.parse(_semestreController.text),
        numeroAlunos: int.parse(_alunosController.text),
        cargaHorariaEfetiva: int.parse(_cargaHorariaController.text),
      );
      Navigator.of(context).pop(novaTurma);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turma == null ? 'Adicionar Turma' : 'Editar Turma'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<int>(
                      value: _selectedProfessorId,
                      decoration: const InputDecoration(labelText: 'Professor'),
                      items: _professores?.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nome))).toList() ?? [],
                      onChanged: (value) => setState(() => _selectedProfessorId = value),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedDisciplinaId,
                      decoration: const InputDecoration(labelText: 'Disciplina'),
                      items: _disciplinas?.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome))).toList() ?? [],
                      onChanged: (value) => setState(() => _selectedDisciplinaId = value),
                      validator: (value) => value == null ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _anoController,
                      decoration: const InputDecoration(labelText: 'Ano'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _semestreController,
                      decoration: const InputDecoration(labelText: 'Semestre (1 ou 2)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                    ),
                     const SizedBox(height: 16),
                    TextFormField(
                      controller: _alunosController,
                      decoration: const InputDecoration(labelText: 'Número de Alunos'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                    ),
                     const SizedBox(height: 16),
                    TextFormField(
                      controller: _cargaHorariaController,
                      decoration: const InputDecoration(labelText: 'Carga Horária Efetiva'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(onPressed: _submitForm, child: const Text('Salvar')),
                  ],
                ),
              ),
            ),
    );
  }
}

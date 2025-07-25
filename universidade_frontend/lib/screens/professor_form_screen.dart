import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote para formatação de data
import '../models/professor_model.dart';

class ProfessorFormScreen extends StatefulWidget {
  final Professor? professor;

  const ProfessorFormScreen({super.key, this.professor});

  @override
  State<ProfessorFormScreen> createState() => _ProfessorFormScreenState();
}

class _ProfessorFormScreenState extends State<ProfessorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late DateTime _dataContratacao;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.professor?.nome ?? '');
    _emailController = TextEditingController(text: widget.professor?.email ?? '');
    _dataContratacao = widget.professor?.dataContratacao ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataContratacao,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataContratacao) {
      setState(() {
        _dataContratacao = picked;
      });
    }
  }

  void _submitForm() {
  final formState = _formKey.currentState;
  if (formState == null) {
    return; 
  }

  // 3. Se o estado não for nulo, validamos e continuamos como antes.
  if (formState.validate()) {
    final novoProfessor = Professor(
      id: widget.professor?.id,
      nome: _nomeController.text,
      email: _emailController.text,
      dataContratacao: _dataContratacao,
    );
    Navigator.of(context).pop(novoProfessor);
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.professor == null ? 'Adicionar Professor' : 'Editar Professor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data de Contratação: ${DateFormat('dd/MM/yyyy').format(_dataContratacao)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

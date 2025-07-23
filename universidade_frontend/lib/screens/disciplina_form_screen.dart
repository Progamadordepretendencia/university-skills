// lib/screens/disciplina_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/disciplina_model.dart';

class DisciplinaFormScreen extends StatefulWidget {
  final Disciplina? disciplina;

  const DisciplinaFormScreen({super.key, this.disciplina});

  @override
  State<DisciplinaFormScreen> createState() => _DisciplinaFormScreenState();
}

class _DisciplinaFormScreenState extends State<DisciplinaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _nomeController;
  late TextEditingController _cargaHorariaController;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.disciplina?.codigoDisciplina ?? '');
    _nomeController = TextEditingController(text: widget.disciplina?.nome ?? '');
    _cargaHorariaController = TextEditingController(text: widget.disciplina?.cargaHoraria.toString() ?? '');
  }

  void _submitForm() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final novaDisciplina = Disciplina(
      id: widget.disciplina?.id,
      codigoDisciplina: _codigoController.text,
      nome: _nomeController.text,
      cargaHoraria: int.parse(_cargaHorariaController.text),
    );
    Navigator.of(context).pop(novaDisciplina);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.disciplina == null ? 'Adicionar Disciplina' : 'Editar Disciplina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código da Disciplina'),
                validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Disciplina'),
                validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cargaHorariaController,
                decoration: const InputDecoration(labelText: 'Carga Horária (horas)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório.' : null,
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

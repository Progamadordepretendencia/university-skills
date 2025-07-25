import 'package:flutter/material.dart';
import '../models/disciplina_model.dart';
import '../models/professor_model.dart';
import '../services/api_service.dart';

class AptidaoScreen extends StatefulWidget {
  final Professor professor;

  const AptidaoScreen({super.key, required this.professor});

  @override
  State<AptidaoScreen> createState() => _AptidaoScreenState();
}

class _AptidaoScreenState extends State<AptidaoScreen> {
  final ApiService _apiService = ApiService();
  List<Disciplina>? _todasDisciplinas;
  Set<int>? _aptidoesAtuaisIds; // Usar um Set é eficiente para buscas rápidas

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        _apiService.fetchDisciplinas(),
        _apiService.fetchAptidoes(widget.professor.id!),
      ]);

      final todas = results[0];
      final atuais = results[1];

      setState(() {
        _todasDisciplinas = todas;
        _aptidoesAtuaisIds = atuais.map((d) => d.id!).toSet();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _onAptidaoChanged(bool isChecked, Disciplina disciplina) async {
    final professorId = widget.professor.id!;
    final disciplinaId = disciplina.id!;

  
    setState(() {
      if (isChecked) {
        _aptidoesAtuaisIds!.add(disciplinaId);
      } else {
        _aptidoesAtuaisIds!.remove(disciplinaId);
      }
    });

    try {
      if (isChecked) {
        await _apiService.addAptidao(professorId, disciplinaId);
      } else {
        await _apiService.removeAptidao(professorId, disciplinaId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aptidão atualizada para ${disciplina.nome}'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        if (isChecked) {
          _aptidoesAtuaisIds!.remove(disciplinaId);
        } else {
          _aptidoesAtuaisIds!.add(disciplinaId);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar aptidão: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aptidões de ${widget.professor.nome}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todasDisciplinas == null || _aptidoesAtuaisIds == null
              ? const Center(child: Text('Não foi possível carregar os dados.'))
              : ListView.builder(
                  itemCount: _todasDisciplinas!.length,
                  itemBuilder: (context, index) {
                    final disciplina = _todasDisciplinas![index];
                    final isApto = _aptidoesAtuaisIds!.contains(disciplina.id);

                    return CheckboxListTile(
                      title: Text(disciplina.nome),
                      subtitle: Text(disciplina.codigoDisciplina),
                      value: isApto,
                      onChanged: (bool? value) {
                        if (value != null) {
                          _onAptidaoChanged(value, disciplina);
                        }
                      },
                    );
                  },
                ),
    );
  }
}

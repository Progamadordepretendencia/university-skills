// lib/screens/aptidao_screen.dart
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
  // Duas listas para o estado: todas as disciplinas e as aptidões do professor
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
      // Usamos Future.wait para buscar ambos os dados em paralelo, otimizando o carregamento
      final results = await Future.wait([
        _apiService.fetchDisciplinas(),
        _apiService.fetchAptidoes(widget.professor.id!),
      ]);

      final todas = results[0];
      final atuais = results[1];

      setState(() {
        _todasDisciplinas = todas;
        // Criamos um Set com os IDs das disciplinas que o professor já é apto
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

  // Função chamada quando uma checkbox é marcada/desmarcada
  Future<void> _onAptidaoChanged(bool isChecked, Disciplina disciplina) async {
    final professorId = widget.professor.id!;
    final disciplinaId = disciplina.id!;

    // Feedback visual imediato para o usuário
    setState(() {
      if (isChecked) {
        _aptidoesAtuaisIds!.add(disciplinaId);
      } else {
        _aptidoesAtuaisIds!.remove(disciplinaId);
      }
    });

    // Chamada à API em segundo plano
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
      // Se a API falhar, reverte o estado visual e mostra o erro
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

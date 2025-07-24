// lib/models/historico_model.dart
import 'dart:convert';

List<Historico> historicoFromJson(String str) => List<Historico>.from(json.decode(str).map((x) => Historico.fromJson(x)));

class Historico {
  final int disciplinaId;
  final String disciplinaNome;
  final String codigoDisciplina;
  final int totalCargaHoraria;
  final int totalAlunos;
  final int quantidadeTurmas;

  Historico({
    required this.disciplinaId,
    required this.disciplinaNome,
    required this.codigoDisciplina,
    required this.totalCargaHoraria,
    required this.totalAlunos,
    required this.quantidadeTurmas,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    // As funções de agregação do SQL (SUM, COUNT) podem retornar os números como String.
    // Usamos int.parse para garantir a conversão segura para inteiros.
    return Historico(
      disciplinaId: json["disciplina_id"],
      disciplinaNome: json["disciplina_nome"],
      codigoDisciplina: json["codigo_disciplina"],
      totalCargaHoraria: int.parse(json["total_carga_horaria"].toString()),
      totalAlunos: int.parse(json["total_alunos"].toString()),
      quantidadeTurmas: json["quantidade_turmas"],
    );
  }
}

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

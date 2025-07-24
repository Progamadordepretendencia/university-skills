// lib/models/turma_model.dart (VERSÃO ROBUSTA)
import 'dart:convert';

List<Turma> turmaFromJson(String str) => List<Turma>.from(json.decode(str).map((x) => Turma.fromJson(x)));

class Turma {
  final int? id;
  final int? professorId;
  final int disciplinaId;
  final int ano;
  final int semestre;
  final int numeroAlunos;
  final int cargaHorariaEfetiva;
  final String? professorNome;
  final String? disciplinaNome;

  Turma({
    this.id,
    this.professorId,
    required this.disciplinaId,
    required this.ano,
    required this.semestre,
    required this.numeroAlunos,
    required this.cargaHorariaEfetiva,
    this.professorNome,
    this.disciplinaNome,
  });

  factory Turma.fromJson(Map<String, dynamic> json) {
     return Turma(
      id: json["id"], // ID pode ser nulo, então não precisa de '??'
      professorId: json["professor_id"], // professorId também pode ser nulo

      // A partir daqui, todos os campos são obrigatórios (não-nulos)
      disciplinaId: json["disciplina_id"] ?? 0,
      ano: json["ano"] ?? 0,
      semestre: json["semestre"] ?? 0,
      numeroAlunos: json["numero_alunos"] ?? 0,
      cargaHorariaEfetiva: json["carga_horaria_efetiva"] ?? 0,
      
      // Campos de texto podem ser nulos, então está tudo bem
      professorNome: json["professor_nome"],
      disciplinaNome: json["disciplina_nome"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "professor_id": professorId,
        "disciplina_id": disciplinaId,
        "ano": ano,
        "semestre": semestre,
        "numero_alunos": numeroAlunos,
        "carga_horaria_efetiva": cargaHorariaEfetiva,
      };
}
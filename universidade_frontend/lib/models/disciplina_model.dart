import 'dart:convert';

List<Disciplina> disciplinaFromJson(String str) => List<Disciplina>.from(json.decode(str).map((x) => Disciplina.fromJson(x)));

class Disciplina {
  final int? id;
  final String codigoDisciplina;
  final String nome;
  final int cargaHoraria;

  Disciplina({
    this.id,
    required this.codigoDisciplina,
    required this.nome,
    required this.cargaHoraria,
  });

  // FÁBRICA DE CONSTRUÇÃO À PROVA DE FALHAS
  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      id: json["id"],
      codigoDisciplina: json["codigo_disciplina"] ?? '',
      // CORREÇÃO: Se 'nome' for nulo, usa uma string vazia ''
      nome: json["nome"] ?? '',
      // Boa prática: Adicionar a mesma proteção para o campo numérico
      cargaHoraria: json["carga_horaria"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo_disciplina": codigoDisciplina,
        "nome": nome,
        "carga_horaria": cargaHoraria,
      };
}
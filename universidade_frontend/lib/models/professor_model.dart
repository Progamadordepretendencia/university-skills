import 'dart:convert';

List<Professor> professorFromJson(String str) => List<Professor>.from(json.decode(str).map((x) => Professor.fromJson(x)));

class Professor {
  final int? id;
  final String nome;
  final String email;
  final DateTime dataContratacao;

  Professor({
    this.id,
    required this.nome,
    required this.email,
    required this.dataContratacao,
  });

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
        id: json["id"],
        nome: json["nome"],
        email: json["email"],
        dataContratacao: DateTime.parse(json["data_contratacao"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "email": email,
        "data_contratacao": dataContratacao.toIso8601String(),
      };
}
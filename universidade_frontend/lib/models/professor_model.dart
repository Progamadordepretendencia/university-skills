// lib/models/professor_model.dart
import 'dart:convert';

List<Professor> professorFromJson(String str) => List<Professor>.from(json.decode(str).map((x) => Professor.fromJson(x)));

class Professor {
  // 1. CORREÇÃO: O ID PRECISA ser nullable (com '?')
  // para representar um professor que ainda não foi salvo no banco.
  final int? id;
  final String nome;
  final String email;
  final DateTime dataContratacao;

  Professor({
    // 2. CORREÇÃO: O 'id' se torna um parâmetro opcional no construtor.
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
        // Formato ISO 8601 é universal e mais robusto para APIs
        "data_contratacao": dataContratacao.toIso8601String(),
      };
}
// lib/models/professor_model.dart
import 'dart:convert';

// Função para decodificar uma lista de professores a partir de uma string JSON
List<Professor> professorFromJson(String str) => List<Professor>.from(json.decode(str).map((x) => Professor.fromJson(x)));

class Professor {
    final int id;
    final String nome;
    final String email;
    final DateTime dataContratacao;

    Professor({
        required this.id,
        required this.nome,
        required this.email,
        required this.dataContratacao,
    });

    // Factory constructor para criar uma instância de Professor a partir de um mapa (JSON)
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
        // Formata a data para o padrão YYYY-MM-DD que a API espera
        "data_contratacao": "${dataContratacao.year.toString().padLeft(4, '0')}-${dataContratacao.month.toString().padLeft(2, '0')}-${dataContratacao.day.toString().padLeft(2, '0')}",
    };
}

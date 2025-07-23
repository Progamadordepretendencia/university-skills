// lib/models/disciplina_model.dart
import 'dart:convert';

// Helper para decodificar uma lista de disciplinas a partir de um JSON
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

  // Construtor factory para criar uma Disciplina a partir de um mapa JSON
  factory Disciplina.fromJson(Map<String, dynamic> json) => Disciplina(
        id: json["id"],
        codigoDisciplina: json["codigo_disciplina"],
        nome: json["nome"],
        cargaHoraria: json["carga_horaria"],
      );

  // Método para converter o objeto Disciplina para um mapa JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo_disciplina": codigoDisciplina,
        "nome": nome,
        "carga_horaria": cargaHoraria,
      };
}

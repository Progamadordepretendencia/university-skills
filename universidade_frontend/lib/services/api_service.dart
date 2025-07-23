// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/professor_model.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // --- MÉTODO EXISTENTE ---
  Future<List<Professor>> fetchProfessores() async {
    final response = await http.get(Uri.parse('$_baseUrl/professores'));

    if (response.statusCode == 200) {
      // Usar utf8.decode para garantir a correta interpretação de caracteres especiais
      final String responseBody = utf8.decode(response.bodyBytes);
      return professorFromJson(responseBody);
    } else {
      throw Exception('Falha ao carregar os professores da API');
    }
  }

  // --- NOVOS MÉTODOS ---

  // 1. CRIAR um novo professor (POST)
  Future<Professor> createProfessor(Professor professor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/professores'),
      headers: _headers,
      body: jsonEncode(professor.toJson()), // Converte o objeto Professor para JSON
    );

    if (response.statusCode == 201) {
      // A API retorna o ID do novo professor, então podemos retornar o objeto completo
      final responseBody = jsonDecode(response.body);
      // Retornamos um novo objeto Professor com o ID que o banco de dados gerou
      return Professor.fromJson(responseBody['createdProfessor']);
    } else {
      throw Exception('Falha ao criar professor. Status: ${response.statusCode}');
    }
  }

  // 2. ATUALIZAR um professor existente (PUT)
  Future<void> updateProfessor(Professor professor) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/professores/${professor.id}'),
      headers: _headers,
      body: jsonEncode(professor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar professor. Status: ${response.statusCode}');
    }
  }

  // 3. DELETAR um professor (DELETE)
  Future<void> deleteProfessor(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/professores/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar professor. Status: ${response.statusCode}');
    }
  }
}

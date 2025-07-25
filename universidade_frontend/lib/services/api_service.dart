import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/disciplina_model.dart';
import '../models/historico_model.dart';
import '../models/professor_model.dart';
import '../models/turma_model.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // --- MÉTODOS PARA PROFESSORES ---
  Future<List<Professor>> fetchProfessores() async {
    final response = await http.get(Uri.parse('$_baseUrl/professores'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return professorFromJson(responseBody);
    } else {
      throw Exception('Falha ao carregar os professores da API');
    }
  }

  Future<Professor> createProfessor(Professor professor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/professores'),
      headers: _headers,
      body: jsonEncode(professor.toJson()),
    );
    if (response.statusCode == 201) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return Professor.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Falha ao criar professor. Status: ${response.statusCode}');
    }
  }

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

  Future<void> deleteProfessor(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/professores/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar professor. Status: ${response.statusCode}');
    }
  }

  // --- MÉTODOS PARA DISCIPLINAS ---
  Future<List<Disciplina>> fetchDisciplinas() async {
    final response = await http.get(Uri.parse('$_baseUrl/disciplinas'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return disciplinaFromJson(responseBody);
    } else {
      throw Exception('Falha ao carregar as disciplinas');
    }
  }

  Future<Disciplina> createDisciplina(Disciplina disciplina) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/disciplinas'),
      headers: _headers,
      body: jsonEncode(disciplina.toJson()),
    );
    if (response.statusCode == 201) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return Disciplina.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Falha ao criar disciplina');
    }
  }

  Future<void> updateDisciplina(Disciplina disciplina) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/disciplinas/${disciplina.id}'),
      headers: _headers,
      body: jsonEncode(disciplina.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar disciplina');
    }
  }

  Future<void> deleteDisciplina(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/disciplinas/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar disciplina');
    }
  }

  // --- MÉTODOS PARA APTIDÕES ---
  Future<List<Disciplina>> fetchAptidoes(int professorId) async {
    final response = await http.get(Uri.parse('$_baseUrl/professores/$professorId/aptidoes'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return disciplinaFromJson(responseBody);
    } else {
      throw Exception('Falha ao carregar aptidões');
    }
  }

  Future<void> addAptidao(int professorId, int disciplinaId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/professores/$professorId/aptidoes'),
      headers: _headers,
      body: jsonEncode({'disciplina_id': disciplinaId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao adicionar aptidão');
    }
  }

  Future<void> removeAptidao(int professorId, int disciplinaId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/professores/$professorId/aptidoes/$disciplinaId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao remover aptidão');
    }
  }

  // --- MÉTODOS PARA TURMAS ---
  Future<List<Turma>> fetchTurmas() async {
    final response = await http.get(Uri.parse('$_baseUrl/turmas'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return turmaFromJson(responseBody);
    } else {
      throw Exception('Falha ao carregar as turmas');
    }
  }

  Future<Turma> createTurma(Turma turma) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/turmas'),
      headers: _headers,
      body: jsonEncode(turma.toJson()),
    );
    if (response.statusCode == 201) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return Turma.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Falha ao criar turma');
    }
  }

  Future<void> updateTurma(Turma turma) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/turmas/${turma.id}'),
      headers: _headers,
      body: jsonEncode(turma.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar turma');
    }
  }

  Future<void> deleteTurma(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/turmas/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar turma');
    }
  }

  // --- MÉTODO PARA CONSULTA (ITEM E) ---
  Future<List<Professor>> fetchProfessoresAptos(int disciplinaId) async {
    final response = await http.get(Uri.parse('$_baseUrl/disciplinas/$disciplinaId/professores-aptos'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return professorFromJson(responseBody);
    } else {
      throw Exception('Falha ao buscar professores aptos');
    }
  }

  // --- MÉTODO PARA CONSULTA (ITEM F) ---
  Future<List<Historico>> fetchProfessorHistorico(int professorId) async {
    final response = await http.get(Uri.parse('$_baseUrl/professores/$professorId/historico'));
    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      return historicoFromJson(responseBody);
    } else {
      throw Exception('Falha ao buscar histórico do professor');
    }
  }
}
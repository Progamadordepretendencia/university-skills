// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import '../models/professor_model.dart';

class ApiService {
  // A URL base da nossa API rodando no Docker
  static const String _baseUrl = 'http://localhost:3000/api';

  // Método para buscar a lista de professores
  Future<List<Professor>> fetchProfessores() async {
    final response = await http.get(Uri.parse('$_baseUrl/professores'));

    if (response.statusCode == 200) {
      // Se a requisição foi bem-sucedida (status 200 OK),
      // decodifica o JSON e retorna a lista de professores.
      // O utf8.decode é importante para lidar com acentuação (ex: João).
      final List<Professor> professores = professorFromJson(response.body);
      return professores;
    } else {
      // Se a requisição falhou, lança uma exceção.
      throw Exception('Falha ao carregar os professores da API');
    }
  }
}

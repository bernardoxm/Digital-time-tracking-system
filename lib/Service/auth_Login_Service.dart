import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ponto/utils/apiRoutes.dart';

class AuthService {
  static String? accessToken;
  static String? userId;
  static String? profileID;
  Future<Map<String, String>?> login(String email, String password) async {
    final url = Uri.parse('$APIROUTES/signin');
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        accessToken = responseData['access_token'];
        userId = responseData['user']['_id'];

        if (accessToken is String && userId is String) {
          return {
            'access_token': accessToken!,
            'id': userId!,
          };
        } else {
          throw Exception('Resposta do servidor inválida');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token incorreto');
      } else if (response.statusCode == 500) {
        throw Exception('Erro ao comunicar com servidor');
      } else {
        throw Exception('Falha ao fazer login');
      }
    } catch (error) {
      print('Erro na requisição: $error');
      return null;
    }
  }

  static void logout() {}
}

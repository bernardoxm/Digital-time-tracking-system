import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/utils/apiRoutes.dart';

class EmployerService {
  static String employerID = '';

  Future<void> fetchEmployer() async {
    final token = AuthService.accessToken;
    final idUser = AuthService.userId;

    if (token == null || idUser == null) {
      print('Token ou ID de usuário não disponíveis');
      return;
    }

    final url = '$APIROUTES/employee?user=$idUser';

    final headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          employerID = data['items'][0]['_id'];
          print('Employer ID: $employerID');
        } else {
          employerID = ''; // Limpar o employerID se a resposta estiver vazia
          print('ID do empregador não encontrado na resposta');
        }
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  static void clearEmployerID() {
    employerID = '';
  }
}

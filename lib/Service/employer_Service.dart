import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/model/employerRep.dart';

import '../model/usuario.dart';
import '../utils/apiRoutes.dart';

class EmployerService {
  static String? employerID;
  Future<Employerrep?> fetchEmployer(String token, String idUser) async {
    final token = AuthService.accessToken;
    final idUser = AuthService.userId;

    try {
      if (token == null || idUser == null) {
        print('Token ou ID de usuário não disponíveis');
        return null;
      }

      final url = '$APIROUTES/employee?user=$idUser';

      final headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Employerrep(
          employerID: data['_id'],

          // Adicione outros campos conforme necessário
        );
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}

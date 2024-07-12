import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/auth_user_Service.dart';
// Garanta que AuthService esteja no local correto

class ApiPontoService {
  static const String baseUrl =
      'https://api-my-company.vercel.app/api/v1/punch-clock';

  Future<bool> sendPunchClock(String punchClockDate, String employeeId) async {
    final token = AuthService.accessToken;
    final profileID = AuthService.profileID;
    if (token == null && profileID == null) {
      print('Token de autenticação não disponível ou ID do Perfil esta nulo');
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Utiliza o token para autenticação
        },
        body: jsonEncode({
          'punchClockDate': punchClockDate,
          'employee': profileID,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Error sending punch: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception sending punch clock: $e');
      return false;
    }
  }
}

// API SE COMUNICA COM A API DE PONTO PUNCH_CLOCK
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/employer_Service.dart';
import 'package:ponto/utils/apiRoutes.dart';

class ApiPontoService {
  static bool? ValidateAPIpontoService = false;
  static String baseUrl = '$APIROUTES/punch-clock';

  Future<bool> sendPunchClock(DateTime punchClockDate) async {
    final token = AuthService.accessToken;
    final employerID = EmployerService.employerID;

    if (token == null || employerID == null) {
      print('Token de autenticação não disponível ou ID do Perfil está nulo');
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'punchClockDate': punchClockDate.toIso8601String(),
          'employee': employerID,
        }),
      );

      print('EmployerID: $employerID');
      print('Response: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ValidateAPIpontoService = true;
        return true;
      } else {
        print('Error sending punch: ${response.body}');
        ValidateAPIpontoService = false;
        return false;
      }
    } catch (e) {
      print('Exception sending punch clock: $e');
      ValidateAPIpontoService = false;
      return false;
    }
  }
}

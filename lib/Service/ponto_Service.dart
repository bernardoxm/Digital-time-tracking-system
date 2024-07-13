import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/auth_user_Service.dart';
import 'package:ponto/Service/employer_Service.dart';
import 'package:ponto/utils/apiRoutes.dart';

class ApiPontoService {
  static bool? ValidateAPIpontoService;
  static String baseUrl = '$APIROUTES/punch-clock';

  Future<bool> sendPunchClock(DateTime punchClockDate, String profileID) async {
    final token = AuthService.accessToken;
    final employerID = EmployerService.employerID;

    if (token == null || profileID == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ValidateAPIpontoService = true;
      } else {
        print('Error sending punch: ${response.body}');
        return ValidateAPIpontoService = false;
      }
    } catch (e) {
      print('Exception sending punch clock: $e');
      return ValidateAPIpontoService = false;
    }
  }
}

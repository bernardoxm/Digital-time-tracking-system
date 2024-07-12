import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' as core;
import 'package:http/http.dart' as http;
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/auth_user_Service.dart';
import 'package:ponto/utils/apiRoutes.dart';

class ApiPontoService {
  static String baseUrl = '$APIROUTES/punch-clock';

  Future<bool> sendPunchClock(
      DateTime punchClockDate, String employeeId) async {
    final token = AuthService.accessToken;

    if (token == null || employeeId == null) {
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
          'employee': employeeId,
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

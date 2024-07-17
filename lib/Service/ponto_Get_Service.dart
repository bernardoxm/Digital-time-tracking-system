import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/employer_Service.dart';
import 'package:ponto/model/ponto_model.dart';

import '../utils/apiRoutes.dart';

class PontoGetService {
  Future<List<PontoModel>?> fetchPontosDoDia() async {
    final token = AuthService.accessToken;
    final employerID = EmployerService.employerID;

    if (token == null || employerID == '') {
      print('Token ou ID de usuário não disponíveis');
      return null;
    }else{ final url = '$APIROUTES/punch-clock?employee=$employerID';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final now = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(now);

        // Certifique-se de que a chave correta para a lista de pontos está sendo usada
        final List<dynamic> pontosList = data['items'];

        // Filtrar pontos do dia atual
        final pontosDoDia = pontosList.where((item) {
          final pontoDate = DateTime.parse(item['punchClockDate']);
          return DateFormat('yyyy-MM-dd').format(pontoDate) == todayStr;
        }).map((item) => PontoModel.fromJson(item)).toList();

        return pontosDoDia;
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    return null;}

   
  }
}

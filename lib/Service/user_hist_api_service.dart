import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ponto/model/hist_model_user.dart';

class UserHistApiService {
  Future<List<HistModelUser>?> fetchHistData(String employeeId, String token) async {
    final url = 'https://api-my-company.vercel.app/api/v1/punch-clock?employee=$employeeId';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> items = data['items'];
        return items.map((item) => HistModelUser.fromJson(item)).toList();
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    return null;
  }
}

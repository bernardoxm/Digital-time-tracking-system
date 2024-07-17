import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ponto/Service/employer_Service.dart';
import 'package:ponto/controller/ponto_notifier.dart';
import 'package:ponto/utils/apiRoutes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool isAuth = true;
  static String? accessToken;
  static String? userId;
  static String? profileID;
  static String nome = '';
  String? email;
  String? password;

  Future<Map<String, String>?> login(String email, String password, BuildContext context) async {
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
        nome = responseData['user']['fullName'];
        isAuth = true;

        // Limpar dados do usuário anterior
        final pontoNotifier = Provider.of<PontoNotifier>(context, listen: false);
        await logout(pontoNotifier);

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

  static Future<void> logout(PontoNotifier pontoNotifier) async {
  

    // Limpar dados do SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Limpar employerID
    EmployerService.clearEmployerID();

    // Limpar dados do pontoNotifier
    pontoNotifier.clearData();
  }
}

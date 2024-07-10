import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/auth_user_Service.dart';

import '../model/usuario.dart';

class UsuarioRep {
  static List<Usuario> tabela = [];

  static Future<void> fetchAndAddUser(String token, String userId) async {
    final token = AuthService.accessToken;
    final idUser = AuthService.userId;

    if (token == null || idUser == null) {
      print('Token ou ID de usuário não disponíveis');
      return;
    }

    UserService userService = UserService();
    Usuario? user = await userService.fetchUser(token, idUser);
    if (user != null) {
      tabela.add(user);
      print(user);
    } else {
      print('Failed to fetch user data.');
    }
  }

  static fetchUser(String token, String userId) {}
}

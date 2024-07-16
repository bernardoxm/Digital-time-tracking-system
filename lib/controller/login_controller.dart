//FAZ O CONTROLLE DO LOGIN DO USUARIO DIGITACAO E AXILIO DO ERRO 
class LoginController {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor, insira um email';
    } else if (!_isEmailValid(email)) {
      return 'Email inválido';
    }
    return null;
  }

  static bool _isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Por favor, insira uma senha';
    } else if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static bool isEmailAndPasswordValid(String email, String password) {
    return _isEmailValid(email) && password.length >= 6;
  }
}

import 'package:flutter/material.dart';
import 'package:ponto/controller/autenticador_Acesso.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Service/auth_Login_Service.dart';
import '../controller/local_auth.dart';
import '../controller/login_controller.dart';
import '../routes/routes.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocalAuthController _authController = LocalAuthController();
  bool _isLoading = false;
  bool _showInput = false;
  bool _isChecked = false;
  late String _email;
  late String _password;
  bool _obscureText = true; // Controla a visibilidade da senha

  bool get isLoading => _isLoading;
  bool get showInput => _showInput;
  bool get isChecked => _isChecked;
  String get email => _email;
  String get password => _password;
  bool get obscureText => _obscureText; // Getter para o estado da senha

  void toggleShowInput() {
    _showInput = !_showInput;
    notifyListeners();
  }

  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isChecked = prefs.getBool('keepLoggedIn') ?? false;
    if (_isChecked) {
      _email = prefs.getString('email') ?? '';
      _password = prefs.getString('password') ?? '';
    }
    notifyListeners();
  }

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepLoggedIn', _isChecked);
    if (_isChecked) {
      await prefs.setString('email', _email);
      await prefs.setString('password', _password);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }

    // Salvar informações biométricas se disponível
    bool hasBiometrics = await _authController.checkBiometrics();
    if (_isChecked && hasBiometrics) {
      await prefs.setBool('hasBiometrics', true);
      // Aqui você pode salvar mais informações biométricas, se necessário
    } else {
      await prefs.remove('hasBiometrics');
    }
  }

  Future<bool> validateAccess(BuildContext context) async {
    if (_email.isEmpty || _password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail e senha são obrigatórios.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      bool hasBiometrics = await _authController.checkBiometrics();
      bool authenticated = true;
      if (hasBiometrics) {
        authenticated = await _authController.authenticate();
      }

      if (LoginController.isEmailAndPasswordValid(_email, _password) &&
          authenticated) {
        final response = await _authService.login(_email, _password);

        if (response != null) {
          print(response);

          if (_isChecked) {
            await savePreferences();
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('keepLoggedIn');
            prefs.remove('email');
            prefs.remove('password');
            prefs.remove('hasBiometrics');
          }

          _isLoading = false;
          notifyListeners();
          return true; // Retorna true apenas se a autenticação e a API forem bem-sucedidas
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Erro ao fazer login. Usuario não encontrado na base'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não autenticado. Não foi possível efetuar o Login.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro durante a autenticação. E-mail ou senha incorretos.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleShowPassword() {
    _obscureText = !_obscureText; // Alterna a visibilidade da senha
    notifyListeners();
  }

  IconData get showPasswordIcon =>
      _obscureText ? Icons.visibility_off : Icons.visibility; // Ícone da senha
}

final AuthService authService = AuthService();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        builder: (context, _) => const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final double fontSizeall = MediaQuery.of(context).size.width * 0.04;
    final double widthbox = MediaQuery.of(context).size.width * 0.9;

    return Center(
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!provider.isLoading)
                //  Text(
                //     'Ponto Digital',
                //     style: TextStyle(
                //      fontSize: MediaQuery.of(context).size.width * 0.05,
                //      color: Colors.black,
                //   ),
                // ),
                const SizedBox(height: 10),
              if (!provider.isLoading)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    ("lib/assets/image/logo.png"),
                  ),
                ),
              //const SizedBox(height: 10),
              if (provider.showInput)
                if (!provider.isLoading) emailTextForm(widthbox, provider),
              const SizedBox(height: 10),
              if (provider.showInput)
                if (!provider.isLoading) senhaTextForm(widthbox, provider),
              if (provider.showInput)
                if (!provider.isLoading)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Checkbox(
                          activeColor: Color.fromARGB(255, 0, 191, 99),
                          checkColor: Color.fromARGB(255, 0, 191, 99),
                          hoverColor: Color.fromARGB(255, 0, 191, 99),
                          fillColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255),
                          ),
                          value: provider.isChecked,
                          onChanged: (bool? value) {
                            provider.setChecked(value ?? false);
                          },
                        ),
                        Text(
                          'Mantenha-me conectado',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
              if (provider.isLoading)
                AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Logo no centro da tela
                      Image.asset(
                        "lib/assets/image/logo.png",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),

                      // Indicador de progresso centralizado sobre a logo
                      const SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 191, 99)),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!provider.showInput)
                if (!provider.isLoading)
                  loginShowObjects(widthbox, fontSizeall, provider),
              const SizedBox(height: 10),
              if (provider.showInput)
                Container(
                  width: widthbox,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 191, 99),
                    border: Border.all(
                      color: Color.fromARGB(255, 0, 191, 99),
                      width: 0.9,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      bool isValid = await provider.validateAccess(context);
                      if (isValid) {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ValidadorAcessos(
                                  onCodeValidated: (code) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.NAVIGATORBARMENU,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: fontSizeall,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginShowObjects(
      double widthbox, double fontSizeall, AuthProvider provider) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: widthbox,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 191, 99),
        border: Border.all(
          color: Color.fromARGB(255, 0, 191, 99),
          width: 0.9,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextButton(
        onPressed: () {
          provider.toggleShowInput();
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: fontSizeall,
          ),
        ),
      ),
    );
  }

  Widget emailTextForm(double widthbox, AuthProvider provider) {
    return SizedBox(
      width: widthbox,
      child: TextFormField(
        onChanged: (value) {
          provider.setEmail(value);
        },
        validator: (value) {
          return LoginController.validateEmail(value!);
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: 'E-mail',
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide:
                BorderSide(width: 0.1, color: Color.fromARGB(255, 0, 191, 99)),
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget senhaTextForm(double widthbox, AuthProvider provider) {
    return SizedBox(
      width: widthbox,
      child: TextFormField(
        onChanged: (value) {
          provider.setPassword(value);
        },
        validator: (value) {
          return LoginController.validatePassword(value!);
        },
        obscureText: provider.obscureText, // Usa o estado da senha do provider
        decoration: InputDecoration(
          hintText: 'Senha',
          prefixIcon: Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: () {
              provider.toggleShowPassword(); // Chama o método no provider
            },
            icon: Icon(provider.showPasswordIcon), // Usa o ícone do provider
          ),
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide:
                BorderSide(width: 0.1, color: Color.fromARGB(255, 0, 191, 99)),
          ),
          filled: true,
        ),
      ),
    );
  }
}

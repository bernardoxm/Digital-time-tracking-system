// CONTROLLER DE LOLGIN, ONDE APOS O LOGIN ELE IRA CHAMAR O VALIDADOR DE ACESSO. 
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  bool showInput = false;
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  late String _email;
  // ignore: unused_field
  late String _password;

  @override
  Widget build(BuildContext context) {
    final double fontSizeall = MediaQuery.of(context).size.width * 0.04;
    final double widthbox = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ponto Digital',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 150,
                  height: 150,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/image/logo.png"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 20),
                if (showInput) email_Textform(widthbox),
                const SizedBox(height: 10),
                if (showInput) senha_TextForm(widthbox),
                if (showInput)
                  Row(
                    children: [
                      const SizedBox(width: 50),
                      Checkbox(
                        activeColor: Colors.black,
                        checkColor: const Color.fromARGB(255, 0, 0, 0),
                        hoverColor: Colors.black,
                        fillColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text('Mantenha-me conectado'),
                    ],
                  ),
                if (!showInput) login_Show_Objects(widthbox, fontSizeall),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Exibir o AlertDialog com o ValidadorAcessos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: ValidadorAcessos(
                            onCodeValidated: (code) {
                              Navigator.of(context).pop();
                              // Aqui você pode executar ação após a validação do código
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Exibir Validador'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// ignore: non_constant_identifier_names
  Container login_Show_Objects(double widthbox, double fontSizeall) {
    return Container(
      width: widthbox,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 173, 173, 173),
        border: Border.all(
          color: Colors.black,
          width: 0.1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            showInput = !showInput;
          });
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: fontSizeall),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox email_Textform(double widthbox) {
    return SizedBox(
      width: widthbox,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _email = value;
          });
        },
        validator: (value) {
          // Adicione sua validação de e-mail aqui
          return null;
        },
        decoration: const InputDecoration(
          hintText: 'E-mail',
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(width: 0.1, color: Colors.black),
          ),
          filled: true,
        ),
      ),
    );
  }
// ignore: non_constant_identifier_names
  SizedBox senha_TextForm(double widthbox) {
    return SizedBox(
      width: widthbox,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _password = value;
          });
        },
        validator: (value) {
          // Adicione sua validação de senha aqui
          return null;
        },
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Senha',
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(width: 0.1, color: Colors.black),
          ),
          filled: true,
        ),
      ),
    );
  }
}

// Widget ValidadorAcessos
class ValidadorAcessos extends StatefulWidget {
  final Function(String) onCodeValidated;

  const ValidadorAcessos({super.key, required this.onCodeValidated});

  @override
  // ignore: library_private_types_in_public_api
  _ValidadorAcessosState createState() => _ValidadorAcessosState();
}

class _ValidadorAcessosState extends State<ValidadorAcessos> {
  final TextEditingController _codeController = TextEditingController();
  
  // ignore: unused_field
  bool _isValidCode = false;
  String? _errorText;

  void _validateCode() {
    setState(() {
      _errorText = null; // Limpar qualquer erro anterior
    });

    // Simulação de validação de código (substitua pela lógica real)
    if (_codeController.text == '1234') {
      setState(() {
        _isValidCode = true;
      });
      widget.onCodeValidated(_codeController.text);
    } else {
      setState(() {
        _isValidCode = false;
        _errorText = 'Código inválido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Validação de Acesso',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          decoration: InputDecoration(
            labelText: 'Digite o código fornecido pela empresa',
            errorText: _errorText,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: _validateCode,
            child: const Text(
              'Validar',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o AlertDialog
            },
            child: const Text(
              'Voltar',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


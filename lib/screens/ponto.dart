import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ponto/Service/ponto_Service.dart';
import 'package:ponto/controller/local_auth.dart';
import 'package:ponto/model/employerRep.dart';
import 'package:ponto/model/usuario.dart';
import 'package:ponto/screens/perfil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/ponto_notifier.dart';

class Ponto extends StatelessWidget {
  const Ponto({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalAuthController authController = LocalAuthController();

    return ChangeNotifierProvider(
      create: (_) => PontoNotifier(context),
      child: Consumer<PontoNotifier>(
        builder: (context, model, _) {
          final Usuario usuario = model.usuario;
          final Employerrep employerId = employerrep;

          var formatterDate = DateFormat('dd/MM/yyyy');
          var formatterTime = DateFormat('HH:mm', 'pt_BR');
          String formattedDate = formatterDate.format(model.now);
          String formattedTime = formatterTime.format(model.now);
          double buttompading = MediaQuery.of(context).size.height * 0.29;
          double fontSizeTime = MediaQuery.of(context).size.width * 0.23;

          _checkAndClearPoints(model);

          return Scaffold(
            body: model.isLoadingUser
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Indicador de progresso enquanto carrega os dados do usuário
                : SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 0, 191, 99),
                                  Color.fromARGB(255, 0, 191, 99),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Center(
                                  child: Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        PerfilPageState.isValidVoltar = true;
                                        Get.to(const PerfilPage());
                                      },
                                      child: model.isLoading
                                          ? const CircularProgressIndicator()
                                          : CircleAvatar(
                                              key: UniqueKey(),
                                              radius: 75,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  model.imageProvider,
                                              foregroundColor:
                                                  const Color.fromARGB(
                                                      0, 255, 255, 255),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      usuario.fullName,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.98,
                            height: MediaQuery.of(context).size.height * 0.23,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 0, 191, 99),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                ),
                                Text(
                                  Jiffy.now().format(pattern: 'EEEE'),
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: fontSizeTime,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(4, (index) {
                                Widget pontoWidget;
                                String pontoTexto;
                                String horaFormatada = '--:--';

                                switch (index) {
                                  case 0:
                                    pontoTexto = 'Entrada';
                                    break;
                                  case 1:
                                    pontoTexto = 'Almoço';
                                    break;
                                  case 2:
                                    pontoTexto = 'Volta Almoço';
                                    break;
                                  case 3:
                                    pontoTexto = 'Saída';
                                    break;
                                  default:
                                    pontoTexto = '--:--';
                                }

                                if (model.pontos[index] != null) {
                                  horaFormatada = DateFormat.Hm()
                                      .format(model.pontos[index]!);
                                }

                                pontoWidget = GestureDetector(
                                  onTap: () async {
                                    bool hasBiometrics =
                                        await authController.checkBiometrics();
                                    bool authenticated = true;

                                    if (hasBiometrics) {
                                      authenticated =
                                          await authController.authenticate();
                                    }

                                    if (authenticated) {
                                      model.registrarPonto(index, context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Não autenticado. O ponto não foi marcado.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: model.pontos[index] != null
                                          ? Color.fromARGB(255, 0, 191, 99)
                                          : Color.fromARGB(33, 0, 191, 99),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          pontoTexto,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: model.pontos[index] != null
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          horaFormatada,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: model.pontos[index] != null
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                return Row(
                                  children: [
                                    pontoWidget,
                                    if (index < 3) const SizedBox(width: 10),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.97,
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 0, 191, 99),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                bool hasBiometrics =
                                    await authController.checkBiometrics();
                                bool authenticated = true;

                                if (hasBiometrics) {
                                  authenticated =
                                      await authController.authenticate();
                                }

                                if (authenticated &&
                                    ApiPontoService.ValidateAPIpontoService ==
                                        true) {
                                  int index = model.pontos
                                      .indexWhere((element) => element == null);
                                  if (index != -1 && index < 4) {
                                    model.registrarPonto(index, context);

                                    // Obter a data e hora formatadas
                                    String formattedDate =
                                        formatterDate.format(model.now);
                                    String formattedTime =
                                        formatterTime.format(model.now);

                                    // Enviar para a API

                                    bool success =
                                        await ApiPontoService().sendPunchClock(
                                      '$formattedDate $formattedTime'
                                          as DateTime,
                                      employID.employerID,
                                    );

                                    if (success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ponto marcado com sucesso.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else if (ApiPontoService
                                            .ValidateAPIpontoService ==
                                        false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Erro ao enviar o ponto.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Você já marcou os 4 pontos hoje.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Não autenticado. O ponto não foi marcado.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Registrar ponto',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              model.limparPontos();
                            },
                            child: const Text('Limpar Pontos Para teste'),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _checkAndClearPoints(PontoNotifier model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastDateStr = prefs.getString('lastDate');
    final DateTime now = DateTime.now();
    final String todayStr = DateFormat('yyyy-MM-dd').format(now);

    if (lastDateStr != null && lastDateStr != todayStr) {
      model.limparPontos();
    }

    prefs.setString('lastDate', todayStr);
  }
}

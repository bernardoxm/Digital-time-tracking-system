import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/employer_Service.dart';
import 'package:ponto/Service/user_hist_api_service.dart';
import 'package:ponto/model/hist_model_user.dart';

class Comprovantes extends StatefulWidget {
  const Comprovantes({super.key});
  @override
  State<Comprovantes> createState() => _Comprovantes();
}

class _Comprovantes extends State<Comprovantes> {
  late Future<List<HistModelUser>?> _histData;

  @override
  void initState() {
    super.initState();
    // Substitua esses valores pelos reais
    final employeeId = EmployerService.employerID;
    final token = AuthService.accessToken;
    _histData = UserHistApiService().fetchHistData(employeeId, token!);
  }

  Map<String, List<HistModelUser>> _groupByDate(List<HistModelUser> data) {
    Map<String, List<HistModelUser>> groupedData = {};

    for (var item in data) {
      final date = DateFormat('yyyy-MM-dd').format(item.punchClockDate);
      if (groupedData.containsKey(date)) {
        groupedData[date]!.add(item);
      } else {
        groupedData[date] = [item];
      }
    }

    // Ordena os registros de cada dia por horário (checkTime)
    groupedData.forEach((date, punches) {
      punches.sort((a, b) => a.checkTime.compareTo(b.checkTime));
    });

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    double buttompading = MediaQuery.of(context).size.height * 0.14;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: buttompading,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 57, 146, 247),
                  Color.fromARGB(255, 0, 191, 99),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Comprovantes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<HistModelUser>?>(
              future: _histData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/image/logo.png",
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 191, 99)),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar os dados.'));
                } else if (snapshot.hasData) {
                  final histData = snapshot.data;
                  if (histData == null || histData.isEmpty) {
                    return const Center(child: Text('Nenhum dado encontrado.'));
                  }

                  final groupedData = _groupByDate(histData);

                  return ListView.builder(
                    itemCount: groupedData.keys.length,
                    itemBuilder: (context, index) {
                      final date = groupedData.keys.elementAt(index);
                      final punches = groupedData[date]!;

                      // Nomes definidos para cada horário
                      final titles = ["Entrada", "Almoço", "Volta do Almoço", "Saída"];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data: $date',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: punches.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final punch = entry.value;
                                final title = idx < titles.length ? titles[idx] : "Horário";

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(punch.checkTime),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Nenhum dado disponível.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

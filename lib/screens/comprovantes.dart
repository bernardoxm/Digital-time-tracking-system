import 'package:flutter/material.dart';

class Comprovantes extends StatefulWidget {
  const Comprovantes({super.key});
  @override
  State<Comprovantes> createState() => _Comprovantes();
}

class _Comprovantes extends State<Comprovantes> {
  @override
  Widget build(BuildContext context) {
    double buttompading = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
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
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(000),
              ),
            ),
            child: Center(
              child: Text(
                'Comprovantes',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

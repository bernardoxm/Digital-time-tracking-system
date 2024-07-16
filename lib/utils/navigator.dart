//NAVIGATOR E ONDE GERA O MENU FLUTUANTE NA APLICAO. 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ponto/controller/navigator_Controller.dart';
import 'package:ponto/controller/ponto_notifier.dart';
import 'package:ponto/repositorio/UsuarioRep.dart';
import 'package:ponto/screens/login.dart';
import 'package:provider/provider.dart';

class NavigatorBarMenu extends StatelessWidget {
  const NavigatorBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NaviController());
    final pontoNotifier = Provider.of<PontoNotifier>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 0, 191, 99),
                Color.fromARGB(255, 0, 191, 99),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: NavigationBar(
            indicatorColor: Color.fromARGB(255, 0, 245, 126),
            surfaceTintColor: Color.fromARGB(255, 0, 191, 99),
            overlayColor: MaterialStateProperty.all(Color.fromARGB(08, 0, 191, 99).withOpacity(0.2)),
            backgroundColor: Colors.transparent,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              if (index == 3) {
                UsuarioRep.tabela.clear();
                PontoNotifier.logout(pontoNotifier);
                Get.off(() => LoginPage());
              } else {
                controller.selectedIndex.value = index;
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white),
                label: 'Perfil',
              ),
              NavigationDestination(
                icon: Icon(Icons.alarm, color: Colors.white),
                label: 'Ponto',
              ),
              NavigationDestination(
                icon: Icon(Icons.document_scanner, color: Colors.white),
                label: 'Comprovantes',
              ),
              NavigationDestination(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                label: 'Sair',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}


import 'package:get/get.dart';
import 'package:ponto/screens/comprovantes.dart';
import 'package:ponto/screens/perfil.dart';
import 'package:ponto/screens/ponto.dart';

class NaviController extends GetxController {
  var selectedIndex = 1.obs;
  final screens = [
    const PerfilPage(),
    const Ponto(),
    const Comprovantes(),
  ];
}

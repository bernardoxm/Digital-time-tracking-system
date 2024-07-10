import 'package:get/get.dart';
import 'package:ponto/screens/ponto.dart';

class PerfilVoltarController extends GetxController {
  void voltarParaTelaAnterior() {
    Get.to(const Ponto());
  }
}

import 'package:get/get.dart';
import 'package:ponto/screens/ponto.dart';
//FAZ PARTE DO CONTROLLE GETX VOLTAR A PAGINA ANTERIOR PONTO.DART
class PerfilVoltarController extends GetxController {
  void voltarParaTelaAnterior() {
    Get.to(const Ponto());
  }
}

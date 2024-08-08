import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:intl/intl.dart';
import 'package:ponto/controller/autenticador_Acesso.dart';
import 'package:ponto/screens/ponto.dart';
import 'package:ponto/screens/videoScreen.dart';
import 'package:provider/provider.dart';

import 'controller/ponto_notifier.dart';
import 'routes/routes.dart';
import 'screens/comprovantes.dart';
import 'screens/perfil.dart';
import 'utils/navigator.dart';

void main() {
  // Define o locale padrão para pt_BR

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PontoNotifier(context), // Cria uma instância de PontoNotifier
      child: GetMaterialApp(
       
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        title: 'Ponto Digital',
        theme: ThemeData(        

          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(color: Colors.white),
            ),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          useMaterial3: true,
        ),
         home: const IntroVideoPage(),// INICIA O VIDEO QUE IRA CARREGAR A PAGINA DE LOGIN LOGO APOS O TERMINO.
            //GET PAGES REFERENTE A PAGINA QUE SERA CHAMADA UTILIZANDO O gETx
        getPages: [
          GetPage(name: AppRoutes.LOGIN, page: () => const LoginPage()),
          GetPage(name: AppRoutes.HOME, page: () => const Ponto()),
          GetPage(name: AppRoutes.PROFILE, page: () => const PerfilPage()),
          GetPage(
              name: AppRoutes.NAVIGATORBARMENU,
              page: () => const NavigatorBarMenu()),
          GetPage(
              name: AppRoutes.COMPROVANTES, page: () => const Comprovantes()),
                   GetPage(
              name: AppRoutes.VIDEOSCREEN, page: () => const IntroVideoPage()),
        ],
      ),
    );
  }
}

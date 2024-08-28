import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ponto/Service/Ponto_Get_Service.dart';
import 'package:ponto/Service/auth_Login_Service.dart';
import 'package:ponto/Service/auth_user_Service.dart';
import 'package:ponto/Service/ponto_Service.dart';
import 'package:ponto/controller/image_select.dart';
import 'package:ponto/controller/local_auth.dart';
import 'package:ponto/model/employer.dart';
import 'package:ponto/model/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontoNotifier extends ChangeNotifier {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _isLoadingImage = false;
  bool _isLoadingUser = true;
  File? _image;
  late ImageSelectController _imageSelectController;
  final LocalAuthController _authController = LocalAuthController();
  late Usuario _usuario = Usuario(fullName: '', email: '', profileID: '');
  late Employer _employer = Employer(employerID: '');
  late BuildContext _context;
  DateTime? _expiryDate;
  bool pontosDodiaIsloading = true;

  List<DateTime?> pontos = List.filled(4, null);

  PontoNotifier(this._context) {
    _imageSelectController = ImageSelectController();
    pontoExpiry();
    _initUsuario();
    _initImage();
    _loadPointsLocally();
    _employerlading();

    // Adicionado: Fetch pontos do dia atual
    fetchPontosDoDia(); 

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _now = DateTime.now();
      notifyListeners();
    });
  }

  ImageProvider? imageProvider;
  bool isLoading = true;

  void _initImage() async {
    await _imageSelectController.initSharedPreferences();
    File? savedImage = await _imageSelectController.getSavedImage();
    if (savedImage != null) {
      _image = savedImage;
      imageProvider = FileImage(savedImage);
    } else {
      imageProvider = const AssetImage("lib/assets/image/defaultprofile.png");
    }
    isLoading = false;
    notifyListeners();
  }

  void _employerlading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employerID = prefs.getString('employer');
    if (employerID != null) {
      _employer = Employer(employerID: employerID);
      notifyListeners();
    }
  }

  void _initUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('userFullName');
    String? email = prefs.getString('userEmail');
    String? profileID = prefs.getString('profileID');

    if (fullName != null && email != null && profileID != null) {
      _usuario =
          Usuario(fullName: fullName, email: email, profileID: profileID);
      _isLoadingUser = false;
      notifyListeners();
    } else {
      final userService = UserService();
      final token = AuthService.accessToken;
      final idUser = AuthService.userId;

      if (token != null && idUser != null) {
        _usuario = (await userService.fetchUser(token, idUser))!;
        _saveUserToPrefs(_usuario);
      } else {
        _usuario = Usuario(
            fullName: 'ERRO GET USER',
            email: 'ERRO GET USER',
            profileID: 'ERRO GET ID');
      }

      _isLoadingUser = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs(Usuario usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userFullName', usuario.fullName);
    await prefs.setString('userEmail', usuario.email);
    await prefs.setString('profileID', usuario.profileID);
  }

  DateTime? lastPontoTime;

  File? get image => _image;
  DateTime get now => _now;
  Usuario get usuario => _usuario;
  Employer get employer => _employer;
  bool get isLoadingImage => _isLoadingImage;
  bool get isLoadingUser => _isLoadingUser;

  Future<void> pickImage(BuildContext context) async {
    _isLoadingImage = true;
    notifyListeners();

    File? pickedImage = await _imageSelectController.pickImage(context);
    if (pickedImage != null) {
      _image = pickedImage;
      imageProvider = FileImage(pickedImage);
    }

    _isLoadingImage = false;
    notifyListeners();
  }

  void registrarPonto(int index, BuildContext context) {
    if (pontos.where((element) => element != null).length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Você já marcou os 4 pontos hoje.'),
            duration: Duration(seconds: 2)),
      );
      return;
    }

    if (pontos[index] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Este ponto já foi marcado.'),
            duration: Duration(seconds: 2)),
      );
      return;
    }

    if (lastPontoTime != null && now.difference(lastPontoTime!).inMinutes < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Você precisa esperar pelo menos 1 minuto para marcar o próximo ponto.'),
            duration: Duration(seconds: 2)),
      );
      return;
    }

    pontos[index] = DateTime.now();
    lastPontoTime = now;
    notifyListeners();
    _savePointsLocally();
  }

  bool pontoExpiry() {
    final validadePonto = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return validadePonto;
  }

  void limparPontos() {
    pontos = List.filled(4, null);
    _savePointsLocally();
    notifyListeners();
  }

  Future<void> _savePointsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pontosJson = pontos
        .map((point) => point != null ? point.toIso8601String() : '')
        .toList();
    await prefs.setStringList('pontos', pontosJson);
  }

  Future<void> _loadPointsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pontosJson = prefs.getStringList('pontos');
    pontos = pontosJson
            ?.map((point) => point.isNotEmpty ? DateTime.parse(point) : null)
            .toList() ??
        List.filled(4, null);
    notifyListeners();
  }

  Future<void> fetchPontosDoDia() async {
    pontosDodiaIsloading = true;
    notifyListeners();

    final pontosList = await PontoGetService().fetchPontosDoDia();
    if (pontosList != null && pontosList.isNotEmpty) {
      print('Pontos recebidos da API: $pontosList');
      
      // Ordenar os pontos por hora antes de atualizá-los
      pontosList.sort((a, b) => DateTime.parse(a.punchClockDate).compareTo(DateTime.parse(b.punchClockDate)));
      
      pontos = List.filled(4, null); // Reseta os pontos
      for (var i = 0; i < pontosList.length && i < 4; i++) {
        pontos[i] = DateTime.parse(pontosList[i].punchClockDate);
      }
    } else {
      print('Nenhum ponto recebido da API ou lista vazia.');
      limparPontos(); // Limpar pontos se a lista da API estiver vazia
    }

    pontosDodiaIsloading = false;
    notifyListeners();
  }

  void clearData() {
    _usuario = Usuario(fullName: '', email: '', profileID: '');
    _employer = Employer(employerID: '');
    limparPontos();
    _image = null;
    imageProvider = null;
    notifyListeners();
  }

  int getIndexFromStatus(String status) {
    switch (status) {
      case 'Entrada':
        return 0;
      case 'Almoço':
        return 1;
      case 'Volta Almoço':
        return 2;
      case 'Saída':
        return 3;
      default:
        return -1;
    }
  }

  Future<bool> checkApiAvailability() async {
    try {
      final response = await http.get(Uri.parse(ApiPontoService.baseUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }
    } catch (e) {
      print('Exception checking API availability: $e');
    }
    return false;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  static Future<void> logout(PontoNotifier instance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpar todos os dados do SharedPreferences

    instance.clearData();
  }
}

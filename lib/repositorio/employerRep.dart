// import 'package:ponto/Service/auth_Login_Service.dart';
// import 'package:ponto/model/employer.dart';

// class Employerrep {
//   static List<Employerrep> tabela = [];

//   static Future<void> fetchEmployer(String token, String userId) async {
//     final token = AuthService.accessToken;
//     final idUser = AuthService.userId;

//     if (token == null || idUser == null) {
//       print('Token ou ID de usuário não disponíveis');
//       return;
//     }

//     Employer  EmployerService = Employer(employerID: '');
//     Employerrep? idEmployer = await EmployerService.fetchEmployer(token, idUser);
//     if (idEmployer != null) {
//       tabela.add(idEmployer);
//       print(idEmployer);
//     } else {
//       print('Failed to fetch user data.');
//     }
//   }

//   static fetchUser(String token, String userId) {}
// }

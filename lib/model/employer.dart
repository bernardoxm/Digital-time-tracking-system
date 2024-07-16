//MODEL EMPLOYER RETORNO DO EMPREGADO
class Employer {
  String employerID;

  Employer({
    required this.employerID,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(employerID: json['items']['_id']);
  }

  fetchEmployer(String token, String idUser) {}
}

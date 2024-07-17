//MODEL USUARIO RETORNO DO USUARIO
class Usuario {
  String fullName;
  String email;
  String profileID;

  Usuario({
    required this.fullName,
    required this.email,
    required this.profileID,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      fullName: json['fullName'],
      email: json['email'],
      profileID: json['_id'],
    );
  }


}

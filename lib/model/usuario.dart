class Usuario {
  String fullName;
  String email;

  Usuario({
    required this.fullName,
    required this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      fullName: json['fullName'],
      email: json['email'],
    );
  }

  get nome => null;
}

class Employerrep {
  String employerID;

  Employerrep({
    required this.employerID,
  });

  factory Employerrep.fromJson(Map<String, dynamic> json) {
    return Employerrep(employerID: json['_id']);
  }
}

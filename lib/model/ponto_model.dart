class PontoModel {
  String status;
  String punchClockDate;
  String employee;
  String id;

  PontoModel({
    required this.status,
    required this.punchClockDate,
    required this.employee,
    required this.id,
  });

  factory PontoModel.fromJson(Map<String, dynamic> json) {
    return PontoModel(
      punchClockDate: json['punchClockDate'],
      employee: json['employee'],
      status: json['status'],
      id: json['_id'],
    );
  }

  static List<PontoModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PontoModel.fromJson(json)).toList();
  }
}

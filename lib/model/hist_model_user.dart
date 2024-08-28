class HistModelUser {
  final String id;
  final String account;
  final String employee;
  final DateTime punchClockDate;
  final String checkTime;
  final bool isManual;
  final String status;
  final DateTime createdAtDateTime;
  final DateTime updatedAtDateTime;

  HistModelUser({
    required this.id,
    required this.account,
    required this.employee,
    required this.punchClockDate,
    required this.checkTime,
    required this.isManual,
    required this.status,
    required this.createdAtDateTime,
    required this.updatedAtDateTime,
  });

  factory HistModelUser.fromJson(Map<String, dynamic> json) {
    return HistModelUser(
      id: json['_id'],
      account: json['account'],
      employee: json['employee'],
      punchClockDate: DateTime.parse(json['punchClockDate']),
      checkTime: json['checkTime'],
      isManual: json['isManual'],
      status: json['status'],
      createdAtDateTime: DateTime.parse(json['createdAtDateTime']),
      updatedAtDateTime: DateTime.parse(json['updatedAtDateTime']),
    );
  }
}

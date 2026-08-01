class Session {
  int? id;

  int deviceId;

  String deviceName;
  String deviceType;
  String guestName;

  DateTime startTime;
  DateTime endTime;

  int durationMinutes;
  double amount;

  bool isPaused;
  DateTime? pausedAt;

  DateTime createdAt;

  Session({
    this.id,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.guestName,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.amount,
    this.isPaused = false,
    this.pausedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'guestName': guestName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'amount': amount,
      'isPaused': isPaused ? 1 : 0,
      'pausedAt': pausedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Session.fromMap(
      Map<String, dynamic> map,
      ) {
    return Session(
      id: map['id'],
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
      guestName: map['guestName'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      durationMinutes: map['durationMinutes'],
      amount: (map['amount'] as num).toDouble(),
      isPaused: map['isPaused'] == 1,
      pausedAt: map['pausedAt'] != null
          ? DateTime.parse(map['pausedAt'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
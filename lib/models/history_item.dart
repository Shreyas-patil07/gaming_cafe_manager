class HistoryItem {
  int deviceId;

  String deviceName;
  String deviceType;

  DateTime startTime;
  DateTime endTime;

  int durationMinutes;
  double amount;

  HistoryItem({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'amount': amount,
    };
  }

  factory HistoryItem.fromMap(
      Map<String, dynamic> map,
      ) {
    return HistoryItem(
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
      startTime: DateTime.parse(
        map['startTime'],
      ),
      endTime: DateTime.parse(
        map['endTime'],
      ),
      durationMinutes:
      map['durationMinutes'],
      amount:
      (map['amount'] as num).toDouble(),
    );
  }
}
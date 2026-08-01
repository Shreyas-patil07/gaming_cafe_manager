class QueueItem {
  int? id;

  int deviceId;
  String deviceName;
  String deviceType;
  String guestName;

  int durationMinutes;
  double amount;

  DateTime queuedAt;

  QueueItem({
    this.id,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.guestName,
    required this.durationMinutes,
    required this.amount,
    required this.queuedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'guestName': guestName,
      'durationMinutes': durationMinutes,
      'amount': amount,
      'queuedAt': queuedAt.toIso8601String(),
    };
  }

  factory QueueItem.fromMap(
      Map<String, dynamic> map,
      ) {
    return QueueItem(
      id: map['id'],
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
      guestName: map['guestName'],
      durationMinutes: map['durationMinutes'],
      amount: map['amount'],
      queuedAt: DateTime.parse(
        map['queuedAt'],
      ),
    );
  }
}
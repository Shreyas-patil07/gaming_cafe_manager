class Device {
  int? id;

  String name;
  String type;

  double halfHourRate;
  bool isActive;

  DateTime? sessionStart;
  DateTime? sessionEnd;

  Device({
    this.id,
    required this.name,
    required this.type,
    required this.halfHourRate,
    required this.isActive,
    this.sessionStart,
    this.sessionEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'halfHourRate': halfHourRate,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Device.fromMap(
      Map<String, dynamic> map,
      ) {
    return Device(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      halfHourRate: map['halfHourRate'],
      isActive: map['isActive'] == 1,
    );
  }
}
enum MotorStatus {
  opened(0),
  closed(1),
  opening(2),
  closing(3),
  stopped(4),

  unknown(-1);

  const MotorStatus(this.statusNumber);
  final int statusNumber;

  static MotorStatus fromByte(int byte) =>
    MotorStatus.values.firstWhere((element) => element.statusNumber == byte, orElse: () => MotorStatus.unknown);
}

enum MotorType {
  table(1),
  slider(2),
  back(3),
  awning(4),
  floodgateGrey(5),
  floodgateBlack(6),

  unknown(-1);

  const MotorType(this.typeNumber);
  final int typeNumber;

  static MotorType fromByte(int byte) =>
    MotorType.values.firstWhere((element) => element.typeNumber == byte, orElse: () => MotorType.unknown);
}
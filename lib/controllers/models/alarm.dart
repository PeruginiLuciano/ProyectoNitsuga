import 'package:get/get.dart';

class Alarms {
  var waterPumperProtection = false.obs;
  var floodgateGreyProtection = false.obs;
  var floodgateBlackProtection = false.obs;
  var autoStartGeneratorProtection = false.obs;

  var generatorOnProtection = false.obs;
  var generatorPrimerProtection = false.obs;
  var lowVoltagePhaseOne = false.obs;
}

enum AlarmType {
  overCurrent(1),
  overVoltage(2),
  lowVoltage(3),
  protectionActivated(4),
  switchUpdate(5),
  lowVoltagePhaseOne(6),
  startingGenerator(7),

  none(-1);

  const AlarmType(this.alarmNumber);
  final int alarmNumber;

  static AlarmType fromByte(int byte) =>
      AlarmType.values.firstWhere((element) => element.alarmNumber == byte, orElse: () => AlarmType.none);
}

enum AlarmSource {
  exteriorLight(1),
  interiorLight(2),
  vaultLight(3),
  waterPumper(4),
  floodgateGrey(5),
  floodgateBlack(6),
  table(7),
  slider(8),
  back(9),
  awning(10),
  generatorOn(11),
  generatorOff(12),
  generatorPrimer(13),
  generic1(14),
  generic2(15),
  generic3(16),
  unknown(17),
  charger(18),
  inverter(19),
  motors(20),
  heater(21),

  undefined(-1);

  const AlarmSource(this.sourceNumber);
  final int sourceNumber;

  static AlarmSource fromByte(int byte) =>
      AlarmSource.values.firstWhere((element) => element.sourceNumber == byte, orElse: () => AlarmSource.undefined);
}

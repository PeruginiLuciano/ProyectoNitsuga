import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/utils/extensions.dart';

class Charger {
  var power = false;
  var mode = ChargerMode.standBy;
  var alarms = ChargerAlarms();
  var batteryLevel = 0;
  var current = 0.0;

  void updateModeAndAlarms(Packet packet) {
    mode = ChargerMode.fromByte(packet.byte5);
    alarms.updateFromByte(packet.byte1);
  }

  void updatePowerValue(Packet packet) {
    batteryLevel =
      packet.byte1.isBitSet(8) ? 4 :
      packet.byte1.isBitSet(7) ? 3 :
      packet.byte1.isBitSet(6) ? 2 :
      packet.byte1.isBitSet(5) ? 1 : 0;

    current = (packet.byte3 << 8 | packet.byte2).toDouble() / 10;
  }
}

enum ChargerMode {
  standBy(0),
  leadChargeMode(1),
  leadOrGelChargeMode(2),
  fullCharge(3),
  gelBatteryRecoveryMode(4),
  leadBatteryRecoveryMode(5),
  sourceMode12_2(6),
  sourceMode13_5(7),

  unknown(-1);

  const ChargerMode(this.modeNumber);
  final int modeNumber;

  static ChargerMode fromByte(int byte) =>
      ChargerMode.values.firstWhere((element) => element.modeNumber == byte, orElse: () => ChargerMode.unknown);
}

class ChargerAlarms {
  var globalError = false;
  var batteryHigh = false;
  var batteryLow = false;
  var overTemperature = false;
  var overLoad = false;

  void updateFromByte(int byte) {
    globalError = byte.isBitSet(8);
    batteryHigh = byte.isBitSet(7);
    batteryLow = byte.isBitSet(6);
    overTemperature = byte.isBitSet(5);
    overLoad = byte.isBitSet(4);
  }
}

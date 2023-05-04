import 'package:get/get.dart';
import 'package:motorhome/controllers/models/devices/caa10.dart';
import 'package:motorhome/controllers/models/devices/ctrlcal100.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Heater {
  var power = false.obs;
  var mode = HeaterMode.unknown.obs;
  var powerLevel = 1.obs; // 1 to 5
  var error = HeaterError.none.obs;

  void updateStatus(Packet packet) {
    var status = HeaterStatus.fromByte(packet.byte1);
    switch(status) {
      case HeaterStatus.status:
        power.value = packet.byte2 == 1;
        mode.value = HeaterMode.fromByte(packet.byte3);
        powerLevel.value = packet.byte4;
        break;
      case HeaterStatus.turnOnFail:
        var source = packet.byte1;
        power.value = false;
        break;
      case HeaterStatus.turnOffFail:
        var source = packet.byte1;
        power.value = true;
        break;
      case HeaterStatus.heaterReportedError:
        error.value = HeaterError.fromByte(packet.byte2);
        break;
      default:
    }
  }
}

enum HeaterStatus {
  status(1),
  turnOnFail(2),
  turnOffFail(3),
  heaterReportedError(4),

  unknown(-1);

  const HeaterStatus(this.statusNumber);
  final int statusNumber;

  static HeaterStatus fromByte(int byte) =>
      HeaterStatus.values.firstWhere((element) => element.statusNumber == byte, orElse: () => HeaterStatus.unknown);
}

enum HeaterMode {
  heat(1),
  ventilation(2),

  unknown(-1);

  const HeaterMode(this.modeNumber);
  final int modeNumber;

  static HeaterMode fromByte(int byte) =>
      HeaterMode.values.firstWhere((element) => element.modeNumber == byte, orElse: () => HeaterMode.unknown);

  Ctrlcal100mode toCtrlcal100mode() => this == HeaterMode.heat ? Ctrlcal100mode.heat : Ctrlcal100mode.ventilation;
}

enum HeaterError {
  batteryHigh(1),
  batteryLow(2),
  burnerSensor(3),
  airInputSensor(4),
  airOutputSensor(5),
  incandescenceSensor(6),
  fuelPumper(7),
  ventilation(8),
  ignition(10),
  burnerOverHeated(11),
  airOutputOverHeated(12),
  flameExtinction(13),
  communication(14),

  none(-1);

  const HeaterError(this.errorNumber);
  final int errorNumber;

  static HeaterError fromByte(int byte) =>
      HeaterError.values.firstWhere((element) => element.errorNumber == byte, orElse: () => HeaterError.none);
}
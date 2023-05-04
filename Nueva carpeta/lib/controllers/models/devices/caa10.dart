import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Caa10 extends Device {

  final WriteFunction _write;
  late final Caa10commands command;

  Caa10(this._write) {
    command = Caa10commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Caa100command.fromByte(packet.byte1);
    switch(command) {
      case Caa100command.getColdTemperature:
      case Caa100command.getHotTemperature:
      case Caa100command.getActualTemperature:
        updateSensorValue(packet);
        break;
      case Caa100command.getHysteresisTemperature:
        dataController.airConditioning.hysteresisTemperatureLevel = packet.byte2 / 10;
        break;
      case Caa100command.getOffsetTemperature:
        // Not implemented
        break;
      case Caa100command.getColdFanMode:
        // Not implemented
        break;
      case Caa100command.getHotFanMode:
      // Not implemented
        break;
      case Caa100command.getStatus:
        var power = (packet.byte2 & 0x80) == 1; // (packet.byte5 & 0x01) == 1
        var temperature = (((packet.byte3 & 0xF0) << 8) | packet.byte4) / 16;
        if (temperature > 2048) {
          temperature -= 4096;
        }
        var mode = Caa100mode.fromByte(packet.byte5 & 0xEF);
        dataController.airConditioning.power.value = power;
        if (mode == Caa100mode.cold) {
          dataController.airConditioning.cold.temperature = temperature.toInt();
        } else {
          dataController.airConditioning.hot.temperature = temperature.toInt();
        }
        dataController.airConditioning.acMode.value.set(mode);
        break;
      default:
    }
  }

}

enum Caa100command {
  setColdTemperature(1),
  getColdTemperature(2),
  setHysteresisTemperature(3),
  getHysteresisTemperature(4),
  setHotTemperature(5),
  getHotTemperature(6),
  setOffsetTemperature(7),
  getOffsetTemperature(8),
  setColdFanMode(9),
  getColdFanMode(10),
  setHotFanMode(11),
  getHotFanMode(12),
  setExternalAlarm(13),
  getActualTemperature(14),
  getStatus(15),
  setValues(16),

  unknown(-1);

  const Caa100command(this.id);
  final int id;

  static Caa100command fromByte(int byte) =>
      Caa100command.values.firstWhere((element) => element.id == byte, orElse: () => Caa100command.unknown);
}

enum Caa100fanSpeed {
  auto(0),
  speed3(1),
  speed2(2),
  speed1(3),

  unknown(-1);

  const Caa100fanSpeed(this.speedNumber);
  final int speedNumber;

  static Caa100fanSpeed fromByte(int byte) =>
      Caa100fanSpeed.values.firstWhere((element) => element.speedNumber == byte, orElse: () => Caa100fanSpeed.unknown);
}

enum Caa100mode {
  off(0),
  cold(1),
  hot(2),
  ventilation(3),

  unknown(-1);

  const Caa100mode(this.modeNumber);
  final int modeNumber;

  static Caa100mode fromByte(int byte) =>
      Caa100mode.values.firstWhere((element) => element.modeNumber == byte, orElse: () => Caa100mode.unknown);
}

class Caa10commands extends DeviceCommands {
  Caa10commands(write) : super(write, Address.caa10);
  
  void getTemperature() => send(Caa100command.getActualTemperature.id);
  void setAlarm(SwitchStatus status) => send(Caa100command.setExternalAlarm.id, status.statusNumber);
  void setColdTemperature(int value) => send(Caa100command.setColdTemperature.id, (value * 16) & 0x00FF, ((value * 16) & 0xFF00) >> 8);
  void setColdFanMode(int value) => send(Caa100command.setColdFanMode.id, value);
  void getColdTargetTemperature() => send(Caa100command.getColdTemperature.id);
  void getColdFanMode() => send(Caa100command.getColdFanMode.id);

  void setHotTemperature(int value) => send(Caa100command.setHotTemperature.id, (value * 16) & 0x00FF, ((value * 16) & 0xFF00) >> 8);
  void setHotFanMode(int value) => send(Caa100command.setHotFanMode.id, value);
  void getHotTargetTemperature() => send(Caa100command.getHotTemperature.id);
  void getHotFanMode() => send(Caa100command.getHotFanMode.id);

  void getStatus() => send(Caa100command.getStatus.id);
  void setOffsetTemperature(int value) => send(Caa100command.setOffsetTemperature.id, (value * 16) & 0x00FF, ((value * 16) & 0xFF00) >> 8);
  void getOffsetTemperature() => send(Caa100command.getOffsetTemperature.id);

  void setValues(SwitchStatus power, Caa100fanSpeed fanSpeed, int temperature, Caa100mode mode) =>
      send(Caa100command.setValues.id, power.statusNumber, fanSpeed.speedNumber, temperature.limitedTo(17, 30), mode.modeNumber);
  // value = hysteresis * 10, so, value = 5 --> hysteresis is 0.5ºC
  void setHysteresisTemperature(int value) => send(Caa100command.setHysteresisTemperature.id, value);
  void getHysteresisTemperature() => send(Caa100command.getHysteresisTemperature.id);
}

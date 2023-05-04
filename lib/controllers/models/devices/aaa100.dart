import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';


class Aaa100 extends Device {

  final WriteFunction _write;
  late final Aaa100commands command;

  Aaa100(this._write) {
    command = Aaa100commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Aaa100command.fromByte(packet.byte1);
    switch(command) {
      case Aaa100command.getTemperature:
        updateSensorValue(packet);
        break;
      case Aaa100command.getValues:
        var power = (packet.byte2 & 0x80) == 1;
        // var fanSpeed = Aaa100fanSpeed.fromByte(packet.byte3); // Not used
        var temperature = (((packet.byte3 & 0xFF) << 8) | packet.byte4) / 16;
        if (temperature > 2048) {
          temperature -= 4096;
        }
        // var mode = Aaa100mode.fromByte(packet.byte5);
        // Not implemented
        // dataController.airConditioning.value.power = power == SwitchStatus.on;
        // dataController.airConditioning.value.acFanSpeed.set(fanSpeed);
        // dataController.airConditioning.value.temperature = temperature;
        // dataController.airConditioning.value.acMode.set(mode);
        // Values[3] = ((ResistorStatus<<3)|(CompressorStatus<<2)|(ExtAlarmActive<<1)|ACdisconnectedStatus)
        break;
      default:
    }
  }

}


enum Aaa100command {
  getTemperature(0),
  setValues(1),
  getValues(2),
  getDisplayValues(3),
  playAlarm(4),
  bluetoothNotify(100),

  unknown(-1);

  const Aaa100command(this.id);
  final int id;

  static Aaa100command fromByte(int byte) =>
      Aaa100command.values.firstWhere((element) => element.id == byte, orElse: () => Aaa100command.unknown);
}

enum Aaa100fanSpeed {
  auto(0),
  speed3(1),
  speed2(2),
  speed1(3),

  unknown(-1);

  const Aaa100fanSpeed(this.speedNumber);
  final int speedNumber;

  static Aaa100fanSpeed fromByte(int byte) =>
      Aaa100fanSpeed.values.firstWhere((element) => element.speedNumber == byte, orElse: () => Aaa100fanSpeed.unknown);
}

enum Aaa100deflector {
  quit(0),
  move(1),

  unknown(-1);

  const Aaa100deflector(this.deflectorNumber);
  final int deflectorNumber;

  static Aaa100deflector fromByte(int byte) =>
      Aaa100deflector.values.firstWhere((element) => element.deflectorNumber == byte, orElse: () => Aaa100deflector.unknown);
}

enum Aaa100mode {
  off(4),
  cold(8),
  dehumidify(9),
  ventilation(10),
  hot(11),
  recirculation(12),

  unknown(-1);

  const Aaa100mode(this.modeNumber);
  final int modeNumber;

  static Aaa100mode fromByte(int byte) =>
      Aaa100mode.values.firstWhere((element) => element.modeNumber == byte, orElse: () => Aaa100mode.unknown);
}

class Aaa100commands extends DeviceCommands {
  Aaa100commands(write) : super(write, Address.aaa100);

  void getTemperature() => send(Aaa100command.getTemperature.id);
  void setValues(SwitchStatus power, Aaa100fanSpeed fanSpeed, int temperature, Aaa100mode mode) =>
      send(Aaa100command.setValues.id, power.statusNumber, fanSpeed.speedNumber, temperature, mode.modeNumber);
  void getValues() => send(Aaa100command.getValues.id);
  void getDisplayValues() => send(Aaa100command.getDisplayValues.id);
  void switchAlarm(SwitchStatus status) => send(Aaa100command.playAlarm.id, status.statusNumber);
  void notifyBluetooth(SwitchStatus status) => send(Aaa100command.bluetoothNotify.id);
}

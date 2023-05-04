import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Ctrlcal100 extends Device {

  final WriteFunction _write;
  late final Ctrlcal100commands command;

  Ctrlcal100(this._write) {
    command = Ctrlcal100commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Ctrlcal100command.fromByte(packet.byte1);
    switch (command) {
      case Ctrlcal100command.getTemperature:
        updateSensorValue(packet);
        break;
      case Ctrlcal100command.getState:
        dataController.heater.updateStatus(packet);
        break;
      default:
    }
  }
}

enum Ctrlcal100mode {
  heat(1),
  ventilation(2);

  const Ctrlcal100mode(this.modeNumber);
  final int modeNumber;
}

enum Ctrlcal100command {
  getTemperature(0),
  setState(1),
  getState(2),
  bluetoothNotify(100),

  unknown(-1);

  const Ctrlcal100command(this.id);
  final int id;

  static Ctrlcal100command fromByte(int byte) =>
      Ctrlcal100command.values.firstWhere((element) => element.id == byte, orElse: () => Ctrlcal100command.unknown);
}

class Ctrlcal100commands extends DeviceCommands {
  Ctrlcal100commands(write) : super(write, Address.ctrlcal100);

  void getTemperature() => send(Ctrlcal100command.getTemperature.id);
  void setMode(SwitchStatus power, Ctrlcal100mode mode, int level) => send(Ctrlcal100command.getTemperature.id, power.statusNumber, mode.modeNumber, level.limitedTo(0, 5));
  void getState() => send(Ctrlcal100command.getState.id);
}

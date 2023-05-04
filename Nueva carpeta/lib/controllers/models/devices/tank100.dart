import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Tank100 extends Device {

  final WriteFunction _write;
  late final Tank100commands command;

  Tank100(this._write) {
    command = Tank100commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Tank100command.fromByte(packet.byte1);
    switch (command) {
      case Tank100command.potableWaterLevel:
      case Tank100command.greyWaterLevel:
      case Tank100command.blackWaterLevel:
      case Tank100command.auxWaterLevel:
        updateSensorValue(packet);
        break;
      default:
    }
  }

}

enum Tank100command {
  potableWaterLevel(1),
  greyWaterLevel(2),
  blackWaterLevel(3),
  auxWaterLevel(4),
  setActiveState(5),

  unknown(-1);

  const Tank100command(this.id);
  final int id;

  static Tank100command fromByte(int byte) =>
      Tank100command.values.firstWhere((element) => element.id == byte, orElse: () => Tank100command.unknown);
}

class Tank100commands extends DeviceCommands {
  Tank100commands(write) : super(write, Address.tank100);

  void getPotableWaterLevel() => send(Tank100command.potableWaterLevel.id);
  void getGreyWaterLevel() => send(Tank100command.greyWaterLevel.id);
  void getBlackWaterLevel() => send(Tank100command.blackWaterLevel.id);
  void getAuxWaterLevel() => send(Tank100command.auxWaterLevel.id);
}

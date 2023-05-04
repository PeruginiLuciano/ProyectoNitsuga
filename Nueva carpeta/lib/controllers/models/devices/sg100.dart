import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Sg100 extends Device {

  final WriteFunction _write;
  late final Sg100commands command;

  Sg100(this._write) {
    command = Sg100commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Sg100command.fromByte(packet.byte1);
    switch (command) {
      case Sg100command.getQuality:
        updateSensorValue(packet);
        break;
      case Sg100command.gasSensor:
        var power = packet.byte2;
        // Not implemented
        break;
      case Sg100command.senseInterval:
        var interval = (packet.byte3 << 8) | packet.byte2;
        // Not implemented
        break;
      default:
    }
  }
}

enum Sg100command {
  getQuality(0),
  gasSensor(1),
  senseInterval(2),

  unknown(-1);

  const Sg100command(this.id);
  final int id;

  static Sg100command fromByte(int byte) =>
      Sg100command.values.firstWhere((element) => element.id == byte, orElse: () => Sg100command.unknown);
}

class Sg100commands extends DeviceCommands {
  Sg100commands(write) : super(write, Address.sg100);

  void getQuality() => send(Sg100command.getQuality.id);
}

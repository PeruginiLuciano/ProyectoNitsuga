import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Prm200 extends Device {

  final WriteFunction _write;
  late final Prm200commands command;

  Prm200(this._write) {
    command = Prm200commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Prm200command.fromByte(packet.byte1);
    switch (command) {
      case Prm200command.getState:
        dataController.levelerSwitchActive.value = [
          MotorStatus.fromByte(packet.byte2),
          MotorStatus.fromByte(packet.byte3),
          MotorStatus.fromByte(packet.byte4),
          MotorStatus.fromByte(packet.byte5)
        ];
        break;
      default:
    }
  }

}

enum Prm200command {
  stop(0),
  close(1),
  open(2),
  automatic(3),
  getState(4),

  unknown(-1);

  const Prm200command(this.id);
  final int id;

  static Prm200command fromByte(int byte) =>
      Prm200command.values.firstWhere((element) => element.id == byte, orElse: () => Prm200command.unknown);
}

class Prm200commands extends DeviceCommands {
  Prm200commands(write) : super(write, Address.prm200);

  void stop() => send(Prm200command.stop.id);
  void close(int switchNumber) => send(Prm200command.close.id, switchNumber);
  void open(int switchNumber) => send(Prm200command.open.id, switchNumber);
  void autoAdjust(bool open) => send(Prm200command.automatic.id, open ? 2 : 1);
}

import 'package:flutter/material.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

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
          packet.byte2 == 1,
          packet.byte3 == 1,
          packet.byte4 == 1,
          packet.byte5 == 1,
        ];
        break;
      default:
    }
  }

}

enum Prm200command {
  stop(0),
  increase(1),
  decrease(2),
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
  void increase(List<bool> switches) =>
      send(Prm200command.increase.id, switches[0] ? 1 : 0, switches[1] ? 1 : 0, switches[2] ? 1 : 0, switches[3] ? 1 : 0);
  void decrease(List<bool> switches) =>
      send(Prm200command.decrease.id, switches[0] ? 1 : 0, switches[1] ? 1 : 0, switches[2] ? 1 : 0, switches[3] ? 1 : 0);
  void autoAdjust({bool cancel = false}) => send(Prm200command.automatic.id, cancel ? 0 : 1);
}

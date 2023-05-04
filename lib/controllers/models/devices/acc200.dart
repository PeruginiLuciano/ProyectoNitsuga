import 'dart:math';

import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Acc200 extends Device {

  final WriteFunction _write;
  late final Acc200commands command;

  Acc200(this._write) {
    command = Acc200commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Acc200command.fromByte(packet.byte1);
    switch (command) {
      case Acc200command.getState:
        // var x = ((packet.byte3 << 8) | packet.byte2).toDouble();
        // var y = ((packet.byte5 << 8) | packet.byte4).toDouble();
        var x = 0.0;
        var y = 0.0;
        var accX = packet.byte2.toSigned(5).toDouble() / 7;
        var accY = packet.byte3.toSigned(5).toDouble() / 7;
        var radius = sqrt(pow(accX, 2) + pow(accY, 2));
        var angle = atan(accY / accX);
        if (radius > 1) {
          x = sqrt(1 / (1 + pow(tan(angle), 2)));
          x = accX < 0 && x >= 0 || x < 0 && accX >= 0 ? x * -1 : x;
          y = tan(angle) * x;
          y = accY < 0 && y >= 0 || y < 0 && accY >= 0 ? y * -1 : y;
        } else {
          x = accX;
          y = accY;
        }
        dataController.accelerometer.value = [x, y];
        break;
      default:
    }
  }

}

enum Acc200command {
  getState(1),

  unknown(-1);

  const Acc200command(this.id);
  final int id;

  static Acc200command fromByte(int byte) =>
      Acc200command.values.firstWhere((element) => element.id == byte, orElse: () => Acc200command.unknown);
}

class Acc200commands extends DeviceCommands {
  Acc200commands(write) : super(write, Address.acc200);

  void getState() => send(Acc200command.getState.id);
}

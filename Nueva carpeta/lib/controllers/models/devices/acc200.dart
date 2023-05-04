import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

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
        var x = ((packet.byte3 << 8) | packet.byte2).toDouble();
        var y = ((packet.byte5 << 8) | packet.byte4).toDouble();
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

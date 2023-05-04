import 'package:flutter/material.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Rgb100 extends Device {

  final WriteFunction _write;
  late final Rgb100commands command;

  Rgb100(this._write) {
    command = Rgb100commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Rgb100command.fromByte(packet.byte1);
    switch (command) {
      case Rgb100command.getState:
        dataController.environmentLight.value = dataController.environmentLight.value.copy(
          power: SwitchStatus.fromByte(packet.byte2) == SwitchStatus.on,
          red: packet.byte3,
          green: packet.byte4,
          blue: packet.byte5,
        );
        break;
      default:
    }
  }

}

enum Rgb100command {
  power(0),
  setRgb(1),
  getState(2),
  setHsv(3),
  setDimmer(4),
  setModeRainbow(5),
  setModeRainbowSpeed(6),
  getState2(7),
  bluetoothNotify(100),

  unknown(-1);

  const Rgb100command(this.id);
  final int id;

  static Rgb100command fromByte(int byte) =>
      Rgb100command.values.firstWhere((element) => element.id == byte, orElse: () => Rgb100command.unknown);
}

class Rgb100commands extends DeviceCommands {
  Rgb100commands(write) : super(write, Address.rgb100);

  void power(SwitchStatus status) => send(Rgb100command.power.id, status.statusNumber);
  void setRgb(int red, int green, int blue) => send(Rgb100command.setRgb.id, red.limitedTo(0, 255), green.limitedTo(0, 255), blue.limitedTo(0, 255));
  void setColor(Color color) => setRgb(color.red, color.green, color.blue);
  void getState() => send(Rgb100command.getState.id);
}

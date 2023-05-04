import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/sensor.dart';

typedef WriteFunction = void Function(Packet packet);

abstract class Device {
  DataController dataController = Get.find();

  void processCommand(Packet packet);

  void updateSensorValue(Packet packet) {
    var sensorCount = (packet.byte5 << 8) | packet.byte4;

    var sensor = SensorType.fromBytes(packet.byte2, packet.byte3);
    if (sensor != SensorType.unknown) {
      var value = sensor.getValue(sensorCount);
      print("$sensor = $sensorCount -> $value");
      dataController.updateSensorValue(sensor, value);
    }
    var oldSensor = SensorTypePrc10.fromBytes(packet.byte2, packet.byte3);
    if (oldSensor != SensorTypePrc10.unknown) {
      var value = oldSensor.getValue(sensorCount);
      dataController.updateOldSensorValue(oldSensor, value);
    }
  }
}

enum DeviceCommand {
  ack(255),
  reset(254),
  bootMode(253),
  fwdata(252),
  chnetaddr(251),
  factory(250),
  info(249),
  response(248);

  const DeviceCommand(this.commandNumber);
  final int commandNumber;
}

enum BootModeParam {
  started(1),
  uploaderAddress(2),
  exit(3);

  const BootModeParam(this.paramNumber);
  final int paramNumber;
}

enum FwdataParam {
  ack(1),
  packet(2),
  newBlock(3),
  resendBlock(4),
  crcBlock(5);

  const FwdataParam(this.paramNumber);
  final int paramNumber;
}

abstract class DeviceCommands {
  final WriteFunction _write;
  final Address destination;

  DeviceCommands(this._write, this.destination);

  void send(
      int command,
      [
        int byte1 = 0,
        int byte2 = 0,
        int byte3 = 0,
        int byte4 = 0,
        int byte5 = 0
      ]
  ) => _write.call(Packet(Address.tmh10, destination, command, byte1, byte2, byte3, byte4, byte5));


}

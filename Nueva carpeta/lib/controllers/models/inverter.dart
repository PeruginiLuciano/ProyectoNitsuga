import 'package:motorhome/controllers/models/charger.dart';
import 'package:motorhome/controllers/models/packet.dart';

class Inverter {
  var power = false;
  var alarms = InverterAlarms();
  var inputVoltage = 0.0;
  var inputCurrent = 0.0;

  void updateVoltageAndAlarms(Packet packet) {
    alarms.updateFromByte(packet.byte1);
    inputVoltage = (packet.byte4 << 8 | packet.byte3).toDouble() / 10.0;
    alarms.globalError = inputVoltage <= 10.2 || inputVoltage >= 15.6;
  }

  void updatePowerValue(Packet packet) {
    var inputPower = (packet.byte4 << 8 | packet.byte3).toDouble() / 10.0;
    inputCurrent = inputVoltage > 0 ? inputPower / inputVoltage : 0;
  }
}

class InverterAlarms extends ChargerAlarms {}

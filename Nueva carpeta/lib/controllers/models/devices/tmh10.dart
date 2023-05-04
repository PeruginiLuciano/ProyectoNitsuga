import 'package:motorhome/controllers/models/ac_source.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/alarm.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/sensor.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Tmh10 extends Device {

  final WriteFunction _write;

  Tmh10(this._write);

  @override
  void processCommand(Packet packet) {
    var command = Tmh10Command.fromPacket(packet);
    switch(command) {
      case Tmh10Command.power:
        // Not implemented
        break;
      case Tmh10Command.acSource:
        dataController.acSource.value = AcSource.fromPacket(packet);
        dataController.acPhaseInverted.value = packet.byte4 == 0;
        break;
      case Tmh10Command.sensorValue:
        updateSensorValue(packet);
        break;
      case Tmh10Command.motorStatus:
        updateMotorStatus(packet);
        break;
      case Tmh10Command.alarm:
        updateAlarms(packet);
        break;
      case Tmh10Command.chargerModeAndAlarm:
        dataController.charger.value.updateModeAndAlarms(packet);
        break;
      case Tmh10Command.chargerPowerValue:
        dataController.charger.value.updatePowerValue(packet);
        break;
      case Tmh10Command.inverterAlarm:
        dataController.inverter.value.updateVoltageAndAlarms(packet);
        break;
      case Tmh10Command.inverterPowerValue:
        dataController.inverter.value.updatePowerValue(packet);
        break;
      case Tmh10Command.handbrakeState:
        dataController.handbrake.value = (packet.byte1 != 0);
        break;
      case Tmh10Command.airConditioningStatus:
        var source = AirConditioningSource.fromByte(packet.byte1);
        if (source == AirConditioningSource.display) {
          var displaySet = packet.byte2;
          var displayShowing = packet.byte3;
          // Not implemented
        }
        else if (source == AirConditioningSource.board) {
          var acHeating = packet.byte5.isBitSet(4);
          var acCooling = packet.byte5.isBitSet(3);
          var acExternalAlarm = packet.byte5.isBitSet(2);
          var acStatus = AirConditioningStatus.fromByte(packet.byte2);
          var acTemperature = (packet.byte3 << 8 | packet.byte4).toDouble() / 16;
          acTemperature = acTemperature > 2048 ? acTemperature - 4096 : acTemperature; // Is this needed?
          var acMode = AirConditioningMode.fromByte(packet.byte2);
        }
        break;
      case Tmh10Command.heaterStatus:
        dataController.heater.updateStatus(packet);
        break;
      case Tmh10Command.currentSensorStatus:
        var sensorValue = (packet.byte4 << 8) | packet.byte3;
        var current = SensorType.batteryCurrent.getValue(sensorValue);
        break;
      case Tmh10Command.gasSensorStatus:
        var sensorValue = (packet.byte4 << 8) | packet.byte3;
        var quality = SensorType.airQuality.getValue(sensorValue);
        break;
      case Tmh10Command.bluetooth:
        // Not implemented
        break;
      default:
    }
  }

  @override
  void updateSensorValue(Packet packet) {
    var sensorCount = (packet.byte4 << 8) | packet.byte3;

    var sensor = SensorType.fromBytes(packet.byte1, packet.byte2);
    if (sensor != SensorType.unknown) {
      var value = sensor.getValue(sensorCount);
      dataController.updateSensorValue(sensor, value);
    }
    var oldSensor = SensorTypePrc10.fromBytes(packet.byte1, packet.byte2);
    if (oldSensor != SensorTypePrc10.unknown) {
      var value = oldSensor.getValue(sensorCount);
      dataController.updateOldSensorValue(oldSensor, value);
    }
  }

  void updateMotorStatus(Packet packet) {
    var motorType = MotorType.fromByte(packet.byte1);
    var status = MotorStatus.fromByte(packet.byte2);
    switch(motorType) {
      case MotorType.table:
        dataController.tableStatus.value = status;
        break;
      case MotorType.slider:
        dataController.sliderStatus.value = status;
        break;
      case MotorType.back:
        dataController.backSliderStatus.value = status;
        break;
      case MotorType.awning:
        dataController.awningStatus.value = status;
        break;
      case MotorType.floodgateGrey:
        dataController.floodgateGreyWaterStatus.value = status;
        break;
      case MotorType.floodgateBlack:
        dataController.floodgateBlackWaterStatus.value = status;
        break;
      default:
    }
  }

  void updateAlarms(Packet packet) {
    var alarmType = AlarmType.fromByte(packet.byte1);
    var alarmSource = AlarmSource.fromByte(packet.byte2);
    var isSwitchOn = SwitchStatus.fromByte(packet.byte3) == SwitchStatus.on;
    var motorStatus = MotorStatus.fromByte(packet.byte3);
    switch(alarmSource) {
      case AlarmSource.exteriorLight:
        dataController.exteriorLight.value = isSwitchOn;
        break;
      case AlarmSource.interiorLight:
        dataController.interiorLight.value = isSwitchOn;
        break;
      case AlarmSource.vaultLight:
        dataController.vaultLight.value = isSwitchOn;
        break;
      case AlarmSource.waterPumper:
        dataController.waterPumper.value = isSwitchOn;
        break;
      case AlarmSource.floodgateGrey:
        dataController.floodgateGreyWaterStatus.value = motorStatus;
        break;
      case AlarmSource.floodgateBlack:
        dataController.floodgateBlackWaterStatus.value = motorStatus;
        break;
      case AlarmSource.table:
        dataController.tableStatus.value = motorStatus;
        break;
      case AlarmSource.slider:
        dataController.sliderStatus.value = motorStatus;
        break;
      case AlarmSource.back:
        // Not implemented
        break;
      case AlarmSource.awning:
        dataController.awningStatus.value = motorStatus;
        break;
      case AlarmSource.generatorOn:
        if (alarmType == AlarmType.startingGenerator) {
          dataController.alarms.generatorOnProtection.value = true;
          dataController.generatorTurnOnSwitch.value = false;
          dataController.generatorTurnOffSwitch.value = false;
          dataController.generatorPrimerSwitch.value = false;
        } else {
          dataController.generatorTurnOnSwitch.value = isSwitchOn;
        }
        break;
      case AlarmSource.generatorOff:
        dataController.generatorTurnOffSwitch.value = false;
        break;
      case AlarmSource.generatorPrimer:
        dataController.generatorPrimerSwitch.value = false;
        break;
      case AlarmSource.generic1:
        // Not implemented
        break;
      case AlarmSource.generic2:
        // Not implemented
        break;
      case AlarmSource.generic3:
        // Not implemented
        break;
      case AlarmSource.unknown:
        switch(alarmType) {
          case AlarmType.lowVoltagePhaseOne:
            dataController.waterPumper.value = false;
            dataController.inverter.value.power = false;
            dataController.heater.power.value = false;
            break;
          case AlarmType.startingGenerator:
            dataController.generatorTurnOnSwitch.value = false;
            dataController.generatorTurnOffSwitch.value = false;
            dataController.generatorPrimerSwitch.value = false;
            // Auto start button should be disabled
            break;
          default:
        }
        break;
      case AlarmSource.charger:
        dataController.charger.value.power = isSwitchOn;
        break;
      case AlarmSource.inverter:
        dataController.inverter.value.power = isSwitchOn;
        break;
      case AlarmSource.motors:
        // Not implemented
        break;
      case AlarmSource.heater:
        dataController.heater.power.value = false;
        break;
      default:
    }
  }

}



enum Tmh10Command {
  power(0),
  acSource(1),
  sensorValue(2),
  motorStatus(3),
  alarm(4),
  chargerModeAndAlarm(5),
  chargerPowerValue(6),
  inverterAlarm(7),
  inverterPowerValue(8),
  handbrakeState(9),
  airConditioningStatus(10),
  heaterStatus(11),
  currentSensorStatus(12),
  gasSensorStatus(13),
  bluetooth(14),

  unknown(-1);

  const Tmh10Command(this.commandNumber);
  final int commandNumber;

  static Tmh10Command fromPacket(Packet packet) =>
      Tmh10Command.values.firstWhere((e) => e.commandNumber == packet.commandNumber, orElse: () => Tmh10Command.unknown);
}

enum AirConditioningSource {
  display(2),
  board(3),

  unknown(-1);

  const AirConditioningSource(this.sourceNumber);
  final int sourceNumber;

  static AirConditioningSource fromByte(int byte) =>
      AirConditioningSource.values.firstWhere((element) => element.sourceNumber == byte, orElse: () => AirConditioningSource.unknown);
}

enum AirConditioningMode {
  hot(2), cold(2), other(0);

  const AirConditioningMode(this.modeNumber);
  final int modeNumber;

  static AirConditioningMode fromByte(int byte) {
    var modeNumber = byte & 0x7F;
    return modeNumber == 1 ? AirConditioningMode.cold : (modeNumber == 2 ? AirConditioningMode.hot : AirConditioningMode.other);
  }
}

enum AirConditioningStatus {
  on(0x80), off(0);

  const AirConditioningStatus(this.statusNumber);
  final int statusNumber;

  static AirConditioningStatus fromByte(int byte) =>
      byte.isBitSet(8) ? AirConditioningStatus.on : AirConditioningStatus.off;
}

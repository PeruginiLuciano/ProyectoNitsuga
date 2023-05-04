import 'package:motorhome/controllers/models/ac_source.dart';
import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/adjustment.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Prc10 extends Device {

  final WriteFunction _write;
  late final Prc10commands command;

  Prc10(this._write) {
    command = Prc10commands(_write);
  }

  @override
  void processCommand(Packet packet) async {
    var command = Prc10command.fromByte(packet.byte1);
    switch(command) {
      case Prc10command.acSource:
        dataController.acSource.value =
          packet.byte2 == 0 ? AcSource.line :
          packet.byte3 == 0 ? AcSource.generator :
          packet.byte4 == 0 ? AcSource.inverter : AcSource.none;
        dataController.acPhaseInverted.value = packet.byte5 == 0;
        break;
      case Prc10command.acCurrent:
      case Prc10command.acFrequency:
      case Prc10command.acVoltage:
      case Prc10command.dcCurrent:
      case Prc10command.dcVoltage:
      case Prc10command.potableWaterLevel:
      case Prc10command.greyWaterLevel:
      case Prc10command.blackWaterLevel:
        updateSensorValue(packet);
        break;
      case Prc10command.dimmerRead:
        dataController.interiorLightDimmer.value = packet.byte2;
        break;
      case Prc10command.readSwitchesStatuses:
        updateSwitches(packet);
        break;
      case Prc10command.readMotorsStatuses:
        updateMotorStatuses(packet);
        break;
      case Prc10command.automaticProtection:
        updateProtections(packet);
        break;
      case Prc10command.getAdjustMotorCurrent:
        updateMotorsCurrentLimitAdjustment(packet);
        break;
      case Prc10command.getMotorCurrent:
        updateMotorsCurrentLimit(packet);
        break;
      case Prc10command.getAdjustMotorTime:
        updateMotorsTimeLimitAdjustment(packet);
        break;
      case Prc10command.getMotorTime:
        updateMotorsTimeLimit(packet);
        break;
      case Prc10command.getAdjustSwitchCurrent:
        updateSwitchesCurrentLimitAdjustment(packet);
        break;
      case Prc10command.getSwitchCurrent:
        updateSwitchesCurrentLimit(packet);
        break;
      case Prc10command.getAdjustVoltages:
        dataController.adjustment.other.tableVoltage.value = packet.byte2 == 24 ? AdjustmentTableVoltage.twelve : AdjustmentTableVoltage.twentyFour;
        dataController.adjustment.other.batteryVoltage.value = (packet.byte3 - 100) / 10.0;
        dataController.adjustment.other.acVoltage.value = (packet.byte4 - 100).toDouble();
        break;
      case Prc10command.generatorAndInverterMode:
        dataController.adjustment.other.generatorMode.value = AdjustmentGeneratorMode.fromByte(packet.byte2);
        dataController.adjustment.other.inverterMode.value = AdjustmentInverterMode.fromByte(packet.byte3);
        break;
      case Prc10command.hardwareVersion:
        dataController.adjustment.hardwareVersion.value = packet.byte2 + packet.byte3 / 10.0;
        break;
      default:
    }
  }

  void updateSwitches(Packet packet) {
    dataController.handbrake.value = packet.byte2.isBitSet(1);
    dataController.interiorLight.value = packet.byte2.isBitSet(2);
    dataController.exteriorLight.value = packet.byte2.isBitSet(3);
    dataController.vaultLight.value = packet.byte2.isBitSet(4);
    dataController.waterPumper.value = packet.byte2.isBitSet(5);
    dataController.generic1.value = packet.byte2.isBitSet(6);
    dataController.generic2.value = packet.byte2.isBitSet(7);
    dataController.generic3.value = packet.byte2.isBitSet(8);
    dataController.charger.value.power = packet.byte3.isBitSet(1);
    dataController.inverter.value.power = packet.byte3.isBitSet(2);
    dataController.heater.power.value = packet.byte3.isBitSet(3);
  }

  void updateMotorStatuses(Packet packet) {
    dataController.tableStatus.value = MotorStatus.fromByte((packet.byte2 & 0xF0)  >> 4);
    dataController.sliderStatus.value = MotorStatus.fromByte((packet.byte2 & 0x0F));
    dataController.backSliderStatus.value = MotorStatus.fromByte((packet.byte3 & 0xF0) >> 4);
    dataController.awningStatus.value = MotorStatus.fromByte((packet.byte3 & 0x0F));
    dataController.floodgateGreyWaterStatus.value = MotorStatus.fromByte((packet.byte4 & 0xF0) >> 4);
    dataController.floodgateGreyWaterStatus.value = MotorStatus.fromByte((packet.byte4 & 0x0F));
  }

  void updateProtections(Packet packet) {
    dataController.alarms.waterPumperProtection.value = packet.byte2 == 1;
    dataController.alarms.floodgateGreyProtection.value = packet.byte3 == 1;
    dataController.alarms.floodgateBlackProtection.value = packet.byte4 == 1;
    dataController.alarms.autoStartGeneratorProtection.value = packet.byte5 == 1;
  }

  /// Updates current values in Amperes
  void updateMotorsCurrentLimitAdjustment(Packet packet) {
    var motorType = MotorType.fromByte(packet.byte2);
    var openCurrentLimit = (packet.byte3 - 100) * 0.5;
    var closeCurrentLimit = (packet.byte4 - 100) * 0.5;
    switch(motorType) {
      case MotorType.table:
        dataController.adjustment.motor.table.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.table.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      case MotorType.slider:
        dataController.adjustment.motor.slider.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.slider.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      case MotorType.back:
        dataController.adjustment.motor.backSlider.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.backSlider.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      case MotorType.awning:
        dataController.adjustment.motor.awning.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.awning.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      case MotorType.floodgateGrey:
        dataController.adjustment.motor.floodgateGreyWater.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.floodgateGreyWater.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      case MotorType.floodgateBlack:
        dataController.adjustment.motor.floodgateBlackWater.open.currentLimitAdjustment.value = openCurrentLimit;
        dataController.adjustment.motor.floodgateBlackWater.close.currentLimitAdjustment.value = closeCurrentLimit;
        break;
      default:
    }
  }

  /// Updates current values in Amperes
  void updateMotorsCurrentLimit(Packet packet) {
    var motorType = MotorType.fromByte(packet.byte2);
    var isOpenOrTopLimit = packet.byte3 == 1;
    var currentValue = (((packet.byte5 << 8) | packet.byte4) - 2048) / 53;
    switch(motorType) {
      case MotorType.table:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.table.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.table.close.currentLimit.value = currentValue;
        }
        break;
      case MotorType.slider:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.slider.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.slider.close.currentLimit.value = currentValue;
        }
        break;
      case MotorType.back:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.backSlider.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.backSlider.close.currentLimit.value = currentValue;
        }
        break;
      case MotorType.awning:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.awning.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.awning.close.currentLimit.value = currentValue;
        }
        break;
      case MotorType.floodgateGrey:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.floodgateGreyWater.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.floodgateGreyWater.close.currentLimit.value = currentValue;
        }
        break;
      case MotorType.floodgateBlack:
        if (isOpenOrTopLimit) {
          dataController.adjustment.motor.floodgateBlackWater.open.currentLimit.value = currentValue;
        } else {
          dataController.adjustment.motor.floodgateBlackWater.close.currentLimit.value = currentValue;
        }
        break;
      default:
    }
  }

  /// Updates time values in seconds
  void updateMotorsTimeLimitAdjustment(Packet packet) {
    var motorType = MotorType.fromByte(packet.byte2);
    var openTimeLimit = (packet.byte3 - 100).toDouble();
    var closeTimeLimit = (packet.byte4 - 100).toDouble();
    switch(motorType) {
      case MotorType.table:
        dataController.adjustment.motor.table.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.table.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      case MotorType.slider:
        dataController.adjustment.motor.slider.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.slider.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      case MotorType.back:
        dataController.adjustment.motor.backSlider.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.backSlider.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      case MotorType.awning:
        dataController.adjustment.motor.awning.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.awning.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      case MotorType.floodgateGrey:
        dataController.adjustment.motor.floodgateGreyWater.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.floodgateGreyWater.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      case MotorType.floodgateBlack:
        dataController.adjustment.motor.floodgateBlackWater.open.timeLimitAdjustment.value = openTimeLimit;
        dataController.adjustment.motor.floodgateBlackWater.close.timeLimitAdjustment.value = closeTimeLimit;
        break;
      default:
    }
  }

  /// Updates time values in seconds
  void updateMotorsTimeLimit(Packet packet) {
    var motorType = MotorType.fromByte(packet.byte2);
    var openTimeLimit = (packet.byte3 - 100).toDouble() / 0.1;
    var closeTimeLimit = (packet.byte4 - 100).toDouble() / 0.1;
    switch(motorType) {
      case MotorType.table:
        dataController.adjustment.motor.table.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.table.close.timeLimit.value = closeTimeLimit;
        break;
      case MotorType.slider:
        dataController.adjustment.motor.slider.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.slider.close.timeLimit.value = closeTimeLimit;
        break;
      case MotorType.back:
        dataController.adjustment.motor.backSlider.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.backSlider.close.timeLimit.value = closeTimeLimit;
        break;
      case MotorType.awning:
        dataController.adjustment.motor.awning.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.awning.close.timeLimit.value = closeTimeLimit;
        break;
      case MotorType.floodgateGrey:
        dataController.adjustment.motor.floodgateGreyWater.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.floodgateGreyWater.close.timeLimit.value = closeTimeLimit;
        break;
      case MotorType.floodgateBlack:
        dataController.adjustment.motor.floodgateBlackWater.open.timeLimit.value = openTimeLimit;
        dataController.adjustment.motor.floodgateBlackWater.close.timeLimit.value = closeTimeLimit;
        break;
      default:
    }
  }

  void updateSwitchesCurrentLimitAdjustment(Packet packet) {
    var switchType = SwitchType.fromByte(packet.byte2);
    var currentValue = (packet.byte3 - 100) * 0.5;
    switch(switchType) {
      case SwitchType.interiorLight:
        dataController.adjustment.switchOnOff.interiorLight.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.exteriorLight:
        dataController.adjustment.switchOnOff.exteriorLight.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.vaultLight:
        dataController.adjustment.switchOnOff.vaultLight.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.waterPumper:
        dataController.adjustment.switchOnOff.waterPumper.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generatorOn:
        dataController.adjustment.switchOnOff.generatorOn.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generatorOff:
        dataController.adjustment.switchOnOff.generatorOff.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generatorPrimer:
        dataController.adjustment.switchOnOff.generatorPrimer.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generic1:
        dataController.adjustment.switchOnOff.generic1.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generic2:
        dataController.adjustment.switchOnOff.generic2.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.generic3:
        dataController.adjustment.switchOnOff.generic3.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.charger:
        dataController.adjustment.switchOnOff.charger.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.inverter:
        dataController.adjustment.switchOnOff.inverter.currentLimitAdjustment.value = currentValue;
        break;
      case SwitchType.heater:
        dataController.adjustment.switchOnOff.heater.currentLimitAdjustment.value = currentValue;
        break;
      default:
    }
  }

  void updateSwitchesCurrentLimit(Packet packet) {
    var switchType = SwitchType.fromByte(packet.byte2);
    var currentValue = (((packet.byte4 << 8) | packet.byte3) - 2048) / 53;
    switch(switchType) {
      case SwitchType.interiorLight:
        dataController.adjustment.switchOnOff.interiorLight.currentLimit.value = currentValue;
        break;
      case SwitchType.exteriorLight:
        dataController.adjustment.switchOnOff.exteriorLight.currentLimit.value = currentValue;
        break;
      case SwitchType.vaultLight:
        dataController.adjustment.switchOnOff.vaultLight.currentLimit.value = currentValue;
        break;
      case SwitchType.waterPumper:
        dataController.adjustment.switchOnOff.waterPumper.currentLimit.value = currentValue;
        break;
      case SwitchType.generatorOn:
        dataController.adjustment.switchOnOff.generatorOn.currentLimit.value = currentValue;
        break;
      case SwitchType.generatorOff:
        dataController.adjustment.switchOnOff.generatorOff.currentLimit.value = currentValue;
        break;
      case SwitchType.generatorPrimer:
        dataController.adjustment.switchOnOff.generatorPrimer.currentLimit.value = currentValue;
        break;
      case SwitchType.generic1:
        dataController.adjustment.switchOnOff.generic1.currentLimit.value = currentValue;
        break;
      case SwitchType.generic2:
        dataController.adjustment.switchOnOff.generic2.currentLimit.value = currentValue;
        break;
      case SwitchType.generic3:
        dataController.adjustment.switchOnOff.generic3.currentLimit.value = currentValue;
        break;
      case SwitchType.charger:
        dataController.adjustment.switchOnOff.charger.currentLimit.value = currentValue;
        break;
      case SwitchType.inverter:
        dataController.adjustment.switchOnOff.inverter.currentLimit.value = currentValue;
        break;
      case SwitchType.heater:
        dataController.adjustment.switchOnOff.heater.currentLimit.value = currentValue;
        break;
      default:
    }
  }

}



enum Prc10command {
  motorTable(0),
  motorSlider(1),
  motorBack(2),
  motorAwning(3),
  floodgateBlack(4),
  floodgateGrey(5),
  lightVault(6),
  lightExterior(7),
  lightInterior(8),
  waterPumper(9),
  generatorOn(10),
  generatorOff(11),
  generatorPrimer(12),
  generic1(13),
  generic2(14),
  generic3(15),
  // Sensors
  acSource(16),
  acCurrent(17),
  acFrequency(18),
  acVoltage(19),
  dcCurrent(20),
  dcVoltage(21),
  potableWaterLevel(22),
  greyWaterLevel(23),
  blackWaterLevel(24),
  switchCharger(25),
  switchInverter(26),
  stopBuzzer(27),
  dimmerSet(28),
  dimmerRead(29),
  heater(30),

  notifyBluetooth(100),
  readSwitchesStatuses(101),
  readMotorsStatuses(102),
  automaticProtection(103),
  adjustMotorCurrent(104),
  getAdjustMotorCurrent(105),
  getMotorCurrent(106),
  adjustMotorTime(107),
  getAdjustMotorTime(108),
  getMotorTime(109),
  adjustSwitchCurrent(110),
  getAdjustSwitchCurrent(111),
  getSwitchCurrent(112),
  adjustVoltages(113),
  getAdjustVoltages(114),
  generatorAndInverterMode(115),
  getGeneratorAndInverterMode(116),

  hardwareVersion(200),

  unknown(-1);

  const Prc10command(this.id);
  final int id;

  static Prc10command fromByte(int byte) =>
      Prc10command.values.firstWhere((element) => element.id == byte, orElse: () => Prc10command.unknown);
}

enum MotorAction {
  open(1),
  close(2),
  stop(3);

  const MotorAction(this.actionNumber);
  final int actionNumber;
}

enum SwitchType {
  interiorLight(0),
  exteriorLight(1),
  vaultLight(2),
  waterPumper(3),
  generatorOn(4),
  generatorOff(5),
  generatorPrimer(6),
  generic1(7),
  generic2(8),
  generic3(9),
  charger(10),
  inverter(11),
  heater(12),

  unknown(-1);

  const SwitchType(this.typeNumber);
  final int typeNumber;

  static SwitchType fromByte(int byte) =>
      SwitchType.values.firstWhere((element) => element.typeNumber == byte, orElse: () => SwitchType.unknown);
}

enum ProtectionType {
  waterPumper(1),
  floodgateGrey(2),
  floodgateBlack(3),
  autoStartGenerator(4);

  const ProtectionType(this.typeNumber);
  final int typeNumber;
}

class Prc10commands extends DeviceCommands {
  Prc10commands(write) : super(write, Address.prc10);
  // Lights
  void switchInteriorLight(SwitchStatus status) => _switchOnOff(Prc10command.lightInterior, status);
  void switchExteriorLight(SwitchStatus status) => _switchOnOff(Prc10command.lightExterior, status);
  void switchVaultLight(SwitchStatus status) => _switchOnOff(Prc10command.lightVault, status);
  // Motors
  void sendTableAction(MotorAction action) => _motor(Prc10command.motorTable, action);
  void sendSliderAction(MotorAction action) => _motor(Prc10command.motorSlider, action);
  void sendBackAction(MotorAction action) => _motor(Prc10command.motorBack, action);
  void sendAwningAction(MotorAction action) => _motor(Prc10command.motorAwning, action);
  void sendFloodgateBlackAction(MotorAction action) => _motor(Prc10command.floodgateBlack, action);
  void sendFloodgateGreyAction(MotorAction action) => _motor(Prc10command.floodgateGrey, action);
  void setFloodgateGreyWaterAutomaticProtectionStatus(SwitchStatus status) => _setAutomaticProtection(ProtectionType.floodgateGrey, status);
  void setFloodgateBlackWaterAutomaticProtectionStatus(SwitchStatus status) => _setAutomaticProtection(ProtectionType.floodgateBlack, status);
  // Generator
  void switchGeneratorOnButton(SwitchStatus status) => _switchOnOff(Prc10command.generatorOn, status);
  void switchGeneratorOffButton(SwitchStatus status) => _switchOnOff(Prc10command.generatorOff, status);
  void switchGeneratorPrimerButton(SwitchStatus status) => _switchOnOff(Prc10command.generatorPrimer, status);
  void setAutomaticStartGeneratorProtectionStatus(SwitchStatus status) => _setAutomaticProtection(ProtectionType.autoStartGenerator, status);
  // Generics
  void switchGeneric1(SwitchStatus status) => _switchOnOff(Prc10command.generic1, status);
  void switchGeneric2(SwitchStatus status) => _switchOnOff(Prc10command.generic2, status);
  void switchGeneric3(SwitchStatus status) => _switchOnOff(Prc10command.generic3, status);
  // Water pumper
  void switchWaterPumper(SwitchStatus status) => _switchOnOff(Prc10command.waterPumper, status);
  void setWaterPumperAutomaticProtectionStatus(SwitchStatus status) => _setAutomaticProtection(ProtectionType.waterPumper, status);

  void switchHeater(SwitchStatus status) => _switchOnOff(Prc10command.heater, status);
  void switchCharger(SwitchStatus status) => _switchOnOff(Prc10command.switchCharger, status);
  void switchInverter(SwitchStatus status) => _switchOnOff(Prc10command.switchInverter, status);
  void stopBuzzer() => send(Prc10command.stopBuzzer.id);

  // Dimmer
  void sendDimmerValue(int value) => send(Prc10command.dimmerSet.id, value.limitedTo(0, 100));

  // Adjustments
  // Motor current
  // opened and closed values should be multiple of 0.5
  void adjustTableCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.table, opened, closed);
  void adjustSliderCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.slider, opened, closed);
  void adjustBackCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.back, opened, closed);
  void adjustAwningCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.awning, opened, closed);
  void adjustFloodgateGreyCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.floodgateGrey, opened, closed);
  void adjustFloodgateBlackCurrent(double opened, double closed) => _adjustMotorCurrent(MotorType.floodgateBlack, opened, closed);
  void _getTableCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.table);
  void _getSliderCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.slider);
  void _getBackCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.back);
  void _getAwningCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.awning);
  void _getFloodgateGreyCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.floodgateGrey);
  void _getFloodgateBlackCurrentAdjustment() => _getMotorCurrentAdjustment(MotorType.floodgateBlack);
  /// Get all motor currents adjustments
  void getMotorsCurrentsAdjustments() {
    _getTableCurrentAdjustment();
    _getSliderCurrentAdjustment();
    _getBackCurrentAdjustment();
    _getAwningCurrentAdjustment();
    _getFloodgateGreyCurrentAdjustment();
    _getFloodgateBlackCurrentAdjustment();
  }
  // Fixed current values
  void _getTableMotorCurrent() => _getMotorCurrent(MotorType.table);
  void _getSliderMotorCurrent() => _getMotorCurrent(MotorType.slider);
  void _getBackMotorCurrent() => _getMotorCurrent(MotorType.back);
  void _getAwningMotorCurrent() => _getMotorCurrent(MotorType.awning);
  void _getFloodgateGreyMotorCurrent() => _getMotorCurrent(MotorType.floodgateGrey);
  void _getFloodgateBlackMotorCurrent() => _getMotorCurrent(MotorType.floodgateBlack);
  /// Get all motors currents fixed values
  void getMotorsCurrents() {
    _getTableMotorCurrent();
    _getSliderMotorCurrent();
    _getBackMotorCurrent();
    _getAwningMotorCurrent();
    _getFloodgateGreyMotorCurrent();
    _getFloodgateBlackMotorCurrent();
  }
  // Motor time limit
  // opened and closed values should be multiple of 0.1
  void adjustTableTime(double opened, double closed) => _adjustMotorTime(MotorType.table, opened, closed);
  void adjustSliderTime(double opened, double closed) => _adjustMotorTime(MotorType.slider, opened, closed);
  void adjustBackTime(double opened, double closed) => _adjustMotorTime(MotorType.back, opened, closed);
  void adjustAwningTime(double opened, double closed) => _adjustMotorTime(MotorType.awning, opened, closed);
  void adjustFloodgateGreyTime(double opened, double closed) => _adjustMotorTime(MotorType.floodgateGrey, opened, closed);
  void adjustFloodgateBlackTime(double opened, double closed) => _adjustMotorTime(MotorType.floodgateBlack, opened, closed);
  void _getTableTimeAdjustment() => _getMotorTimeAdjustment(MotorType.table);
  void _getSliderTimeAdjustment() => _getMotorTimeAdjustment(MotorType.slider);
  void _getBackTimeAdjustment() => _getMotorTimeAdjustment(MotorType.back);
  void _getAwningTimeAdjustment() => _getMotorTimeAdjustment(MotorType.awning);
  void _getFloodgateGreyTimeAdjustment() => _getMotorTimeAdjustment(MotorType.floodgateGrey);
  void _getFloodgateBlackTimeAdjustment() => _getMotorTimeAdjustment(MotorType.floodgateBlack);
  /// Get all motors times adjustments
  void getMotorsTimesAdjustments() {
    _getTableTimeAdjustment();
    _getSliderTimeAdjustment();
    _getBackTimeAdjustment();
    _getAwningTimeAdjustment();
    _getFloodgateGreyTimeAdjustment();
    _getFloodgateBlackTimeAdjustment();
  }
  // Fixed time values
  void _getTableMotorTime() => _getMotorTime(MotorType.table);
  void _getSliderMotorTime() => _getMotorTime(MotorType.slider);
  void _getBackMotorTime() => _getMotorTime(MotorType.back);
  void _getAwningMotorTime() => _getMotorTime(MotorType.awning);
  void _getFloodgateGreyMotorTime() => _getMotorTime(MotorType.floodgateBlack);
  void _getFloodgateBlackMotorTime() => _getMotorTime(MotorType.floodgateBlack);
  /// Get all motors times fixed values
  void getMotorsTimes() {
    _getTableMotorTime();
    _getSliderMotorTime();
    _getBackMotorTime();
    _getAwningMotorTime();
    _getFloodgateGreyMotorTime();
    _getFloodgateBlackMotorTime();
  }
  // Switches currents
  // value should be multiple of 0.1
  void adjustInteriorLightCurrent(double value) => _adjustSwitchCurrent(SwitchType.interiorLight, value);
  void adjustExteriorLightCurrent(double value) => _adjustSwitchCurrent(SwitchType.exteriorLight, value);
  void adjustVaultLightCurrent(double value) => _adjustSwitchCurrent(SwitchType.vaultLight, value);
  void adjustWaterPumperCurrent(double value) => _adjustSwitchCurrent(SwitchType.waterPumper, value);
  void adjustGeneratorOnButtonCurrent(double value) => _adjustSwitchCurrent(SwitchType.generatorOn, value);
  void adjustGeneratorOffButtonCurrent(double value) => _adjustSwitchCurrent(SwitchType.generatorOff, value);
  void adjustGeneratorPrimerButtonCurrent(double value) => _adjustSwitchCurrent(SwitchType.generatorPrimer, value);
  void adjustGeneric1SwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.generic1, value);
  void adjustGeneric2SwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.generic2, value);
  void adjustGeneric3SwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.generic3, value);
  void adjustChargerSwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.charger, value);
  void adjustInverterSwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.inverter, value);
  void adjustHeaterSwitchCurrent(double value) => _adjustSwitchCurrent(SwitchType.heater, value);
  void _getInteriorLightCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.interiorLight);
  void _getExteriorLightCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.exteriorLight);
  void _getVaultLightCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.vaultLight);
  void _getWaterPumperCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.waterPumper);
  void _getGeneratorOnButtonCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generatorOn);
  void _getGeneratorOffButtonCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generatorOff);
  void _getGeneratorPrimerButtonCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generatorPrimer);
  void _getGeneric1SwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generic1);
  void _getGeneric2SwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generic2);
  void _getGeneric3SwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.generic3);
  void _getChargerSwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.charger);
  void _getInverterSwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.inverter);
  void _getHeaterSwitchCurrentAdjustment() => _getSwitchCurrentAdjustment(SwitchType.heater);
  /// Get all switches currents adjustments
  void getSwitchesCurrentsAdjustments() {
    _getInteriorLightCurrentAdjustment();
    _getExteriorLightCurrentAdjustment();
    _getVaultLightCurrentAdjustment();
    _getWaterPumperCurrentAdjustment();
    _getGeneratorOnButtonCurrentAdjustment();
    _getGeneratorOffButtonCurrentAdjustment();
    _getGeneratorPrimerButtonCurrentAdjustment();
    _getGeneric1SwitchCurrentAdjustment();
    _getGeneric2SwitchCurrentAdjustment();
    _getGeneric3SwitchCurrentAdjustment();
    _getChargerSwitchCurrentAdjustment();
    _getInverterSwitchCurrentAdjustment();
    _getHeaterSwitchCurrentAdjustment();
  }
  // Fixed current values
  void _getInteriorLightCurrent() => _getSwitchCurrent(SwitchType.interiorLight);
  void _getExteriorLightCurrent() => _getSwitchCurrent(SwitchType.exteriorLight);
  void _getVaultLightCurrent() => _getSwitchCurrent(SwitchType.vaultLight);
  void _getWaterPumperCurrent() => _getSwitchCurrent(SwitchType.waterPumper);
  void _getGeneratorOnButtonCurrent() => _getSwitchCurrent(SwitchType.generatorOn);
  void _getGeneratorOffButtonCurrent() => _getSwitchCurrent(SwitchType.generatorOff);
  void _getGeneratorPrimerButtonCurrent() => _getSwitchCurrent(SwitchType.generatorPrimer);
  void _getGeneric1SwitchCurrent() => _getSwitchCurrent(SwitchType.generic1);
  void _getGeneric2SwitchCurrent() => _getSwitchCurrent(SwitchType.generic2);
  void _getGeneric3SwitchCurrent() => _getSwitchCurrent(SwitchType.generic3);
  void _getChargerSwitchCurrent() => _getSwitchCurrent(SwitchType.charger);
  void _getInverterSwitchCurrent() => _getSwitchCurrent(SwitchType.inverter);
  void _getHeaterSwitchCurrent() => _getSwitchCurrent(SwitchType.heater);
  /// Get all switches currents fixed values
  void getSwitchesCurrents() {
    _getInteriorLightCurrent();
    _getExteriorLightCurrent();
    _getVaultLightCurrent();
    _getWaterPumperCurrent();
    _getGeneratorOnButtonCurrent();
    _getGeneratorOffButtonCurrent();
    _getGeneratorPrimerButtonCurrent();
    _getGeneric1SwitchCurrent();
    _getGeneric2SwitchCurrent();
    _getGeneric3SwitchCurrent();
    _getChargerSwitchCurrent();
    _getInverterSwitchCurrent();
    _getHeaterSwitchCurrent();
  }
  /// Adjust voltage for table motor (12 or 24), battery voltage read (0.1V multiple) and AC voltage (1V)
  void adjustVoltages(double tableVoltage, double batteryVoltage, double acVoltage) =>
      send(Prc10command.adjustVoltages.id, tableVoltage == 24 ? 24 : 12, ((batteryVoltage / 0.1) + 100).toInt(), (acVoltage + 100).toInt());
  void getAdjustVoltages() => send(Prc10command.getAdjustVoltages.id);
  void adjustGeneratorAndInverterMode(AdjustmentGeneratorMode generatorMode, AdjustmentInverterMode inverterMode) =>
      send(Prc10command.generatorAndInverterMode.id, generatorMode.modeNumber, inverterMode.modeNumber);
  void getGeneratorAndInverterMode() => send(Prc10command.getGeneratorAndInverterMode.id);
  /// Get hardware version
  void getHardwareVersion() => send(Prc10command.hardwareVersion.id);

  // region private
  void _switchOnOff(Prc10command command, SwitchStatus status) => send(command.id, status.statusNumber);
  void _motor(Prc10command command, MotorAction action) => send(command.id, action.actionNumber);
  void _setAutomaticProtection(ProtectionType type, SwitchStatus status) => send(Prc10command.automaticProtection.id, status.statusNumber, type.typeNumber);
  void _adjustMotorCurrent(MotorType motorType, double opened, double closed) => send(Prc10command.adjustMotorCurrent.id, motorType.typeNumber, ((opened / 0.5) + 100).toInt(), ((closed / 0.5) + 100).toInt());
  void _getMotorCurrentAdjustment(MotorType motorType) => send(Prc10command.getAdjustMotorCurrent.id, motorType.typeNumber);
  void _getMotorCurrent(MotorType motorType) => send(Prc10command.getMotorCurrent.id, motorType.typeNumber);
  void _adjustMotorTime(MotorType motorType, double opened, double closed) => send(Prc10command.adjustMotorTime.id, motorType.typeNumber, ((opened / 0.1) + 100).toInt(), ((closed / 0.1) + 100).toInt());
  void _getMotorTimeAdjustment(MotorType motorType) => send(Prc10command.getAdjustMotorTime.id, motorType.typeNumber);
  void _getMotorTime(MotorType motorType) => send(Prc10command.getMotorTime.id, motorType.typeNumber);
  void _adjustSwitchCurrent(SwitchType type, double value) => send(Prc10command.adjustSwitchCurrent.id, type.typeNumber, ((value / 0.5) + 100).toInt());
  void _getSwitchCurrentAdjustment(SwitchType type) => send(Prc10command.getAdjustSwitchCurrent.id, type.typeNumber);
  void _getSwitchCurrent(SwitchType type) => send(Prc10command.getSwitchCurrent.id, type.typeNumber);
  // endregion

  // Get sensors values
  void getAcSource() => send(Prc10command.acSource.id);
  void getAcVoltage() => send(Prc10command.acVoltage.id);
  void getAcCurrent() => send(Prc10command.acCurrent.id);
  void getAcFrequency() => send(Prc10command.acFrequency.id);
  void getDcVoltage() => send(Prc10command.dcVoltage.id);
  void getDcCurrent() => send(Prc10command.dcCurrent.id);
  void getPotableWaterLevel() => send(Prc10command.potableWaterLevel.id);
  void getGreyWaterLevel() => send(Prc10command.greyWaterLevel.id);
  void getBlackWaterLevel() => send(Prc10command.blackWaterLevel.id);
  void getAutomaticProtectionsStatuses() => send(Prc10command.automaticProtection.id, SwitchStatus.state.statusNumber);
  void getDimmerValue() => send(Prc10command.dimmerRead.id);
  void getSwitchesStatuses() => send(Prc10command.readSwitchesStatuses.id);
  void getMotorsStatuses() => send(Prc10command.readMotorsStatuses.id);
}

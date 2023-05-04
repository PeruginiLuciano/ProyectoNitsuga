import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/adjustment.dart';

class ModalAdjustViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  var newValues = Adjustment();
  List<double> batteryAdjustmentValues = List.generate(41, (index) => ((index - 20) / 10).toPrecision(1));
  List<int> acAdjustmentValues = List.generate(61, (index) => (index - 30));
  List<int> airQualityValues = List.generate(21, (index) => (index - 10) * 100);
  List<int> airQualityTimes = List.generate(21, (index) => (index - 10));

  var currentConfig = ConfigItem.switches.obs;

  @override
  void onInit() {
    newValues = Adjustment.from(dataController.adjustment);
    communicationController.prc10.command.getAdjustVoltages();
    communicationController.prc10.command.getSwitchesCurrentsAdjustments();
    communicationController.prc10.command.getMotorsCurrentsAdjustments();
    communicationController.prc10.command.getMotorsTimesAdjustments();
    dataController.adjustment.other.storedLocally.restoreValues();
    super.onInit();
  }

  Future sendNewValues() async {
    sendSwitchesCurrentValues();
    sendMotorsCurrentsValues();
    sendOthersValues();
  }

  void sendSwitchesCurrentValues() {
    dataController.adjustment.switchOnOff
      ..interiorLight.sendIfChanged(newValues.switchOnOff.interiorLight, communicationController.prc10.command.adjustInteriorLightCurrent)
      ..exteriorLight.sendIfChanged(newValues.switchOnOff.exteriorLight, communicationController.prc10.command.adjustExteriorLightCurrent)
      ..vaultLight.sendIfChanged(newValues.switchOnOff.vaultLight, communicationController.prc10.command.adjustVaultLightCurrent)
      ..waterPumper.sendIfChanged(newValues.switchOnOff.waterPumper, communicationController.prc10.command.adjustWaterPumperCurrent)
      ..generatorOn.sendIfChanged(newValues.switchOnOff.generatorOn, communicationController.prc10.command.adjustGeneratorOnButtonCurrent)
      ..generatorOff.sendIfChanged(newValues.switchOnOff.generatorOff, communicationController.prc10.command.adjustGeneratorOffButtonCurrent)
      ..generatorPrimer.sendIfChanged(newValues.switchOnOff.generatorPrimer, communicationController.prc10.command.adjustGeneratorPrimerButtonCurrent)
      ..generic1.sendIfChanged(newValues.switchOnOff.generic1, communicationController.prc10.command.adjustGeneric1SwitchCurrent)
      ..generic2.sendIfChanged(newValues.switchOnOff.generic2, communicationController.prc10.command.adjustGeneric2SwitchCurrent)
      ..generic3.sendIfChanged(newValues.switchOnOff.generic3, communicationController.prc10.command.adjustGeneric3SwitchCurrent)
      ..charger.sendIfChanged(newValues.switchOnOff.charger, communicationController.prc10.command.adjustChargerSwitchCurrent)
      ..inverter.sendIfChanged(newValues.switchOnOff.inverter, communicationController.prc10.command.adjustInverterSwitchCurrent)
      ..heater.sendIfChanged(newValues.switchOnOff.heater, communicationController.prc10.command.adjustHeaterSwitchCurrent);
  }

  void sendMotorsCurrentsValues() {
    dataController.adjustment.motor
      ..table.sendIfChanged(newValues.motor.table, communicationController.prc10.command.adjustTableCurrent, communicationController.prc10.command.adjustTableTime)
      ..slider.sendIfChanged(newValues.motor.slider, communicationController.prc10.command.adjustSliderCurrent, communicationController.prc10.command.adjustSliderTime)
      ..backSlider.sendIfChanged(newValues.motor.backSlider, communicationController.prc10.command.adjustBackCurrent, communicationController.prc10.command.adjustBackTime)
      ..awning.sendIfChanged(newValues.motor.awning, communicationController.prc10.command.adjustAwningCurrent, communicationController.prc10.command.adjustAwningTime)
      ..floodgateGreyWater.sendIfChanged(newValues.motor.floodgateGreyWater, communicationController.prc10.command.adjustFloodgateGreyCurrent, communicationController.prc10.command.adjustFloodgateGreyTime)
      ..floodgateBlackWater.sendIfChanged(newValues.motor.floodgateBlackWater, communicationController.prc10.command.adjustFloodgateBlackCurrent, communicationController.prc10.command.adjustFloodgateBlackTime);
  }

  void sendOthersValues() {
    dataController.adjustment.other
      ..sendVoltagesIfChanged(newValues.other, communicationController.prc10.command.adjustVoltages)
      ..sendModesIfChanged(newValues.other, communicationController.prc10.command.adjustGeneratorAndInverterMode);
    dataController.adjustment.other.storedLocally.storeIfChanged(newValues.other.storedLocally);
  }
}

enum ConfigItem {
  switches('interruptores'),
  engines('motores'),
  times('tiempos'),
  others('otras'),
  appearance('aspecto');

  final String name;

  const ConfigItem(this.name);
}


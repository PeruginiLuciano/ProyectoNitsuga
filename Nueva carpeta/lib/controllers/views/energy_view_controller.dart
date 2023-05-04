import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/enums.dart';
import 'package:motorhome/utils/utils.dart';

class EnergyViewController extends GetxController {

  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  var automaticMode = false.obs;

  var charger = TriState.disabled.obs;
  var inverter = TriState.disabled.obs;
  var waterBoiler = TriState.disabled.obs;
  var bottledGas = TriState.disabled.obs;

  void switchGeneratorOnButton(SwitchStatus switchStatus) async {
    if (!automaticMode.value) {
      communicationController.prc10.command.switchGeneratorOnButton(switchStatus);
    } else {
    }
  }

  void switchGeneratorOffButton(SwitchStatus switchStatus) async {
    if (!automaticMode.value) {
      communicationController.prc10.command.switchGeneratorOffButton(switchStatus);
    }
  }

  void switchPrimer() async {
    if (!automaticMode.value) {
      dataController.generatorPrimerSwitch.value = !dataController.generatorPrimerSwitch.value;
      communicationController.prc10.command.switchGeneratorPrimerButton(
          dataController.generatorPrimerSwitch.value ? SwitchStatus.on : SwitchStatus.off);
    }
  }

  void switchCharger() async {
    if (charger.value != TriState.waiting) {
      var initialValue = charger.value;
      charger.value = TriState.waiting;
      communicationController.prc10.command.switchCharger(initialValue == TriState.enabled ? SwitchStatus.off : SwitchStatus.on);
      await delay(2000);
      charger.value = initialValue == TriState.enabled ? TriState.disabled : TriState.enabled;
    }
  }

  void switchInverter() async {
    if (inverter.value != TriState.waiting) {
      var initialValue = inverter.value;
      inverter.value = TriState.waiting;
      communicationController.prc10.command.switchInverter(initialValue == TriState.enabled ? SwitchStatus.off : SwitchStatus.on);
      await delay(2000);
      inverter.value = initialValue == TriState.enabled ? TriState.disabled : TriState.enabled;
    }
  }

  void switchWaterBoiler() async {
    if (waterBoiler.value != TriState.waiting) {
      var initialValue = waterBoiler.value;
      waterBoiler.value = TriState.waiting;
      await delay(2000);
      waterBoiler.value = initialValue == TriState.enabled ? TriState.disabled : TriState.enabled;
    }
  }

  void switchBottledGas() async {
    if (bottledGas.value != TriState.waiting) {
      var initialValue = bottledGas.value;
      bottledGas.value = TriState.waiting;
      await delay(2000);
      bottledGas.value = initialValue == TriState.enabled ? TriState.disabled : TriState.enabled;
    }
  }
}

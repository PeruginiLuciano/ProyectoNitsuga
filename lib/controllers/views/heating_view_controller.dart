import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/air_conditioning.dart';
import 'package:motorhome/controllers/models/heater.dart';
import 'package:motorhome/controllers/models/switch.dart';

class HeatingViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  var acTemperature = 24.obs;

  void switchAc() async {
    dataController.airConditioning.power.value = !dataController.airConditioning.power.value;
    _sendAcValues();
  }

  void switchAcMode(AirConditioningMode mode) async {
    dataController.airConditioning.acMode.value = mode;
    if (dataController.airConditioning.acMode.value == AirConditioningMode.cold) {
      acTemperature.value = dataController.airConditioning.cold.temperature;
    } else {
      acTemperature.value = dataController.airConditioning.hot.temperature;
    }
    _sendAcValues();
  }

  void setAcTemperature(bool increment) async {
    if (increment) {
      if (++acTemperature.value > 30) {
        acTemperature.value = 30;
        return;
      }
    } else {
      if (--acTemperature.value < 17) {
        acTemperature.value = 17;
        return;
      }
    }
    if (dataController.airConditioning.acMode.value == AirConditioningMode.cold) {
      dataController.airConditioning.cold.temperature = acTemperature.value;
    } else {
      dataController.airConditioning.hot.temperature = acTemperature.value;
    }
    _sendAcValues();
  }

  void _sendAcValues() =>
    communicationController.caa10.command.setValues(
        dataController.airConditioning.power.value ? SwitchStatus.on : SwitchStatus.off,
        dataController.airConditioning.acMode.value == AirConditioningMode.cold ? dataController.airConditioning.cold.acFanSpeed.toCaa100fanSpeed() : dataController.airConditioning.hot.acFanSpeed.toCaa100fanSpeed(),
        dataController.airConditioning.acMode.value == AirConditioningMode.cold ? dataController.airConditioning.cold.temperature : dataController.airConditioning.hot.temperature,
        dataController.airConditioning.acMode.value.toCaa100mode()
    );


  void switchHeater() {
    dataController.heater.power.value = !dataController.heater.power.value;
    _sendHeaterValues();
  }

  void switchHeaterMode(HeaterMode mode) {
    dataController.heater.mode.value = mode;
    _sendAcValues();
  }

  void _sendHeaterValues() =>
      communicationController.ctrlcal100.command.setMode(dataController.heater.power.value ? SwitchStatus.on : SwitchStatus.off, dataController.heater.mode.value.toCtrlcal100mode(), dataController.heater.powerLevel.value);

  void setHeaterTemperature(bool increment) {
    if (increment) {
      if (++dataController.heater.powerLevel.value > 5) {
        dataController.heater.powerLevel.value = 5;
        return;
      }
    } else {
      if (--dataController.heater.powerLevel.value < 1) {
        dataController.heater.powerLevel.value = 1;
        return;
      }
    }
    _sendHeaterValues();
  }
}

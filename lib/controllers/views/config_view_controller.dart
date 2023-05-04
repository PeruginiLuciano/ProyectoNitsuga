import 'dart:math';

import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/switch.dart';

class ConfigViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  var currentConfig = ControlList.screen.obs;

  final List<int> sleepScreenOptions = [2, 5, 10];
  var _currentSleepOption = 0;
  var sleepTimeValue = 0.obs;

  @override
  void onInit() async {
    _currentSleepOption = sleepScreenOptions.first;
    sleepTimeValue.value = sleepScreenOptions[_currentSleepOption];
    super.onInit();
  }

  void changeSleepTime() async {
    if (++_currentSleepOption >= sleepScreenOptions.length) {
      _currentSleepOption = 0;
    }
    sleepTimeValue.value = sleepScreenOptions[_currentSleepOption];
  }

  void switchWaterPumperProtection() async {
    dataController.protection.turnOffWaterPumper.value = !dataController.protection.turnOffWaterPumper.value;
    communicationController.prc10.command.setWaterPumperAutomaticProtectionStatus(dataController.protection.turnOffWaterPumper.value ? SwitchStatus.on : SwitchStatus.off);
  }

  void switchFloodgateGreyWaterProtection() async {
    dataController.protection.closeFloodgateGreyWater.value = !dataController.protection.closeFloodgateGreyWater.value;
    communicationController.prc10.command.setFloodgateGreyWaterAutomaticProtectionStatus(dataController.protection.closeFloodgateGreyWater.value ? SwitchStatus.on : SwitchStatus.off);
  }

  void switchFloodgateBlackWaterProtection() async {
    dataController.protection.closeFloodgateBlackWater.value = !dataController.protection.closeFloodgateBlackWater.value;
    communicationController.prc10.command.setFloodgateBlackWaterAutomaticProtectionStatus(dataController.protection.closeFloodgateBlackWater.value ? SwitchStatus.on : SwitchStatus.off);
  }

  void switchAutomaticStartGeneratorProtection() async {
    dataController.protection.automaticStartGenerator.value = !dataController.protection.automaticStartGenerator.value;
    communicationController.prc10.command.setAutomaticStartGeneratorProtectionStatus(dataController.protection.automaticStartGenerator.value ? SwitchStatus.on : SwitchStatus.off);
  }
}

enum ControlList {
  screen,
  protections
}

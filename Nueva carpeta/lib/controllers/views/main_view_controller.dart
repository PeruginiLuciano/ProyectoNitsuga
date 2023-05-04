import 'dart:async';

import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/adjustment.dart';
import 'package:motorhome/utils/routes.dart';

class MainViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  var page = Pages.home.obs;

  Timer? _sensorsReadTimer;
  int _sensorCounter = 0;

  @override
  void onInit() async {
    _sensorsReadTimer =  Timer.periodic(const Duration(milliseconds: 1000), _readSensorCallback);
    super.onInit();
  }


  void _readSensorCallback(Timer timer) async {
    switch(_sensorCounter) {
      case 0:
        communicationController.prc10.command.getAcVoltage();
        communicationController.prc10.command.getAcCurrent();
        communicationController.prc10.command.getAcFrequency();
        communicationController.prc10.command.getAcSource();
        break;
      case 1:
        communicationController.prc10.command.getDcVoltage();
        communicationController.prc10.command.getDcCurrent();
        break;
      case 2:
        if (dataController.adjustment.other.storedLocally.waterLevelsSource.value == AdjustmentWaterLevelSource.prc10) {
          communicationController.prc10.command.getPotableWaterLevel();
          communicationController.prc10.command.getGreyWaterLevel();
          communicationController.prc10.command.getBlackWaterLevel();
        } else {
          communicationController.tank100.command.getPotableWaterLevel();
          communicationController.tank100.command.getGreyWaterLevel();
          communicationController.tank100.command.getBlackWaterLevel();
          communicationController.tank100.command.getAuxWaterLevel();
        }
        break;
      case 3:
        communicationController.prc10.command.getSwitchesStatuses();
        communicationController.prc10.command.getMotorsStatuses();
        break;
      case 4:
        communicationController.prc10.command.getAutomaticProtectionsStatuses();
        communicationController.prc10.command.getDimmerValue();
        break;
      case 5:
        communicationController.rgb100.command.getState();
        break;
      case 6:
        if (dataController.adjustment.other.storedLocally.musicEnabled.value) {
          communicationController.ca102.command.getPowerStatus();
          communicationController.ca102.command.getSources();
          break;
        } else {
          _sensorCounter++;
          continue seven;
        }
      seven:
      case 7:
        if (dataController.adjustment.other.storedLocally.musicEnabled.value) {
          communicationController.ca102.command.getMainGain();
          communicationController.ca102.command.getVolume();
          communicationController.ca102.command.getEqualizerGains();
          break;
        } else {
          _sensorCounter++;
          continue eight;
        }
      eight:
      case 8:
        if (dataController.adjustment.other.storedLocally.gasSensorEnabled.value) {
          communicationController.sg100.command.getQuality();
        } else {
          _sensorCounter++;
        }
        break;
      default:
    }
    _sensorCounter++;
    if (_sensorCounter >= 13) {
      _sensorCounter = 0;
    }
  }
}

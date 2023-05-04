import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/devices/prc10.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/utils/theme.dart';

class MotorsViewController extends GetxController {
  static const animationDuration = 1200;

  var currentMotor = MotorsList.slider.obs;

  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  AnimationController? sliderAnimationController;
  var sliderAuto = false.obs;
  var sliderAnimationName = MHAnimations.sliderOpening.obs;

  AnimationController? tableAnimationController;
  var tableAuto = false.obs;
  var tableAnimationName = MHAnimations.tableOpening.obs;

  AnimationController? awningAnimationController;
  var awningAuto = false.obs;
  var awningAnimationName = MHAnimations.awningOpening.obs;

  var levelerAuto = false.obs;
  var levelerButton = [false, false].obs;
  var levelerSwitch = [false, false, false, false].obs;

  Timer? _accReader;

  @override
  void dispose() {
    _accReader?.cancel();
    super.dispose();
  }

  void switchMotor(MotorsList optionItem) {
    currentMotor.value = optionItem;
  }

  void switchAuto() {
    switch(currentMotor.value) {
      case MotorsList.slider:
        sliderAuto.value = !sliderAuto.value;
        if (dataController.sliderStatus.value != MotorStatus.opened && dataController.sliderStatus.value != MotorStatus.closed) {
          dataController.sliderStatus.value = MotorStatus.stopped;
          sliderAnimationController?.stop();
        }
        break;
      case MotorsList.table:
        tableAuto.value = !tableAuto.value;
        if (dataController.tableStatus.value != MotorStatus.opened && dataController.tableStatus.value != MotorStatus.closed) {
          dataController.tableStatus.value = MotorStatus.stopped;
          tableAnimationController?.stop();
        }
        break;
      case MotorsList.awning:
        awningAuto.value = !awningAuto.value;
        if (dataController.awningStatus.value != MotorStatus.opened && dataController.awningStatus.value != MotorStatus.closed) {
          dataController.awningStatus.value = MotorStatus.stopped;
          awningAnimationController?.stop();
        }
        break;
      case MotorsList.leveler:
        levelerAuto.value = !levelerAuto.value;
        communicationController.prm200.command.autoAdjust(cancel: !levelerAuto.value);
        break;
    }
  }

  void _onTapDown(bool opening, Rx<bool> autoMode, Rx<MotorStatus> motorStatus, AnimationController? animationController, Function(MotorAction) onAction, Function(bool) animationName) {
    if (autoMode.value &&
        (opening && motorStatus.value == MotorStatus.opening ||
            !opening && motorStatus.value == MotorStatus.closing)) {
      animationController?.stop();
      motorStatus.value = MotorStatus.stopped;
      onAction(MotorAction.stop);
    } else
    if (opening && motorStatus.value != MotorStatus.opened ||
        !opening && motorStatus.value != MotorStatus.closed) {
      animationName(opening);
      animationController?.repeat(period: const Duration(milliseconds: animationDuration));
      motorStatus.value = opening ? MotorStatus.opening : MotorStatus.closing;
      onAction(opening ? MotorAction.open : MotorAction.close);
    }
  }

  void _onTapUp(bool opening, Rx<bool> autoMode, Rx<MotorStatus> motorStatus, AnimationController? animationController, Function(MotorAction) onAction) {
    if (!autoMode.value &&
        (opening && motorStatus.value == MotorStatus.opening ||
            !opening && motorStatus.value == MotorStatus.closing)) {
      animationController?.stop();
      motorStatus.value = MotorStatus.stopped;
      onAction(MotorAction.stop);
    }
  }

  void buttonSliderTapDown(bool opening) {
    _onTapDown(opening, sliderAuto, dataController.sliderStatus, sliderAnimationController, communicationController.prc10.command.sendSliderAction, (opening) {
      sliderAnimationName.value = opening ? MHAnimations.sliderOpening : MHAnimations.sliderClosing;
    });
  }
  
  void buttonSliderTapUp(bool opening) {
    _onTapUp(opening, sliderAuto, dataController.sliderStatus, sliderAnimationController, communicationController.prc10.command.sendSliderAction);
  }

  void buttonTableTapDown(bool opening) {
    _onTapDown(opening, tableAuto, dataController.tableStatus, tableAnimationController, communicationController.prc10.command.sendTableAction, (opening) {
      tableAnimationName.value = opening ? MHAnimations.tableOpening : MHAnimations.tableClosing;
    });
  }

  void buttonTableTapUp(bool opening) {
    _onTapUp(opening, tableAuto, dataController.tableStatus, tableAnimationController, communicationController.prc10.command.sendTableAction);
  }

  void buttonAwningTapDown(bool opening) {
    _onTapDown(opening, awningAuto, dataController.awningStatus, awningAnimationController, communicationController.prc10.command.sendAwningAction, (opening) {
      awningAnimationName.value = opening ? MHAnimations.awningOpening : MHAnimations.awningClosing;
    });
  }

  void buttonAwningTapUp(bool opening) {
    _onTapUp(opening, awningAuto, dataController.awningStatus, awningAnimationController, communicationController.prc10.command.sendAwningAction);
  }

  void buttonLevelerTapDown(bool increasing) {
    _accReader =  Timer.periodic(const Duration(milliseconds: 300), _readAccCallback);
    dataController.levelerSwitchActive.value = levelerSwitch.value;
    if (increasing) {
      levelerButton[0] = true;
      communicationController.prm200.command.increase(levelerSwitch);
    } else {
      levelerButton[1] = true;
      communicationController.prm200.command.decrease(levelerSwitch);
    }
  }

  void buttonLevelerTapUp() {
    _accReader?.cancel();
    levelerButton.value = [false, false];
    dataController.levelerSwitchActive.value = [false, false, false, false];
    communicationController.prm200.command.stop();
  }

  void _readAccCallback(Timer timer) {
    communicationController.acc200.command.getState();
  }
}

enum MotorsList {
  slider("DESPLAZABLE"),
  table("MESA"),
  awning("TOLDO"),
  leveler("NIVELADOR");

  final String title;
  const MotorsList(this.title);
}

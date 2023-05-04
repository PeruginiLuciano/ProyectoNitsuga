import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/devices/prc10.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/views/screens/motors_screen.dart';

class MotorsViewController extends GetxController {
  static const animationDuration = 1200;

  var currentMotor = MotorsList.slider.obs;

  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  AnimationController? sliderAnimationController;
  var sliderAuto = false.obs;

  AnimationController? tableAnimationController;
  var tableAuto = false.obs;

  AnimationController? awningAnimationController;
  var awningAuto = false.obs;

  var levelerAuto = false.obs;
  var levelerButton = [false, false].obs;
  var levelerSwitch = 0.obs;
  var levelerPinPosition = [45, 45].obs;

  Timer? accReader;

  @override
  void dispose() {
    sliderAnimationController?.dispose();
    tableAnimationController?.dispose();
    awningAnimationController?.dispose();
    super.dispose();
  }

  void switchMotor(MotorsList optionItem) {
    currentMotor.value = optionItem;
    if (optionItem == MotorsList.leveler) {
      accReader =  Timer.periodic(const Duration(milliseconds: 300), _readAccCallback);
    } else {
      accReader?.cancel();
    }
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
        levelerSwitch.value = 0;
        break;
    }
  }

  void _onTapDown(bool isOpening, Rx<bool> isAutoMode, Rx<MotorStatus> motorStatus, Function(MotorAction) onAction) {
    if (isAutoMode.value &&
        (isOpening && motorStatus.value == MotorStatus.opening ||
            !isOpening && motorStatus.value == MotorStatus.closing)) {
      motorStatus.value = MotorStatus.stopped;
      onAction(MotorAction.stop);
    } else
    if (isOpening && motorStatus.value != MotorStatus.opened ||
        !isOpening && motorStatus.value != MotorStatus.closed) {
      motorStatus.value = isOpening ? MotorStatus.opening : MotorStatus.closing;
      onAction(isOpening ? MotorAction.open : MotorAction.close);
    }
  }

  void _onTapUp(bool isOpening, Rx<bool> autoMode, Rx<MotorStatus> motorStatus, Function(MotorAction) onAction) {
    if (!autoMode.value &&
        (isOpening && motorStatus.value == MotorStatus.opening ||
            !isOpening && motorStatus.value == MotorStatus.closing)) {
      motorStatus.value = MotorStatus.stopped;
      onAction(MotorAction.stop);
    }
  }

  void buttonSliderTapDown(bool isOpening) {
    _onTapDown(isOpening, sliderAuto, dataController.sliderStatus, communicationController.prc10.command.sendSliderAction);
  }
  
  void buttonSliderTapUp(bool isOpening) {
    _onTapUp(isOpening, sliderAuto, dataController.sliderStatus, communicationController.prc10.command.sendSliderAction);
  }

  void buttonTableTapDown(bool isOpening) {
    _onTapDown(isOpening, tableAuto, dataController.tableStatus, communicationController.prc10.command.sendTableAction);
  }

  void buttonTableTapUp(bool isOpening) {
    _onTapUp(isOpening, tableAuto, dataController.tableStatus, communicationController.prc10.command.sendTableAction);
  }

  void buttonAwningTapDown(bool isOpening) {
    _onTapDown(isOpening, awningAuto, dataController.awningStatus, communicationController.prc10.command.sendAwningAction);
  }

  void buttonAwningTapUp(bool isOpening) {
    _onTapUp(isOpening, awningAuto, dataController.awningStatus, communicationController.prc10.command.sendAwningAction);
  }

  void buttonLevelerTapDown(bool isOpening) {
    if (levelerAuto.value) {
      levelerButton[0] = !isOpening && !levelerButton[0];
      levelerButton[1] = isOpening && !levelerButton[1];
      communicationController.prm200.command.autoAdjust(isOpening);
    }
    else if (isOpening) {
      levelerButton[1] = true;
      dataController.levelerSwitchActive[levelerSwitch.value - 1] = MotorStatus.opening;
      communicationController.prm200.command.open(levelerSwitch.value);
    } else {
      levelerButton[0] = true;
      dataController.levelerSwitchActive[levelerSwitch.value - 1] = MotorStatus.closing;
      communicationController.prm200.command.close(levelerSwitch.value);
    }
  }

  void buttonLevelerTapUp() {
    if (!levelerAuto.value) {
      levelerButton.value = [false, false];
    }
    if (levelerSwitch.value > 0) {
      dataController.levelerSwitchActive[levelerSwitch.value - 1] = MotorStatus.stopped;
    }
    communicationController.prm200.command.stop();
  }

  void _readAccCallback(Timer timer) {
    communicationController.acc200.command.getState();
  }

  void syncAnimations(MotorsScreenState motorsScreenState) {
    sliderAnimationController = AnimationController(vsync: motorsScreenState, duration: const Duration(seconds: 1));
    tableAnimationController = AnimationController(vsync: motorsScreenState, duration: const Duration(seconds: 1));
    awningAnimationController = AnimationController(vsync: motorsScreenState, duration: const Duration(seconds: 1));

    _setMotorAnimationListener(dataController.sliderStatus, sliderAnimationController);
    _setMotorAnimationListener(dataController.tableStatus, tableAnimationController);
    _setMotorAnimationListener(dataController.awningStatus, awningAnimationController);
  }

  void _setMotorAnimationListener(Rx<MotorStatus> motorStatus, AnimationController? animationController) {
    motorStatus.listenAndPump((MotorStatus status) {
      switch(status) {
        case MotorStatus.opened:
          animationController?.stop();
          animationController?.animateTo(1, duration: Duration.zero);
          break;
        case MotorStatus.closed:
          animationController?.stop();
          animationController?.animateTo(0, duration: Duration.zero);
          break;
        case MotorStatus.opening:
          animationController?.repeat();
          break;
        case MotorStatus.closing:
          animationController?.reverse().whenComplete(() => onReverseComplete(animationController));
          break;
        default:
          animationController?.stop();
          animationController?.animateTo(0.5, duration: Duration.zero);
          break;
      }
    });
  }

  void onReverseComplete(AnimationController animationController) {
    animationController.reverse().whenComplete(() {
      animationController.animateTo(1, duration: Duration.zero);
      onReverseComplete(animationController);
    });
  }

  void onDispose() {
    accReader?.cancel();
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

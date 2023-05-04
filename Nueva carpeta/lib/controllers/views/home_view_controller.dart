import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/devices/prc10.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/modals/modal_unlock.dart';

class HomeViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  void switchWaterPump() {
    dataController.waterPumper.value = !dataController.waterPumper.value;
    communicationController.prc10.command.switchWaterPumper(dataController.waterPumper.value ? SwitchStatus.on : SwitchStatus.off);
  }

  void switchGreyWaterLock() async {
    if (dataController.floodgateGreyWaterStatus.value == MotorStatus.closed) {
      _showDialog(() {
        dataController.floodgateGreyWaterStatus.value = MotorStatus.unknown;
        communicationController.prc10.command.sendFloodgateGreyAction(MotorAction.open);
      });
    } else {
      dataController.floodgateGreyWaterStatus.value = MotorStatus.unknown;
      communicationController.prc10.command.sendFloodgateGreyAction(MotorAction.close);
    }
  }

  void switchBlackWaterLock() async {
    if (dataController.floodgateBlackWaterStatus.value == MotorStatus.closed) {
      _showDialog(() {
        dataController.floodgateBlackWaterStatus.value = MotorStatus.unknown;
        communicationController.prc10.command.sendFloodgateBlackAction(MotorAction.open);
      });
    } else {
      dataController.floodgateBlackWaterStatus.value = MotorStatus.unknown;
      communicationController.prc10.command.sendFloodgateBlackAction(MotorAction.close);
    }
  }

  void _showDialog(Function onAccept) {
    Dialogs.launch(
        child: ModalUnlock(
          title: 'CONFIRMAR APERTURA DE ESCLUSA',
          onAccept: () {
            onAccept();
          },
        )
    );
  }
}

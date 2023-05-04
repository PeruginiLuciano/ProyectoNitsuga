import 'dart:ui';

import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/dimmer_timer.dart';
import 'package:motorhome/controllers/models/switch.dart';

class LightsViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  DimmerTimer? interiorLightDimmer;
  DimmerTimer? environmentLightDimmer;

  @override
  void onInit() {
    interiorLightDimmer = DimmerTimer((value) {
      communicationController.prc10.command.sendDimmerValue(value);
    });
    environmentLightDimmer = DimmerTimer((value) {
      dataController.environmentLight.value.dimmer(value / 100);
      final color = dataController.environmentLight.value;
      communicationController.rgb100.command.setRgb(color.red, color.green, color.blue);
    });
    super.onInit();
  }

  void switchInterior() async {
    dataController.interiorLight.value = !dataController.interiorLight.value;
    communicationController.prc10.command.switchInteriorLight(
      dataController.interiorLight.value ? SwitchStatus.on : SwitchStatus.off
    );
  }

  void switchExterior() async {
    dataController.exteriorLight.value = !dataController.exteriorLight.value;
    communicationController.prc10.command.switchExteriorLight(
        dataController.exteriorLight.value ? SwitchStatus.on : SwitchStatus.off
    );
  }

  void switchEnvironmental() async {
    dataController.environmentLight.value = dataController.environmentLight.value.copy(
      power: !dataController.environmentLight.value.power
    );
    communicationController.rgb100.command.power(
        dataController.environmentLight.value.power ? SwitchStatus.on : SwitchStatus.off
    );
  }

  void sendColor(Color color) async {
    communicationController.rgb100.command.setColor(color);
  }

  // int color = Color.HSVToColor(EnvironmentColor);
  // CUSTOM_RGB100.CMD_SET_RGB(Color.red(color), Color.green(color), Color.blue(color));
}

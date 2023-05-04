import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/modal_adjust_controller.dart';
import 'package:motorhome/views/widgets/adjust_custom_row.dart';

class ListApperance extends StatelessWidget {
  const ListApperance({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModalAdjustViewController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdjustCustomRow(
          title: 'SENSOR DE GASES',
          values: const ['NO', 'SI'],
          initialValue: controller.dataController.adjustment.other.storedLocally.gasSensorEnabled.value ? "SI" : "NO",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.gasSensorEnabled.value = indexValue != 0;
          }
        ),

        AdjustCustomRow(
          title: 'CLIMATIZACIÓN',
          values: const ['NO', 'SI'],
          initialValue: controller.dataController.adjustment.other.storedLocally.hvacEnabled.value ? "SI" : "NO",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.hvacEnabled.value = indexValue != 0;
          }
        ),

        AdjustCustomRow(
          title: 'TOLDO',
          values: const ['NO', 'SI'],
          initialValue: controller.dataController.adjustment.other.storedLocally.awningEnabled.value ? "SI" : "NO",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.awningEnabled.value = indexValue != 0;
          }
        ),

        AdjustCustomRow(
          title: 'MÚSICA',
          values: const ['NO', 'SI'],
          initialValue: controller.dataController.adjustment.other.storedLocally.musicEnabled.value ? "SI" : "NO",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.musicEnabled.value = indexValue != 0;
          }
        ),
      ],
    );
  }
}
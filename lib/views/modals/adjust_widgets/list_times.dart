import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/modal_adjust_controller.dart';
import 'package:motorhome/views/widgets/adjust_row.dart';

class ListTimes extends StatelessWidget {
  const ListTimes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModalAdjustViewController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdjustRow(
          title: 'MESA - ARRIBA',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.table.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.table.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.table.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'MESA - ABAJO',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.table.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.table.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.table.close.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE LIVING - AFUERA',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.slider.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.slider.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.slider.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE LIVING - ADENTRO',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.slider.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.slider.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.slider.close.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE TRASERO - AFUERA',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.backSlider.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.backSlider.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.backSlider.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE TRASERO - ADENTRO',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.backSlider.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.backSlider.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.backSlider.close.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'TOLDO - AFUERA',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.awning.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.awning.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.awning.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'TOLDO - ADENTRO',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.awning.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.awning.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.awning.close.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA GRIS - ABRIR',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.floodgateGreyWater.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateGreyWater.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.floodgateGreyWater.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA GRIS - CERRAR',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.floodgateGreyWater.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateGreyWater.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.floodgateGreyWater.close.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA NEGRA - ABRIR',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.floodgateBlackWater.open.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateBlackWater.open.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.floodgateBlackWater.open.timeLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA NEGRA - CERRAR',
          unit: "seg.",
          fixedValue: controller.dataController.adjustment.motor.floodgateBlackWater.close.timeLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateBlackWater.close.timeLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.motor.floodgateBlackWater.close.timeLimitAdjustment.value = value;
          }
        ),
      ],
    );
  }
}
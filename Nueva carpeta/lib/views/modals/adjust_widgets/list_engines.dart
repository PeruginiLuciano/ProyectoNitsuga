import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/modal_adjust_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/views/widgets/adjust_row.dart';

class ListEnginesTitle extends StatelessWidget {
  const ListEnginesTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          flex: 6,
          child: Text('MOTOR - LÍMITE', style: MHTextStyles.adjustmentTitle),
        ),
        Expanded(
          flex: 2,
          child: Text('FIJO', style: MHTextStyles.adjustmentTitle),
        ),
        Expanded(
          flex: 3,
          child: Text('AJUSTE', style: MHTextStyles.adjustmentTitle, textAlign: TextAlign.center),
        )
      ],
    );
  }
}

class ListEngines extends StatelessWidget {
  const ListEngines({
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
          fixedValue: controller.dataController.adjustment.motor.table.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.table.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.table.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'MESA - ABAJO',
          fixedValue: controller.dataController.adjustment.motor.table.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.table.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.table.close.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE LIVING - AFUERA',
          fixedValue: controller.dataController.adjustment.motor.slider.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.slider.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.slider.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE LIVING - ADENTRO',
          fixedValue: controller.dataController.adjustment.motor.slider.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.slider.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.slider.close.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE TRASERO - AFUERA',
          fixedValue: controller.dataController.adjustment.motor.backSlider.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.backSlider.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.backSlider.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'DESPLAZABLE TRASERO - ADENTRO',
          fixedValue: controller.dataController.adjustment.motor.backSlider.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.backSlider.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.backSlider.close.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'TOLDO - AFUERA',
          fixedValue: controller.dataController.adjustment.motor.awning.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.awning.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.awning.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'TOLDO - ADENTRO',
          fixedValue: controller.dataController.adjustment.motor.awning.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.awning.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.awning.close.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA GRIS - ABRIR',
          fixedValue: controller.dataController.adjustment.motor.floodgateGreyWater.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateGreyWater.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.floodgateGreyWater.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA GRIS - CERRAR',
          fixedValue: controller.dataController.adjustment.motor.floodgateGreyWater.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateGreyWater.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.floodgateGreyWater.close.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA NEGRA - ABRIR',
          fixedValue: controller.dataController.adjustment.motor.floodgateBlackWater.open.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateBlackWater.open.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.floodgateBlackWater.open.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'ESCLUSA AGUA NEGRA - CERRAR',
          fixedValue: controller.dataController.adjustment.motor.floodgateBlackWater.close.currentLimit.value,
          initialValue: controller.dataController.adjustment.motor.floodgateBlackWater.close.currentLimitAdjustment.value,
          limit: 2.5,
          onChange: (value) {
            controller.newValues.motor.floodgateBlackWater.close.currentLimitAdjustment.value = value;
          }
        ),
      ],
    );
  }
}
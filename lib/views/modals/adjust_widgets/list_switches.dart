import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/modal_adjust_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/views/widgets/adjust_row.dart';

class ListSwitchesTitle extends StatelessWidget {
  const ListSwitchesTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          flex: 6,
          child: Text('INTERRUPTOR', style: MHTextStyles.adjustmentTitle),
        ),
        Expanded(
          flex: 2,
          child: Text('FIJO', style: MHTextStyles.adjustmentTitle),
        ),
        Expanded(
          flex: 3,
          child: Text('AJUSTE', style: MHTextStyles.adjustmentTitle, textAlign: TextAlign.center,),
        )
      ],
    );
  }
}

class ListSwitches extends StatelessWidget {
  const ListSwitches({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModalAdjustViewController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdjustRow(
          title: 'LUZ INTERIOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.interiorLight.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.interiorLight.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.interiorLight.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'LUZ EXTERIOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.exteriorLight.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.exteriorLight.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.exteriorLight.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'LUZ BAÚL',
          fixedValue: controller.dataController.adjustment.switchOnOff.vaultLight.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.vaultLight.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.vaultLight.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'BOMBA DE AGUA',
          fixedValue: controller.dataController.adjustment.switchOnOff.waterPumper.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.waterPumper.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.waterPumper.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GRUPO ELECTROGENO - ENCENDIDO',
          fixedValue: controller.dataController.adjustment.switchOnOff.generatorOn.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generatorOn.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generatorOn.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GRUPO ELECTROGENO - APAGADO',
          fixedValue: controller.dataController.adjustment.switchOnOff.generatorOff.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generatorOff.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generatorOff.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GRUPO ELECTROGENO - CEBADOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.generatorPrimer.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generatorPrimer.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generatorPrimer.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GENÉRICA 1',
          fixedValue: controller.dataController.adjustment.switchOnOff.generic1.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generic1.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generic1.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GENÉRICA 2',
          fixedValue: controller.dataController.adjustment.switchOnOff.generic2.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generic2.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generic2.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'GENERICA 3',
          fixedValue: controller.dataController.adjustment.switchOnOff.generic3.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.generic3.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.generic3.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'CARGADOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.charger.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.charger.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.charger.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'INVERSOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.inverter.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.inverter.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.inverter.currentLimitAdjustment.value = value;
          }
        ),

        AdjustRow(
          title: 'CALEFACTOR',
          fixedValue: controller.dataController.adjustment.switchOnOff.heater.currentLimit.value,
          initialValue: controller.dataController.adjustment.switchOnOff.heater.currentLimitAdjustment.value,
          onChange: (value) {
            controller.newValues.switchOnOff.heater.currentLimitAdjustment.value = value;
          }
        ),
      ],
    );
  }
}
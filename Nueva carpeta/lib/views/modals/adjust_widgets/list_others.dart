import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:motorhome/controllers/models/adjustment.dart";
import "package:motorhome/controllers/views/modal_adjust_controller.dart";
import "package:motorhome/utils/constants.dart";
import 'package:motorhome/utils/extensions.dart';
import "package:motorhome/utils/theme.dart";
import "package:motorhome/views/widgets/adjust_custom_row.dart";

class ListOthersTitle extends StatelessWidget {
  const ListOthersTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          flex: 6,
          child: Text("DESCRIPCIÓN", style: MHTextStyles.adjustmentTitle),
        ),
        Expanded(
          flex: 2,
          child: Text("VALOR", style: MHTextStyles.adjustmentTitle),
        ),
      ],
    );
  }
}

class ListOthers extends StatelessWidget {
  const ListOthers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModalAdjustViewController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdjustCustomRow(
          title: "ORINGEN TEMPERATURA",
          values: AdjustmentTemperatureSource.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.storedLocally.temperatureSource.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.temperatureSource.value = AdjustmentTemperatureSource.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "ORINGEN TANQUES",
          values: AdjustmentWaterLevelSource.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.storedLocally.waterLevelsSource.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.waterLevelsSource.value = AdjustmentWaterLevelSource.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "TENSIÓN MESA",
          values: AdjustmentTableVoltage.values.map((e) => "${e.value}V").toList(),
          initialValue: "${controller.dataController.adjustment.other.tableVoltage.value}V",
          onChange: (indexValue) {
            controller.newValues.other.tableVoltage.value = AdjustmentTableVoltage.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "AJUSTE BATERÍA",
          values: controller.batteryAdjustmentValues.map((e) => "${e.toStringIncludingSign(1)}V").toList(),
          initialValue: "${controller.dataController.adjustment.other.batteryVoltage.value.toStringIncludingSign(1)}V",
          onChange: (indexValue) {
            controller.newValues.other.batteryVoltage.value = controller.batteryAdjustmentValues[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "AJUSTE AC",
          values: controller.acAdjustmentValues.map((e) => "${e.toStringIncludingSign()}V").toList(),
          initialValue: "${controller.dataController.adjustment.other.acVoltage.value.toInt().toStringIncludingSign()}V",
          onChange: (indexValue) {
            controller.newValues.other.acVoltage.value = controller.acAdjustmentValues[indexValue].toDouble();
          }
        ),

        AdjustCustomRow(
          title: "BLOQUEA MOTORES",
          values: AdjustmentMotorsBlocker.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.storedLocally.motorsBlocker.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.motorsBlocker.value = AdjustmentMotorsBlocker.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "ARRANQUE GRUPO",
          values: AdjustmentGeneratorMode.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.generatorMode.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.generatorMode.value = AdjustmentGeneratorMode.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "BOTON AUTOMATICO",
          values: AdjustmentGeneratorAutoButtonFunction.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.storedLocally.generatorAutoButtonFunction.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.generatorAutoButtonFunction.value = AdjustmentGeneratorAutoButtonFunction.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "ENCENDER INVERSOR",
          values: AdjustmentInverterMode.values.map((e) => e.legibleName).toList(),
          initialValue: controller.dataController.adjustment.other.inverterMode.value.legibleName,
          onChange: (indexValue) {
            controller.newValues.other.inverterMode.value = AdjustmentInverterMode.values[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "BLUETOOTH",
          values: const ["DESACTIVADO", "ACTIVADO"],
          initialValue: controller.dataController.adjustment.other.storedLocally.bluetoothEnabled.value ? "ACTIVADO" : "DESACTIVADO",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.bluetoothEnabled.value = indexValue != 0;
          }
        ),

        AdjustCustomRow(
          title: "CALIDAD DE AIRE (${MHConstants.airQualityFixedValue})",
          values: controller.airQualityValues.map((e) => e.toStringIncludingSign()).toList(),
          initialValue: controller.dataController.adjustment.other.storedLocally.airQualityValue.value.toStringIncludingSign(),
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.airQualityValue.value = controller.airQualityValues[indexValue];
          }
        ),

        AdjustCustomRow(
          title: "TIEMPO DE CALIDAD ()",
          values: controller.airQualityTimes.map((e) => "${e.toStringIncludingSign()}seg").toList(),
          initialValue: "${controller.dataController.adjustment.other.storedLocally.airQualityTime.value.toStringIncludingSign()}seg",
          onChange: (indexValue) {
            controller.newValues.other.storedLocally.airQualityTime.value = controller.airQualityValues[indexValue];
          }
        ),

        // Not implemented
        // AdjustCustomRow(
        //   title: "HISTERESIS DEL A/C",
        //   values: const ["0.5°C", "1.0°C", "1.5°C", "2.0°C", "2.5°C", "3.0°C"],
        //   onChange: (val){
        //     config.elements.adjust(type: ConfigTypes.others.name, legibleName: OthersNames.acHysteresis.name, value: val);
        //   }
        // ),
      ],
    );
  }
}
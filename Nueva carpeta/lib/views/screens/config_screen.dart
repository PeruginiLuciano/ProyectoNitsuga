import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/config_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/modals/modal_adjust.dart';
import 'package:motorhome/views/modals/pattern_unlock.dart';
import 'package:motorhome/views/widgets/buttons/circle_button.dart';
import 'package:motorhome/views/widgets/buttons/protection_button.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/buttons/motores_button.dart';
import 'package:motorhome/views/widgets/dimmer.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigViewController controller = Get.put(ConfigViewController());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 7,
          child: CustomCard(
            child: Obx(() =>
              Center(
                child: const [
                  DisplayOptions(),
                  ProtectionsOptions(),
                ][controller.currentConfig.value.index],
              )
            )
          ),
        ),

        const SizedBox(width: 25),

        Expanded(
          flex: 3,
          child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MotorsButton(
                  title: 'PANTALLA',
                  active: controller.currentConfig.value == ControlList.screen,
                  marginBottom: 15,
                  onTap: () {
                    controller.currentConfig.value = ControlList.screen;
                  },
                ),
                MotorsButton(
                  title: 'PROTECCIONES Y AUTOMATISMOS',
                  active: controller.currentConfig.value == ControlList.protections,
                  marginBottom: 15,
                  onTap: () {
                    controller.currentConfig.value = ControlList.protections;
                  },
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}

class DisplayOptions extends StatelessWidget {
  const DisplayOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigViewController controller = Get.put(ConfigViewController());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Dimmer(
            initialValue: 0.9,
            width: 480,
            height: 60,
            direction: DimmerDirection.horizontal,
            child:
            svgIcon(MHIcons.sun, size: 40),
            onChange: (newValue, oldValue) {

            },
          ),

          Obx(() =>
            StateButton(
              title: '${controller.sleepTimeValue} MINUTOS',
              icon: svgIcon(MHIcons.moon, color: MHColors.blueLight),
              active: false,
              onTap: () async {
                controller.changeSleepTime();
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StateButton(
                  title: 'BLOQUEO',
                  icon: svgIcon(MHIcons.lock, color: MHColors.blueLight),
                  active: false,
                  onTap: () async {
                    Dialogs.launch(
                        child: const PatternUnlock()
                    );
                  },
                ),
              ),

              const SizedBox(width: 20.0),

              CircleButton(
                icon: svgIcon(MHIcons.gear, size: 25),
                onLongTap: () async {
                  Dialogs.launch(
                      child: const ModalAdjust(),
                      clear: true
                  );
                },
                onTap: () async {
                  Dialogs.launch(
                    child: const PatternUnlock(isChangingPattern: true)
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProtectionsOptions extends StatelessWidget {
  const ProtectionsOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigViewController controller = Get.find<ConfigViewController>();

    return Obx(() =>
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProtectionButton(
              title: 'CORTE AUTOMÁTICO DE BOMBA',
              details: 'POR BAJO NIVEL DE AGUA POTABLE',
              active: controller.dataController.protection.turnOffWaterPumper.value,
              onTap: () {
                controller.switchWaterPumperProtection();
              }
            ),
            ProtectionButton(
                title: 'ESCLUSA DE AGUA GRIS',
                details: 'CIERRE AUTOMÁTICO CUANDO EL TANQUE ESTÉ VACÍO',
                active: controller.dataController.protection.closeFloodgateGreyWater.value,
                onTap: () {
                  controller.switchFloodgateGreyWaterProtection();
                }
            ),
            ProtectionButton(
                title: 'ESCLUSA DE AGUA NEGRA',
                details: 'CIERRE AUTOMÁTICO CUANDO EL TANQUE ESTÉ VACÍO',
                active: controller.dataController.protection.closeFloodgateBlackWater.value,
                onTap: () {
                  controller.switchFloodgateBlackWaterProtection();
                }
            ),
            ProtectionButton(
                title: 'GRUPO ELECTRÓGENO',
                details: 'ENCENDIDO AUTOMÁTICO CUANDO EL NIVEL DE CARGA DEL BANCO DE BATERÍAS ESTE BAJO',
                active: controller.dataController.protection.automaticStartGenerator.value,
                onTap: () {
                  controller.switchAutomaticStartGeneratorProtection();
                }
            ),
          ],
        )
    );
  }
}

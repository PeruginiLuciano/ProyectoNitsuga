import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/controllers/views/energy_view_controller.dart';
import 'package:motorhome/utils/enums.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/views/widgets/buttons/circle_state_button.dart';
import 'package:motorhome/views/widgets/buttons/radio_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/donut.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';

class EnergyScreen extends StatelessWidget {
  const EnergyScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<EnergyViewController>();

    return Obx(() => Center(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: CustomCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('GRUPO ELECTRÓGENO', style: MHTextStyles.h1Bold.copyWith(fontSize: 30)),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RadioButton(
                                color: MHColors.green,
                                onTapDown: () {
                                  controller.switchGeneratorOnButton(SwitchStatus.on);
                                },
                                onTapUp: () {
                                  controller.switchGeneratorOnButton(SwitchStatus.off);
                                },
                              ),

                              RadioButton(
                                color: MHColors.red,
                                onTapDown: () {
                                  controller.switchGeneratorOffButton(SwitchStatus.on);
                                },
                                onTapUp: () {
                                  controller.switchGeneratorOffButton(SwitchStatus.off);
                                },
                              ),

                              CircleStateButton(
                                active: controller.dataController.generatorPrimerSwitch.value,
                                enabled: !controller.automaticMode.value,
                                icon: MHIcons.m,
                                size: 65,
                                onTapDown: () {
                                  controller.switchPrimer();
                                }
                              ),

                              CircleStateButton(
                                  active: controller.automaticMode.value,
                                  icon: MHIcons.a,
                                  size: 65,
                                  onTapDown: () {
                                    controller.automaticMode.value = !controller.automaticMode.value;
                                  }
                              ),
                            ],
                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [

                              Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Text('ENCENDER', style: MHTextStyles.h2, textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 48),
                                child: Text('APAGAR', style: MHTextStyles.h2, textAlign: TextAlign.center,),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 60),
                                child: Text('CEBADOR', style: MHTextStyles.h2, textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    flex: 10,
                    child: CustomCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StateButton(
                            width: 270,
                            title: 'CARGADOR',
                            active: controller.charger.value.isEnabled(),
                            enabled: !controller.charger.value.isWaiting(),
                            onTap: () {
                              controller.switchCharger();
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Donut(
                                title: 'CARGA',
                                percent: 100,
                                color: MHColors.blueLight
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text('CARGA', style: MHTextStyles.big),
                                  SizedBox(height: 10.0),
                                  Text('MODO', style: MHTextStyles.h2),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text('-', style: MHTextStyles.big),
                                  SizedBox(height: 10.0),
                                  Text('ALARMA', style: MHTextStyles.h2),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20.0),

            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: CustomCard(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StateButton(
                            title: 'CALENTADOR DE AGUA',
                            active: controller.waterBoiler.value.isEnabled(),
                            enabled: !controller.waterBoiler.value.isWaiting(),
                            onTap: (){
                              controller.switchWaterBoiler();
                            },
                          ),

                          StateButton(
                            title: 'GAS ENVASADO',
                            active: controller.bottledGas.value.isEnabled(),
                            enabled: !controller.bottledGas.value.isWaiting(),
                            onTap: () {
                              controller.switchBottledGas();
                            },
                          )
                        ]
                      ),
                    )
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    flex: 10,
                    child: CustomCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StateButton(
                            width: 270,
                            title: 'INVERSOR',
                            active: controller.inverter.value.isEnabled(),
                            enabled: !controller.inverter.value.isWaiting(),
                            onTap: () {
                              controller.switchInverter();
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text('1500W', style: MHTextStyles.big),
                                  SizedBox(height: 10.0),
                                  Text('CONSUMO', style: MHTextStyles.h2),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text('-', style: MHTextStyles.big),
                                  SizedBox(height: 10.0),
                                  Text('ALARMA', style: MHTextStyles.h2),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

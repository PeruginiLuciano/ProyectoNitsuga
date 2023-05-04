import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/air_conditioning.dart';
import 'package:motorhome/controllers/models/heater.dart';
import 'package:motorhome/controllers/views/heating_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/widgets/buttons/circle_state_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';

class HeatingScreen extends StatelessWidget {
  const HeatingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HeatingViewController controller = Get.put(HeatingViewController());

    return Obx(() =>
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 11,
              child: CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: StateButton(
                        title: 'A/C',
                        active: controller.dataController.airConditioning.power.value,
                        onTap: (){
                          controller.switchAc();
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleStateButton(
                          size: 55,
                          active: controller.dataController.airConditioning.acMode.value == AirConditioningMode.cold,
                          radius: 15,
                          icon: MHIcons.acCold,
                          onTapDown: () {
                            controller.switchAcMode(AirConditioningMode.cold);
                          }
                        ),
                        CircleStateButton(
                          size: 55,
                            active: controller.dataController.airConditioning.acMode.value == AirConditioningMode.hot,
                          radius: 15,
                          icon: MHIcons.acHeat,
                          onTapDown: () {
                            controller.switchAcMode(AirConditioningMode.hot);
                          }
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleStateButton(
                            size: 55,
                            enabled: controller.acTemperature > 17,
                            icon: MHIcons.arrowDown,
                            onTapDown: (){
                              controller.setAcTemperature(false);
                            }
                          ),
                          Text('${controller.acTemperature}°',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0
                              )
                          ),
                          CircleStateButton(
                            size: 55,
                            enabled: controller.acTemperature < 30,
                            icon: MHIcons.arrowUp,
                            onTapDown: (){
                              controller.setAcTemperature(true);
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),

            const SizedBox(width: 25),

            Expanded(
              flex: 8,
              child: CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: svgIcon(MHIcons.thermometer, size: 130),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        height: 65,
                        alignment: Alignment.center,
                        child: Text('${controller.dataController.temperature}°',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 50.0
                            ),
                          textAlign: TextAlign.center
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 25),

          Expanded(
            flex: 11,
            child: CustomCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: StateButton(
                      title: 'CALEFACTOR',
                      active: controller.dataController.heater.power.value,
                      onTap: () {
                        controller.switchHeater();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleStateButton(
                        size: 55,
                        active: controller.dataController.heater.mode.value == HeaterMode.heat,
                        radius: 15,
                        icon: MHIcons.heaterStatic,
                        onTapDown: (){
                          controller.switchHeaterMode(HeaterMode.heat);
                        }
                      ),
                      CircleStateButton(
                        size: 55,
                        active: controller.dataController.heater.mode.value == HeaterMode.ventilation,
                        radius: 15,
                        icon: MHIcons.heaterWind,
                        onTapDown: (){
                          controller.switchHeaterMode(HeaterMode.ventilation);
                        }
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleStateButton(
                          size: 55,
                          enabled: controller.dataController.heater.powerLevel.value > 1,
                          icon: MHIcons.arrowDown,
                          onTapDown: (){
                            controller.setHeaterTemperature(false);
                          }
                        ),
                        Text('${controller.dataController.heater.powerLevel.value}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50.0
                            )
                        ),
                        CircleStateButton(
                          size: 55,
                          enabled: controller.dataController.heater.powerLevel.value < 5,
                          icon: MHIcons.arrowUp,
                          onTapDown: (){
                            controller.setHeaterTemperature(true);
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}

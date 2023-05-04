import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/views/motors_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/widgets/buttons/circle_state_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/buttons/motores_button.dart';

class MotorsScreen extends StatefulWidget {
  const MotorsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MotorsScreen> createState() => MotorsScreenState();
}

class MotorsScreenState extends State<MotorsScreen> with TickerProviderStateMixin {
  MotorsViewController controller = Get.find<MotorsViewController>();

  @override
  void initState() {
    controller.syncAnimations(this);
    super.initState();
  }

  @override
  void dispose() {
    controller.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: CustomCard(
                  child: Center(
                    child: const [
                      Slider(),
                      Table(),
                      Awning(),
                      Leveler(),
                    ][controller.currentMotor.value.index],
                  )
              ),
            ),

            const SizedBox(width: 25),

            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for(var optionItem in MotorsList.values)
                      MotorsButton(
                        title: optionItem.title.toUpperCase(),
                        active: controller.currentMotor.value == optionItem,
                        onTap: () {
                          controller.switchMotor(optionItem);
                        },
                      ),
                  ],
                )
            )
        ],
      ),
    );
  }
}

class Leveler extends StatelessWidget {
  const Leveler({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MotorsViewController controller = Get.find<MotorsViewController>();

    return Obx(() => 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            child: Center(
              child: Row(
                children: [
                  const SizedBox(width: 30),
    
                  Stack(
                    children: [
                      svgIcon(MHIcons.leveler, size: 195),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: CircleStateButton(
                          active: controller.levelerSwitch.value == 1,
                          activeColor: controller.dataController.levelerSwitchActive[0] == MotorStatus.opening || controller.dataController.levelerSwitchActive[0] == MotorStatus.closing ? MHColors.red : MHColors.green,
                          icon: MHIcons.icon1,
                          size: 50,
                          onTapDown: () {
                            controller.levelerSwitch.value = controller.levelerSwitch.value == 1 ? 0 : 1;
                          },
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: CircleStateButton(
                          active: controller.levelerSwitch.value == 2,
                          activeColor: controller.dataController.levelerSwitchActive[1] == MotorStatus.opening || controller.dataController.levelerSwitchActive[1] == MotorStatus.closing ? MHColors.red : MHColors.green,
                          icon: MHIcons.icon2,
                          size: 50,
                          onTapDown: () {
                            controller.levelerSwitch.value = controller.levelerSwitch.value == 2 ? 0 : 2;
                          },
                        ),
                      ),
                      Positioned(
                        right: 160,
                        top: 20,
                        child: CircleStateButton(
                          active: controller.levelerSwitch.value == 3,
                          activeColor: controller.dataController.levelerSwitchActive[2] == MotorStatus.opening || controller.dataController.levelerSwitchActive[2] == MotorStatus.closing ? MHColors.red : MHColors.green,
                          icon: MHIcons.icon3,
                          size: 50,
                          onTapDown: () {
                            controller.levelerSwitch.value = controller.levelerSwitch.value == 3 ? 0 : 3;
                          },
                        ),
                      ),
                      Positioned(
                        right: 160,
                        bottom: 20,
                        child: CircleStateButton(
                          active: controller.levelerSwitch.value == 4,
                          activeColor: controller.dataController.levelerSwitchActive[3] == MotorStatus.opening || controller.dataController.levelerSwitchActive[3] == MotorStatus.closing ? MHColors.red : MHColors.green,
                          icon: MHIcons.icon4,
                          size: 50,
                          onTapDown: () {
                            controller.levelerSwitch.value = controller.levelerSwitch.value == 4 ? 0 : 4;
                          },
                        ),
                      ),

                      Positioned(
                        left: 130,
                        top: 40,
                        child: Stack(
                          children: [
                            svgIcon(MHIcons.levelerEye, size: 110),
                            Positioned(
                              left: (controller.dataController.accelerometer[0] * 45) + 45,
                              top: (controller.dataController.accelerometer[1] * 45) + 45,
                              child: svgIcon(MHIcons.levelerEyePin, size: 20),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 30),
                ],
              )
            )
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 30),
              CircleStateButton(
                active: controller.levelerButton[0],
                enabled: (controller.levelerAuto.value && controller.levelerSwitch.value == 0) || (controller.levelerSwitch.value > 0 && controller.dataController.levelerSwitchActive[controller.levelerSwitch.value - 1] != MotorStatus.closed),
                icon: MHIcons.arrowUp,
                size: 90,
                onTapDown: () {
                  controller.buttonLevelerTapDown(false);
                },
                onTapUp: () {
                  controller.buttonLevelerTapUp();
                }
              ),

              CircleStateButton(
                active: controller.levelerAuto.value,
                icon: MHIcons.a,
                size: 65,
                onTapDown: () {
                  controller.switchAuto();
                }
              ),
              CircleStateButton(
                active: controller.levelerButton[1],
                enabled: (controller.levelerAuto.value && controller.levelerSwitch.value == 0) || (controller.levelerSwitch.value > 0 && controller.dataController.levelerSwitchActive[controller.levelerSwitch.value - 1] != MotorStatus.opened),
                icon: MHIcons.arrowDown,
                size: 90,
                onTapDown: () {
                  controller.buttonLevelerTapDown(true);
                },
                onTapUp: () {
                  controller.buttonLevelerTapUp();
                }
              ),
              const SizedBox(width: 30),
            ],
          )        
        ],
      ),
    );
  }
}

class Awning extends StatefulWidget {
  const Awning({
    Key? key,
  }) : super(key: key);

  @override
  State<Awning> createState() => _AwningState();
}

class _AwningState extends State<Awning> {
  var controller = Get.find<MotorsViewController>();

  @override
  Widget build(BuildContext context) {
    MotorsViewController controller = Get.find<MotorsViewController>();

    return Obx(() =>
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Lottie.asset(
                  MHAnimations.awning,
                  controller: controller.awningAnimationController,
                  fit: BoxFit.fitHeight
              )
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 30),
                CircleStateButton(
                    active: controller.dataController.awningStatus.value == MotorStatus.closing,
                    enabled: controller.dataController.awningStatus.value != MotorStatus.closed,
                    icon: MHIcons.arrowLeft,
                    size: 90,
                    onTapDown: () {
                      controller.buttonAwningTapDown(false);
                    },
                    onTapUp: () {
                      controller.buttonAwningTapUp(false);
                    }
                ),

                CircleStateButton(
                  active: controller.awningAuto.value,
                  icon: controller.awningAuto.value ? MHIcons.a : MHIcons.m,
                  size: 65,
                  onTapDown: () {
                    controller.switchAuto();
                  }
                ),

                CircleStateButton(
                  active: controller.dataController.awningStatus.value == MotorStatus.opening,
                  enabled: controller.dataController.awningStatus.value != MotorStatus.opened,
                  icon: MHIcons.arrowRight,
                  size: 90,
                  onTapDown: () {
                    controller.buttonAwningTapDown(true);
                  },
                  onTapUp: () {
                    controller.buttonAwningTapUp(true);
                  }
                ),
                const SizedBox(width: 30),
            ],
          )
        ],
      ),
    );
  }
}

class Table extends StatefulWidget {
  const Table({
    Key? key,
  }) : super(key: key);

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  var controller = Get.find<MotorsViewController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() =>
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Lottie.asset(
                  MHAnimations.table,
                  controller: controller.tableAnimationController,
                  fit: BoxFit.fitHeight
              )
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 30),
                CircleStateButton(
                  active: controller.dataController.tableStatus.value == MotorStatus.opening,
                  enabled: controller.dataController.tableStatus.value != MotorStatus.opened,
                  icon: MHIcons.arrowUp,
                  size: 90,
                  onTapDown: () {
                    controller.buttonTableTapDown(true);
                  },
                  onTapUp: () {
                    controller.buttonTableTapUp(true);
                  }
                ),
                CircleStateButton(
                  active: controller.tableAuto.value,
                  icon: controller.tableAuto.value ? MHIcons.a : MHIcons.m,
                  size: 65,
                  onTapDown: () {
                    controller.switchAuto();
                  }
                ),

                CircleStateButton(
                  active: controller.dataController.tableStatus.value == MotorStatus.closing,
                  enabled: controller.dataController.tableStatus.value != MotorStatus.closed,
                  icon: MHIcons.arrowDown,
                  size: 90,
                  onTapDown: () {
                    controller.buttonTableTapDown(false);
                  },
                  onTapUp: () {
                    controller.buttonTableTapUp(false);
                  }
                ),
                const SizedBox(width: 30),
              ],
            )
          ],
        ),
    );
  }
}

class Slider extends StatefulWidget {
  const Slider({
    Key? key,
  }) : super(key: key);

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  var controller = Get.find<MotorsViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Lottie.asset(
                    MHAnimations.slider,
                    controller: controller.sliderAnimationController,
                    fit: BoxFit.fitHeight,
                )
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 30),
                CircleStateButton(
                  icon: MHIcons.arrowLeft,
                  active: controller.dataController.sliderStatus.value == MotorStatus.opening,
                  enabled: controller.dataController.sliderStatus.value != MotorStatus.opened,
                  size: 90,
                  onTapDown: () {
                    controller.buttonSliderTapDown(true);
                  },
                  onTapUp: () {
                    controller.buttonSliderTapUp(true);
                  }
                ),

                CircleStateButton(
                  active: controller.sliderAuto.value,
                  icon: controller.sliderAuto.value ? MHIcons.a : MHIcons.m,
                  size: 65,
                  onTapDown: () {
                    controller.switchAuto();
                  }
                ),

                CircleStateButton(
                  icon: MHIcons.arrowRight,
                  active: controller.dataController.sliderStatus.value == MotorStatus.closing,
                  enabled: controller.dataController.sliderStatus.value != MotorStatus.closed,
                  size: 90,
                  onTapDown: () {
                    controller.buttonSliderTapDown(false);
                  },
                  onTapUp: () {
                    controller.buttonSliderTapUp(false);
                  }
                ),
                const SizedBox(width: 30),
            ],
          )
        ],
      ),
    );
  }
}

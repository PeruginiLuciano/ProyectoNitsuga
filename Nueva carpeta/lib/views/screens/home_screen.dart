import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/ac_source.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/views/home_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/modals/modal_unlock.dart';
import 'package:motorhome/views/widgets/buttons/check_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/donut.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewController controller = Get.put(HomeViewController());
    var dataController = Get.find<DataController>();

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Donut(
                        size: 120,
                        percent: dataController.dcPercentage.toDouble(),
                        color: MHColors.blue,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('BATERÍA', style: MHTextStyles.h1),
                            Text('${dataController.dcPercentage}%', style: MHTextStyles.h1Bold.copyWith(fontSize: 65)),
                          ],
                        )
                      ),
                    ),

                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Text('${dataController.dcVoltage.value.toPrecision(1)}V', style: MHTextStyles.h),
                          const Text('TENSIÓN', style: MHTextStyles.h2),

                          const Divider(
                            height: 30.0,
                            indent:30,
                            endIndent: 30,
                            thickness: 3,
                            color: MHColors.blue,
                          ),

                          Text('${dataController.dcCurrent.value.toPrecision(1)}A', style: MHTextStyles.h),
                          const Text('CORRIENTE', style: MHTextStyles.h2),
                        ],
                      )
                    )
                  ],
                ),

                const SizedBox(height: 30.0),

                CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${dataController.acVoltage.value}V', style: MHTextStyles.h),
                          const Text('TENSIÓN', style: MHTextStyles.h2),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${dataController.acCurrent.value.toPrecision(1)}A', style: MHTextStyles.h),
                          const Text('CORRIENTE', style: MHTextStyles.h2),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${dataController.acFrequency.value}Hz', style: MHTextStyles.h),
                          const Text('FRECUENCIA', style: MHTextStyles.h2),
                        ],
                      )
                    ]
                  )
                ),

                const SizedBox(height: 25.0),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AcSourceMarker(
                        title: 'LÍNEA',
                        active: dataController.acSource.value == AcSource.line,
                        style: AcSourceMarkerStyle.leftRounded,
                      ),
                    ),

                    const SizedBox(width: 15.0),

                    Expanded(
                      child: AcSourceMarker(
                        title: 'GRUPO',
                        active: dataController.acSource.value == AcSource.generator,
                        style: AcSourceMarkerStyle.none,
                      ),
                    ),

                    const SizedBox(width: 15.0),

                    Expanded(
                      child: AcSourceMarker(
                        title: 'INVERSOR',
                        active: dataController.acSource.value == AcSource.inverter,
                        style: AcSourceMarkerStyle.rightRounded,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(width: 20.0),

          Expanded(
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('NIVELES DE AGUA', style: MHTextStyles.h1Bold.copyWith(fontSize: 30))
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Donut(
                        title: 'POTABLE',
                        percent: dataController.potableWaterLevel.value,
                        color: MHColors.blueLight
                      ),

                      Donut(
                        title: 'LIMPIA',
                        percent: dataController.cleanWaterLevel.value,
                        color: MHColors.blue
                      ),

                      Donut(
                        title: 'GRIS',
                        percent: dataController.greyWaterLevel.value,
                        color: MHColors.greyLight
                      ),

                      Donut(
                        title: 'NEGRA',
                        percent: dataController.blackWaterLevel.value,
                        color: MHColors.greyLight
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  StateButton(
                    title: 'BOMBA DE AGUA',
                    active: dataController.waterPumper.value,
                    onTap: () async {
                      controller.switchWaterPump();
                    },
                  ),

                  const SizedBox(height: 20.0),

                  StateButton(
                    title: 'ESCLUSA AGUA GRIS',
                    active: dataController.floodgateGreyWaterStatus.value == MotorStatus.opened,
                    enabled: dataController.floodgateGreyWaterStatus.value != MotorStatus.unknown,
                    onTap: () {
                      controller.switchGreyWaterLock();
                    },
                  ),

                  const SizedBox(height: 20.0),

                  StateButton(
                    title: 'ESCLUSA AGUA NEGRA',
                    active: dataController.floodgateBlackWaterStatus.value == MotorStatus.opened,
                    enabled: dataController.floodgateBlackWaterStatus.value != MotorStatus.unknown,
                    onTap: () {
                      controller.switchBlackWaterLock();
                    },
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}

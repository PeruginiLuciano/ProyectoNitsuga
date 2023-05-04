import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/sensor.dart';
import 'package:motorhome/controllers/views/main_view_controller.dart';
import 'package:motorhome/utils/routes.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // color: Colors.yellow,
            child: Obx(() => Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.page.value = Pages.config;
                  },
                  child: svgIcon(MHIcons.engine, color: MHColors.green, size: 30)
                ),

                const SizedBox(width: 40),

                Visibility(
                  visible: controller.page.value != Pages.home,
                  child: Row(
                    children: [

                      GestureDetector(
                          onTap: (){ },
                          child: svgIcon(MHIcons.lock, color: Colors.white, size: 30)
                      ),

                      const SizedBox(width: 40),

                      Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        width: 50,
                        height: 44,
                        color: MHColors.blueLight,
                        child: Center(
                          child: Text(controller.dataController.cleanWaterLevel.value.toStringAsFixed(0), style: MHTextStyles.h1)
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          width: 50,
                          height: 44,
                          color: MHColors.blue,
                          child: Center(
                              child: Text(controller.dataController.potableWaterLevel.value.toStringAsFixed(0), style: MHTextStyles.h1)
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          width: 50,
                          height: 44,
                          color: MHColors.greyLight,
                          child: Center(
                              child: Text(controller.dataController.greyWaterLevel.value.toStringAsFixed(0), style: MHTextStyles.h1)
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          width: 50,
                          height: 44,
                          color: MHColors.grey,
                          child: Center(
                              child: Text(controller.dataController.blackWaterLevel.value.toStringAsFixed(0), style: MHTextStyles.h1)
                          )
                      ),
                      const SizedBox(width: 30),
                      svgIcon(MHIcons.flash, color: Colors.green, size: 36),
                      const SizedBox(width: 30),
                      svgIcon(MHIcons.ac, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text('${controller.dataController.acVoltage.value.toStringAsFixed(0)}V', style: MHTextStyles.h1),
                      const SizedBox(width: 10),
                      Text('${controller.dataController.acCurrent.value.toStringAsFixed(1)}A', style: MHTextStyles.h1),
                      const SizedBox(width: 40),
                      svgIcon(MHIcons.dc, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text('${controller.dataController.dcVoltage.value.toStringAsFixed(0)}V', style: MHTextStyles.h1),
                      const SizedBox(width: 10),
                      Text('${controller.dataController.dcCurrent.value.toStringAsFixed(1)}A', style: MHTextStyles.h1),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 10),
                    child: svgIcon(
                        MHIcons.leaf,
                        color: controller.dataController.airQuality.value == AirQuality.low ? Colors.red :
                        controller.dataController.airQuality.value == AirQuality.medium ? Colors.yellow :
                        controller.dataController.airQuality.value == AirQuality.low ? Colors.green : Colors.white,
                        size: 36
                    )
                  ),
                ),
              ],
            )
            )
          ),

          Container(
            height: 3,
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: <Color>[
                  MHColors.blueLight.withOpacity(0),
                  MHColors.blueLight,
                  MHColors.blueLight,
                  MHColors.blueLight.withOpacity(0),
                ],
              ),
            ),
          ),

          Container(
            height: 45,
            color: MHColors.greyDark,
            child: Row(
              children: const [
                ActiveInTopBar(title: 'DESPLAZABLE'),
                ActiveInTopBar(title: 'TOLDO')
              ]
            )
          )



        ],
      ),
    );
  }
}

class ActiveInTopBar extends StatelessWidget {
  final String title;

  const ActiveInTopBar({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(title, style: MHTextStyles.h1.copyWith(color: MHColors.green))
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/views/lights_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/modals/modal_color_picker.dart';
import 'package:motorhome/views/widgets/buttons/circle_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/dimmer.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';

class LightsScreen extends StatelessWidget {
  const LightsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LightsViewController());

    return Obx(
      () => Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StateButton(
                          width: 230,
                          title: 'INTERIOR',
                          active: controller.dataController.interiorLight.value,
                          onTap: () {
                            controller.switchInterior();
                          },
                        ),

                        Dimmer(
                          initialValue: 0.9,
                          width: 270,
                          height: 60,
                          direction: DimmerDirection.horizontal,
                          child: svgIcon(MHIcons.sliderBulb, size: 40),
                          onStart: (value) {
                            controller.interiorLightDimmer?.start(value);
                          },
                          onChange: (newValue, oldValue){
                            controller.interiorLightDimmer?.update(newValue);
                          },
                          onFinish: (value) {
                            controller.interiorLightDimmer?.finish(value);
                          },
                        ),
                      ]
                    )
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  flex: 3,
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                    child: StateButton(
                      width: 230,
                      title: 'EXTERIOR',
                      active: controller.dataController.exteriorLight.value,
                      onTap: () {
                        controller.switchExterior();
                      },
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20.0),

            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StateButton(
                          width: 230,
                          title: 'AMBIENTAL',
                          active: controller.dataController.environmentLight.value.power,
                          onTap: () {
                            controller.switchEnvironmental();
                          },
                        ),

                        Dimmer(
                          initialValue: 0.9,
                          width: 270,
                          height: 60,
                          direction: DimmerDirection.horizontal,
                          child:
                          svgIcon(MHIcons.sliderBulb, size: 40),
                          onStart: (value) {
                            controller.environmentLightDimmer?.start(value);
                          },
                          onChange: (newValue, oldValue){
                            controller.environmentLightDimmer?.update(newValue);
                          },
                          onFinish: (value) {
                            controller.environmentLightDimmer?.finish(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 42),

                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),

                        CircleButton(
                          icon: svgIcon(MHIcons.pick, size: 25),
                          onTap: (){
                            Dialogs.launch(
                                child: ModalColorPicker(
                                    type: ColorPickerType.single,
                                    onSelect: (color) {
                                      controller.sendColor(color);
                                      Dialogs.remove();
                                    }));
                            },
                        ),

                        const SizedBox(width: 40),

                        CircleButton(
                          icon: svgIcon(MHIcons.gear, size: 25),
                          onTap: (){
                            Dialogs.launch(
                                child: ModalColorPicker(
                                    type: ColorPickerType.custom,
                                    initColor: controller.dataController.environmentLight.value.getColor(),
                                    onSelect: (color) {
                                      controller.sendColor(color);
                                      Dialogs.remove();
                                    }));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),

          ],
        )
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/audio.dart';
import 'package:motorhome/controllers/views/music_view_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/widgets/buttons/circle_state_button.dart';
import 'package:motorhome/views/widgets/custom_card.dart';
import 'package:motorhome/views/widgets/dimmer.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicViewController controller = Get.put(MusicViewController());

    return Obx(
      () => Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  svgIcon(MHIcons.dinningRoom, size: 50),

                  Dimmer(
                    initialValue: 0.9,
                    width: 410,
                    height: 60,
                    direction: DimmerDirection.horizontal,
                    currentValue: controller.livingRoomVolume.value,
                    onStart: (value) {
                      controller.livingRoomVolumeDimmer?.start(value);
                    },
                    onChange: (newValue, oldValue){
                      controller.livingRoomVolumeDimmer?.update(newValue);
                    },
                    onFinish: (value) {
                      controller.livingRoomVolumeDimmer?.finish(value);
                    },
                    child: svgIcon(MHIcons.volume, size: 40),
                  ),

                  CircleStateButton(
                    size: 55,
                    active: controller.dataController.audio.livingRoom.source.value == AudioSource.radio,
                    radius: 15,
                    icon: MHIcons.radio,
                    onTapDown: () {
                      controller.setLivingRoomSource(AudioSource.radio);
                    }
                  ),
                                      
                  CircleStateButton(
                    size: 55,
                    active: controller.dataController.audio.livingRoom.source.value == AudioSource.tv,
                    radius: 15,
                    icon: MHIcons.tv,
                    onTapDown: () {
                      controller.setLivingRoomSource(AudioSource.tv);
                    }
                  ),
                  
                  CircleStateButton(
                    size: 55,
                    active: controller.dataController.audio.livingRoom.source.value == AudioSource.auxiliary,
                    radius: 15,
                    icon: MHIcons.auxiliary,
                    onTapDown: () {
                      controller.setLivingRoomSource(AudioSource.auxiliary);
                    }
                  ),
                ]
              )
            ),

            const SizedBox(height: 20.0),
            
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  svgIcon(MHIcons.bedroom, size: 50),

                  Dimmer(
                    initialValue: 0.9,
                    width: 410,
                    height: 60,
                    direction: DimmerDirection.horizontal,
                    currentValue: controller.bedroomVolume.value,
                    onStart: (value) {
                      controller.bedroomVolumeDimmer?.start(value);
                    },
                    onChange: (newValue, oldValue){
                      controller.bedroomVolumeDimmer?.update(newValue);
                    },
                    onFinish: (value) {
                      controller.bedroomVolumeDimmer?.finish(value);
                    },
                    child: svgIcon(MHIcons.volume, size: 40),
                  ),

                  CircleStateButton(
                    size: 55,
                    active: controller.dataController.audio.bedroom.source.value == AudioSource.radio,
                    radius: 15,
                    icon: MHIcons.radio,
                    onTapDown: () {
                      controller.setBedroomSource(AudioSource.radio);
                    }
                  ),
                                      
                  CircleStateButton(
                    size: 55,
                      active: controller.dataController.audio.bedroom.source.value == AudioSource.tv,
                    radius: 15,
                    icon: MHIcons.tv,
                    onTapDown: () {
                      controller.setBedroomSource(AudioSource.tv);
                    }
                  ),
                  
                  CircleStateButton(
                    size: 55,
                      active: controller.dataController.audio.bedroom.source.value == AudioSource.auxiliary,
                    radius: 15,
                    icon: MHIcons.auxiliary,
                    onTapDown: () {
                      controller.setBedroomSource(AudioSource.auxiliary);
                    }
                  ),
                ]
              )
            ),
          ],
        )
      ),
    );
  }
}


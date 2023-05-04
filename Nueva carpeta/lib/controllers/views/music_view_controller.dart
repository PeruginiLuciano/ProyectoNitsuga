import 'package:get/get.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/models/audio.dart';
import 'package:motorhome/controllers/models/dimmer_timer.dart';

class MusicViewController extends GetxController {
  var dataController = Get.find<DataController>();
  var communicationController = Get.find<CommunicationController>();

  DimmerTimer? livingRoomVolumeDimmer;
  DimmerTimer? bedroomVolumeDimmer;

  var livingRoomVolume = 0.0.obs;
  var bedroomVolume = 0.0.obs;

  @override
  void onInit() {
    livingRoomVolumeDimmer = DimmerTimer((value) {
      livingRoomVolume.value = value / 100;
      switch(dataController.audio.livingRoom.source.value) {
        case AudioSource.radio:
          dataController.audio.livingRoom.volume.radio = livingRoomVolume.value;
          break;
        case AudioSource.tv:
          dataController.audio.livingRoom.volume.tv = livingRoomVolume.value;
          break;
        default:
          dataController.audio.livingRoom.volume.auxiliary = livingRoomVolume.value;
      }
      _sendVolumeValues();
    });
    bedroomVolumeDimmer = DimmerTimer((value) {
      bedroomVolume.value = value / 100;
      switch(dataController.audio.bedroom.source.value) {
        case AudioSource.radio:
          dataController.audio.bedroom.volume.radio = bedroomVolume.value;
          break;
        case AudioSource.tv:
          dataController.audio.bedroom.volume.tv = bedroomVolume.value;
          break;
        default:
          dataController.audio.bedroom.volume.auxiliary = bedroomVolume.value;
      }
      _sendVolumeValues();
    });
    super.onInit();
  }

  void setLivingRoomSource(AudioSource source) {
    dataController.audio.livingRoom.source.value = source;
    switch(source) {
      case AudioSource.radio:
        livingRoomVolume.value = dataController.audio.livingRoom.volume.radio;
        break;
      case AudioSource.tv:
        livingRoomVolume.value = dataController.audio.livingRoom.volume.tv;
        break;
      default:
        livingRoomVolume.value = dataController.audio.livingRoom.volume.auxiliary;
    }
    communicationController.ca102.command.setSources(dataController.audio.livingRoom.getCa012Source(), dataController.audio.bedroom.getCa012Source());
    _sendVolumeValues();
  }

  void setBedroomSource(AudioSource source) {
    dataController.audio.bedroom.source.value = source;
    switch(source) {
      case AudioSource.radio:
        bedroomVolume.value = dataController.audio.bedroom.volume.radio;
        break;
      case AudioSource.tv:
        bedroomVolume.value = dataController.audio.bedroom.volume.tv;
        break;
      default:
        bedroomVolume.value = dataController.audio.bedroom.volume.auxiliary;
    }
    communicationController.ca102.command.setSources(dataController.audio.livingRoom.getCa012Source(), dataController.audio.bedroom.getCa012Source());
    _sendVolumeValues();
  }

  void _sendVolumeValues() {
    var livingRoomVolumeValue = (livingRoomVolume.value * 40).round();
    livingRoomVolumeValue = livingRoomVolumeValue > 0 ? livingRoomVolumeValue + 40 : 0;
    var bedroomVolumeValue = (bedroomVolume.value * 40).round();
    bedroomVolumeValue = bedroomVolumeValue > 0 ? bedroomVolumeValue + 40 : 0;
    print(bedroomVolumeValue);
    communicationController.ca102.command.setVolume(livingRoomVolumeValue, bedroomVolumeValue);
  }
}

import 'package:get/get.dart';
import 'package:motorhome/controllers/models/devices/ca102.dart';

class Audio {
  var power = false.obs;
  var livingRoom = AudioDevice(true);
  var bedroom = AudioDevice(false);
  var equalizer = AudioEqualizer();
}

class AudioDevice {
  var volume = AudioVolume();
  var balance = 0.obs;
  var source = AudioSource.unknown.obs;
  final bool isLivingRoom;

  AudioDevice(this.isLivingRoom);

  Ca102source getCa012Source() {
    switch (source.value) {
      case AudioSource.radio:
        return Ca102source.radio;
      case AudioSource.tv:
        return isLivingRoom ? Ca102source.navigationRadio : Ca102source.microphone;
      case AudioSource.auxiliary:
        return Ca102source.mp3;
      default:
        return Ca102source.pic;
    }
  }
}

enum AudioSource {
  radio(0xE8),
  tv(0xE9),
  navRadio(0xEA),
  auxiliary(0xEB),
  pic(0xEC),
  unknown(-1);

  const AudioSource(this.sourceNumber);

  final int sourceNumber;

  static AudioSource fromByte(int byte) =>
      AudioSource.values.firstWhere((element) => element.sourceNumber == byte, orElse: () => AudioSource.unknown);
}

class AudioEqualizer {
  var mainGain = 0.obs;
  var lowGain = 0.obs;
  var midGain = 0.obs;
  var highGain = 0.obs;
}

class AudioVolume {
  var radio = 0.0;
  var tv = 0.0;
  var auxiliary = 0.0;
}
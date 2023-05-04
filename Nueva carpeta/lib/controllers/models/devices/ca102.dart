import 'package:motorhome/controllers/models/address.dart';
import 'package:motorhome/controllers/models/audio.dart';
import 'package:motorhome/controllers/models/devices/device.dart';
import 'package:motorhome/controllers/models/packet.dart';
import 'package:motorhome/controllers/models/switch.dart';
import 'package:motorhome/utils/extensions.dart';

class Ca102 extends Device {

  final WriteFunction _write;
  late final Ca102commands command;

  Ca102(this._write) {
    command = Ca102commands(_write);
  }

  @override
  void processCommand(Packet packet) {
    var command = Ca102command.fromByte(packet.byte1);
    switch (command) {
      case Ca102command.power:
        dataController.audio.power.value = SwitchStatus.fromByte(packet.byte2) == SwitchStatus.on;
        break;
      case Ca102command.source:
        dataController.audio.livingRoom.source.value == AudioSource.fromByte(packet.byte2);
        dataController.audio.bedroom.source.value == AudioSource.fromByte(packet.byte3);
        break;
      case Ca102command.volume:
        switch(dataController.audio.livingRoom.source.value) {
          case AudioSource.radio:
            dataController.audio.livingRoom.volume.radio = (packet.byte2 - 40).toDouble() / 40.0;
            break;
          case AudioSource.tv:
            dataController.audio.livingRoom.volume.tv = (packet.byte2 - 40).toDouble() / 40.0;
            break;
          default:
            dataController.audio.livingRoom.volume.auxiliary = (packet.byte2 - 40).toDouble() / 40.0;
            break;
        }
        dataController.audio.livingRoom.balance.value = packet.byte3 - 40; // Not implemented
        switch(dataController.audio.bedroom.source.value) {
          case AudioSource.radio:
            dataController.audio.bedroom.volume.radio = (packet.byte4 - 40).toDouble() / 40.0;
            break;
          case AudioSource.tv:
            dataController.audio.bedroom.volume.tv = (packet.byte4 - 40).toDouble() / 40.0;
            break;
          default:
            dataController.audio.bedroom.volume.auxiliary = (packet.byte4 - 40).toDouble() / 40.0;
            break;
        }
        dataController.audio.bedroom.balance.value = packet.byte5 - 40; // Not implemented
        break;
      case Ca102command.equalizer:
        var source = Ca102equalizer.fromByte(packet.byte2);
        if (source == Ca102equalizer.mainGain) {
          dataController.audio.equalizer.mainGain.value = packet.byte3;
        }
        else if (source == Ca102equalizer.equalizerGain) {
          dataController.audio.equalizer.lowGain.value = packet.byte3;
          dataController.audio.equalizer.midGain.value = packet.byte4;
          dataController.audio.equalizer.highGain.value = packet.byte5;
        }
        else if (source == Ca102equalizer.frequency) {
          // Not implemented
        }
        break;
      default:
    }
  }

}

enum Ca102command {
  power(0),
  source(1),
  volume(2),
  equalizer(3),
  alert(4),
  bluetoothNotify(100),

  unknown(-1);

  const Ca102command(this.id);
  final int id;

  static Ca102command fromByte(int byte) =>
      Ca102command.values.firstWhere((element) => element.id == byte, orElse: () => Ca102command.unknown);
}

enum Ca102switch {
  off(0),
  on(1),
  state(2),
  get(3),
  set(4),
  unknown(-1);

  const Ca102switch(this.switchNumber);
  final int switchNumber;
}

enum Ca102equalizer {
  mainGain(0),
  equalizerGain(1),
  frequency(2),

  unknown(-1);

  const Ca102equalizer(this.equalizerNumber);
  final int equalizerNumber;

  static Ca102equalizer fromByte(int byte) =>
      Ca102equalizer.values.firstWhere((element) => element.equalizerNumber == byte, orElse: () => Ca102equalizer.unknown);
}

enum Ca102source {
  radio(0xE8),
  microphone(0xE9),
  navigationRadio(0xEA),
  mp3(0xEB),
  pic(0xEC),
  unknown(-1);

  const Ca102source(this.sourceNumber);
  final int sourceNumber;
}

class Ca102commands extends DeviceCommands {
  Ca102commands(write) : super(write, Address.ca102);

  void power(SwitchStatus status) => send(Ca102command.power.id, status.statusNumber);
  void getPowerStatus() => send(Ca102command.power.id, SwitchStatus.state.statusNumber);
  void setVolume(int livingRoomVolume, int bedroomVolume, [int livingRoomBalance = 80, int bedroomBalance = 80]) =>
      send(Ca102command.volume.id, Ca102switch.set.switchNumber, livingRoomVolume.limitedTo(0, 80), livingRoomBalance, bedroomVolume.limitedTo(0, 80), bedroomBalance);
  void getVolume() => send(Ca102command.volume.id, Ca102switch.get.switchNumber);
  void setSources(Ca102source livingSource, Ca102source roomSource) =>
      send(Ca102command.source.id, Ca102switch.set.switchNumber, livingSource.sourceNumber, roomSource.sourceNumber);
  void getSources() => send(Ca102command.source.id, Ca102switch.get.switchNumber);
  /// Gain equal to 15 is 0dB
  void setEqualizerGains(int bass, int middle, int treble) =>
      send(Ca102command.equalizer.id, Ca102switch.set.switchNumber, Ca102equalizer.equalizerGain.equalizerNumber, bass.limitedTo(0, 30), middle.limitedTo(0, 30), treble.limitedTo(0, 30));
  void getEqualizerGains() => send(Ca102command.equalizer.id, Ca102switch.get.switchNumber, Ca102equalizer.equalizerGain.equalizerNumber);
  /// Gain equal to 15 is 0dB
  void setMainGain(int value) => send(Ca102command.equalizer.id, Ca102switch.set.switchNumber, Ca102equalizer.mainGain.equalizerNumber, value.limitedTo(0, 30));
  void getMainGain() => send(Ca102command.equalizer.id, Ca102switch.get.switchNumber, Ca102equalizer.mainGain.equalizerNumber);
  void bluetoothNotify(SwitchStatus state) => send(Ca102command.bluetoothNotify.id, state.statusNumber);
}

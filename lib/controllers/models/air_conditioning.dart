import 'package:get/get.dart';
import 'package:motorhome/controllers/models/devices/aaa100.dart';
import 'package:motorhome/controllers/models/devices/caa10.dart';

class AirConditioning {
  var cold = AirConditioningParams(24, AirConditioningFanSpeed.speed2);
  var hot = AirConditioningParams(28, AirConditioningFanSpeed.speed1);
  var power = false.obs;
  var hysteresisTemperatureLevel = 0.0;
  var acMode = AirConditioningMode.unknown.obs;
}

class AirConditioningParams {
  int temperature;
  AirConditioningFanSpeed acFanSpeed;

  AirConditioningParams(
    this.temperature,
    this.acFanSpeed
  );
}

enum AirConditioningFanSpeed {
  auto,
  speed1,
  speed2,
  speed3,
  unknown;

  AirConditioningFanSpeed set(dynamic speed) {
    if (speed is Aaa100fanSpeed) {
      switch (speed) {
        case Aaa100fanSpeed.auto:
          return AirConditioningFanSpeed.auto;
        case Aaa100fanSpeed.speed3:
          return AirConditioningFanSpeed.speed3;
        case Aaa100fanSpeed.speed2:
          return AirConditioningFanSpeed.speed2;
        case Aaa100fanSpeed.speed1:
          return AirConditioningFanSpeed.speed1;
        default:
          return AirConditioningFanSpeed.unknown;
      }
    } else if (speed is Caa100fanSpeed){
      switch (speed) {
        case Caa100fanSpeed.auto:
          return AirConditioningFanSpeed.auto;
        case Caa100fanSpeed.speed3:
          return AirConditioningFanSpeed.speed3;
        case Caa100fanSpeed.speed2:
          return AirConditioningFanSpeed.speed2;
        case Caa100fanSpeed.speed1:
          return AirConditioningFanSpeed.speed1;
        default:
          return AirConditioningFanSpeed.unknown;
      }
    }
    return AirConditioningFanSpeed.unknown;
  }

  Caa100fanSpeed toCaa100fanSpeed() {
    switch(this) {
      case AirConditioningFanSpeed.auto:
        return Caa100fanSpeed.auto;
      case AirConditioningFanSpeed.speed1:
        return Caa100fanSpeed.speed1;
      case AirConditioningFanSpeed.speed2:
        return Caa100fanSpeed.speed2;
      case AirConditioningFanSpeed.speed3:
        return Caa100fanSpeed.speed3;
      case AirConditioningFanSpeed.unknown:
        return Caa100fanSpeed.unknown;
    }
  }
}

enum AirConditioningMode {
  off,
  cold,
  dehumidify,
  ventilation,
  hot,
  recirculation,
  unknown;

  AirConditioningMode set(dynamic mode) {
    if (mode is Aaa100mode) {
      switch(mode) {
        case Aaa100mode.off:
          return AirConditioningMode.off;
        case Aaa100mode.cold:
          return AirConditioningMode.cold;
        case Aaa100mode.dehumidify:
          return AirConditioningMode.dehumidify;
        case Aaa100mode.ventilation:
          return AirConditioningMode.ventilation;
        case Aaa100mode.hot:
          return AirConditioningMode.hot;
        case Aaa100mode.recirculation:
          return AirConditioningMode.recirculation;
        default:
          return AirConditioningMode.unknown;
      }
    }
    else if (mode is Caa100mode) {
      switch(mode) {
        case Caa100mode.off:
          return AirConditioningMode.off;
        case Caa100mode.cold:
          return AirConditioningMode.cold;
        case Caa100mode.hot:
          return AirConditioningMode.hot;
        case Caa100mode.ventilation:
          return AirConditioningMode.ventilation;
        default:
          return AirConditioningMode.unknown;
      }
    }
    return AirConditioningMode.unknown;
  }

  Caa100mode toCaa100mode() {
    switch(this) {
      case AirConditioningMode.off:
        return Caa100mode.off;
      case AirConditioningMode.cold:
        return Caa100mode.cold;
      case AirConditioningMode.ventilation:
        return Caa100mode.ventilation;
      case AirConditioningMode.hot:
        return Caa100mode.hot;
      default:
        return Caa100mode.unknown;
    }
  }
}
import 'package:get/get.dart';
import 'package:motorhome/controllers/models/ac_source.dart';
import 'package:motorhome/controllers/models/adjustment.dart';
import 'package:motorhome/controllers/models/alarm.dart';
import 'package:motorhome/controllers/models/audio.dart';
import 'package:motorhome/controllers/models/charger.dart';
import 'package:motorhome/controllers/models/heater.dart';
import 'package:motorhome/controllers/models/air_conditioning.dart';
import 'package:motorhome/controllers/models/inverter.dart';
import 'package:motorhome/controllers/models/motor.dart';
import 'package:motorhome/controllers/models/protection.dart';
import 'package:motorhome/controllers/models/rgb_light.dart';
import 'package:motorhome/controllers/models/sensor.dart';

class DataController extends GetxController {
  // AC
  var acPhaseInverted = false.obs;
  var acSource = AcSource.none.obs;
  var acVoltage = 0.obs;
  var acCurrent = 0.0.obs;
  var acFrequency = 0.obs;
  // DC
  int get dcPercentage {
    var voltage = dcVoltage.value;
    return voltage >= 12.7 ? 100 :
        voltage >= 12.2 ? 90 :
        voltage >= 12.1 ? 80 :
        voltage >= 12.0 ? 70 :
        voltage >= 11.9 ? 60 :
        voltage >= 11.8 ? 50 :
        voltage >= 11.6 ? 40 :
        voltage >= 11.3 ? 30 :
        voltage >= 11.0 ? 20 :
        voltage >= 10.5 ? 10 :
        voltage >= 10.0 ? 5 : 0;
  }

  var dcVoltage = 0.0.obs;
  var dcCurrent = 0.0.obs;
  // Water
  var potableWaterLevel = 0.0.obs;
  var greyWaterLevel = 0.0.obs;
  var blackWaterLevel = 0.0.obs;
  var cleanWaterLevel = 0.0.obs;
  // var motorCurrentLevel = 0.obs;
  // Motors
  var floodgateGreyWaterStatus = MotorStatus.closed.obs;
  var floodgateBlackWaterStatus = MotorStatus.closed.obs;
  var tableStatus = MotorStatus.closed.obs;
  var sliderStatus = MotorStatus.closed.obs;
  var backSliderStatus = MotorStatus.closed.obs;
  var awningStatus = MotorStatus.closed.obs;
  var levelerSwitchActive = [MotorStatus.closed, MotorStatus.closed, MotorStatus.closed, MotorStatus.closed].obs;
  var accelerometer = [0.0, 0.0].obs;

  // Alarms
  var alarms = Alarms();
  // Lights
  var interiorLight = false.obs;
  var interiorLightDimmer = 0.obs;
  var exteriorLight = false.obs;
  var vaultLight = false.obs;
  var environmentLight = RgbLight().obs;
  // Water pumper
  var waterPumper = false.obs;
  // Water pumper
  var generic1 = false.obs;
  var generic2 = false.obs;
  var generic3 = false.obs;
  // Generator
  var generatorTurnOnSwitch = false.obs;
  var generatorTurnOffSwitch = false.obs;
  var generatorPrimerSwitch = false.obs;
  // Charger
  var charger = Charger().obs;
  // Inverter
  var inverter = Inverter().obs;
  // Handbrake
  var handbrake = false.obs;
  // Heater
  var heater = Heater();
  // Air conditioning
  var airConditioning = AirConditioning();
  // Environment temperature
  var temperature = 0.obs;
  // Gas quality
  var airQuality = AirQuality.high.obs;
  // Audio
  var audio = Audio();
  // Protections
  var protection = Protection();

  // Adjustments
  // Motor current
  var adjustment = Adjustment();

  void updateSensorValue(SensorType sensor, double value) {
    switch(sensor) {
      case SensorType.vac:
        acVoltage.value = value.toInt();
        break;
      case SensorType.iac:
        acCurrent.value = value;
        break;
      case SensorType.frequency:
        acFrequency.value = value.toInt();
        break;
      case SensorType.vcc:
        dcVoltage.value = value;
        break;
      case SensorType.icc:
        dcCurrent.value = value;
        break;
      case SensorType.potableWater:
      case SensorType.medtankPotableWater:
        potableWaterLevel.value = value;
        break;
      case SensorType.greyWaterLevel:
      case SensorType.medtankGreyWater:
        greyWaterLevel.value = value;
        break;
      case SensorType.blackWaterLevel:
      case SensorType.medtankBlackWater:
        blackWaterLevel.value = value;
        break;
      case SensorType.medtankAuxWater:
        cleanWaterLevel.value = value;
        break;
      case SensorType.temperature:
        if (airConditioning.acMode == AirConditioningMode.cold) {
          airConditioning.cold.temperature = value.toInt();
        } else {
          airConditioning.hot.temperature = value.toInt();
        }
        break;
      case SensorType.motorCurrent:
        // Not implemented
        break;
      case SensorType.fuelLevel:
        // Not implemented
        break;
      case SensorType.airConditioningTemperature:
        // Not implemented
        break;
      case SensorType.heaterTemperature:
        // Not implemented
        break;
      case SensorType.batteryCurrent:
        // Not implemented
        break;
      case SensorType.airQuality:
        airQuality.value =
          value > 3200 ? AirQuality.low :
          value > 1700 ? AirQuality.medium : AirQuality.high;
        break;
      case SensorType.hctrl100Temperature:
        // Not implemented
        break;
      case SensorType.airConditioningColdHeatTemperature:
        if (airConditioning.acMode == AirConditioningMode.cold) {
          airConditioning.cold.temperature = value.toInt();
        } else {
          airConditioning.hot.temperature = value.toInt();
        }
        break;
      case SensorType.unknown:
        // Not implemented
        break;
      default:
    }
  }

  void updateOldSensorValue(SensorTypePrc10 sensor, double value) {
    switch(sensor) {
      case SensorTypePrc10.acs711:
        // ???
        break;
      case SensorTypePrc10.vcc15K1Kadc12_2V048:
        // ???
        break;
      case SensorTypePrc10.vac:
        acVoltage.value = value.toInt();
        break;
      case SensorTypePrc10.iac:
        acCurrent.value = value;
        break;
      case SensorTypePrc10.frequency:
        acFrequency.value = value.toInt();
        break;
      case SensorTypePrc10.vcc:
        dcVoltage.value = value;
        break;
      case SensorTypePrc10.icc:
        dcCurrent.value = value;
        break;
      case SensorTypePrc10.potableWater:
        potableWaterLevel.value = value;
        break;
      case SensorTypePrc10.greyWaterLevel:
        greyWaterLevel.value = value;
        break;
      case SensorTypePrc10.blackWaterLevel:
        blackWaterLevel.value = value;
        break;
      case SensorTypePrc10.temperature:
        if (airConditioning.acMode == AirConditioningMode.cold) {
          airConditioning.cold.temperature = value.toInt();
        } else {
          airConditioning.hot.temperature = value.toInt();
        }
        break;
      case SensorTypePrc10.motorCurrent:
        // Not implemented
        break;
      case SensorTypePrc10.unknown:
        // Not implemented
        break;
    }
  }
}
// Motorhome model HARDCODED
import 'package:motorhome/utils/extensions.dart';

const _motorhomeModel = MotorhomeModel.sprinterS515new;

enum SensorType {
  // PRC10 v1.1 and v1.2
  vac(13),
  iac(14),
  frequency(15),
  vcc(16),
  icc(17),
  potableWater(18),
  greyWaterLevel(19),
  blackWaterLevel(20),
  temperature(21),
  motorCurrent(22),
  fuelLevel(31),
  // Other
  airConditioningTemperature(23),
  heaterTemperature(24),
  batteryCurrent(25),
  airQuality(26),
  medtankPotableWater(27),
  medtankGreyWater(28),
  medtankBlackWater(29),
  medtankAuxWater(30),
  hctrl100Temperature(32),
  airConditioningColdHeatTemperature(33),

  unknown(-1);

  const SensorType(this.sensorNumber);
  final int sensorNumber;

  static SensorType fromBytes(int lowOrderByte, int highOrderByte) {
    var sensorId = (highOrderByte << 8) | lowOrderByte;
    return SensorType.values.firstWhere((element) => element.sensorNumber == sensorId, orElse: () => SensorType.unknown);
  }

  double getValue(int sensorCount) {
    double count = sensorCount.toDouble();
    switch(this) {
      case SensorType.vac:
        return count * 0.105126976;
      case SensorType.iac:
        return count * 0.0058318584;
      case SensorType.frequency:
        return 1000000 / count;
      case SensorType.vcc:
        return count * 0.0049295024 + 0.9956015937;
      case SensorType.icc:
        return (((count * 5 / 4096) - 2.5) / 0.066).zeroIfNegative();
      case SensorType.potableWater:
      case SensorType.medtankPotableWater:
        return _motorhomeModel.potable.getValue(count);
      case SensorType.greyWaterLevel:
      case SensorType.medtankGreyWater:
        return _motorhomeModel.grey.getValue(count);
      case SensorType.blackWaterLevel:
      case SensorType.medtankBlackWater:
        return _motorhomeModel.black.getValue(count);
      case SensorType.medtankAuxWater:
        return _motorhomeModel.clean.getValue(count);
      case SensorType.temperature:
        return ((count / 16 - 2730) / 10).zeroIfNegative();
      case SensorType.motorCurrent:
        return ((count - 2058) / 66).zeroIfNegative();
      case SensorType.airConditioningTemperature:
      case SensorType.heaterTemperature:
      case SensorType.airConditioningColdHeatTemperature:
        var normalizedCount = count / 16;
        return normalizedCount > 2048 ? normalizedCount - 4096 : normalizedCount;
      case SensorType.batteryCurrent:
        return count / (count > 215 ? 14.5 : (count > 78 ? 14.5 : 14));
      case SensorType.airQuality:
        return count * 1.220703125;
      case SensorType.fuelLevel:
      case SensorType.hctrl100Temperature:
      default:
        return 0;
    }
  }
}

@Deprecated("PRC10 v1.0")
enum SensorTypePrc10 {
  acs711(1),
  vcc15K1Kadc12_2V048(2),
  vac(3),
  iac(4),
  frequency(5),
  vcc(6),
  icc(7),
  potableWater(8),
  greyWaterLevel(9),
  blackWaterLevel(10),
  temperature(11),
  motorCurrent(12),

  unknown(-1);

  const SensorTypePrc10(this.sensorNumber);
  final int sensorNumber;

  static SensorTypePrc10 fromBytes(int lowOrderByte, int highOrderByte) {
    var sensorId = (highOrderByte << 8) | lowOrderByte;
    return SensorTypePrc10.values.firstWhere((element) => element.sensorNumber == sensorId, orElse: () => SensorTypePrc10.unknown);
  }

  double getValue(int sensorCount) {
    double count = sensorCount.toDouble();
    switch(this) {
      case SensorTypePrc10.acs711:
        return count / 110;
      case SensorTypePrc10.vcc15K1Kadc12_2V048:
        return count  * 0.00735 + 0.65;
      case SensorTypePrc10.vac:
        return count * 0.112218813;
      case SensorTypePrc10.iac:
        return 0.0066775603 * count + 1.7782198153;
      case SensorTypePrc10.frequency:
        return 1000000 / count;
      case SensorTypePrc10.vcc:
        return count * 0.0052089003 + 0.6633979951;
      case SensorTypePrc10.icc:
        return (((count * 5 / 4096) - 2.5) / 0.066).zeroIfNegative();
      case SensorTypePrc10.potableWater:
        return _motorhomeModel.potable.getValue(count);
      case SensorTypePrc10.greyWaterLevel:
        return _motorhomeModel.grey.getValue(count);
      case SensorTypePrc10.blackWaterLevel:
        return _motorhomeModel.black.getValue(count);
      case SensorTypePrc10.temperature:
        return ((count / 16 - 2730) / 10).zeroIfNegative();
      case SensorTypePrc10.motorCurrent:
        return ((count - 2058) / 66).zeroIfNegative();
      default:
        return 0;
    }
  }
}

class TankLevel {
  final double _minimum;
  final double _middle;
  final double _maximum;

  const TankLevel(this._minimum, this._middle, this._maximum);

  double getValue(double count) =>
      count >= _maximum ? 100 :
      count >= _middle ? 50 + 50 * (count - _middle) / (_maximum - _middle) :
      count >= _minimum ? 50 * (count - _minimum) / (_middle - _minimum) :
      0;
}

enum MotorhomeModel {
  iveco(
      potable: TankLevel(250, 1030, 1850),
      grey: TankLevel(250, 960, 1700),
      black: TankLevel(250, 800, 1450),
      clean: TankLevel(0, 0, 0)
  ),
  sprinterS413(
      potable: TankLevel(250, 920, 1660),
      grey: TankLevel(250, 550, 940),
      black: TankLevel(250, 780, 1430),
      clean: TankLevel(0, 0, 0)
  ),
  sprinterS515expo(
      potable: TankLevel(250, 550, 940),
      grey: TankLevel(250, 920, 1660),
      black: TankLevel(250, 780, 1430),
      clean: TankLevel(0, 0, 0)
  ),
  sprinterS515new(
      potable: TankLevel(260, 1028, 1850),
      grey: TankLevel(260, 592, 977),
      black: TankLevel(260, 811, 1460),
      clean: TankLevel(0, 0, 0)
  );

  const MotorhomeModel({
    required this.potable,
    required this.grey,
    required this.black,
    required this.clean,
  });

  final TankLevel potable;
  final TankLevel grey;
  final TankLevel black;
  final TankLevel clean;
}

enum AirQuality {
  low, medium, high
}

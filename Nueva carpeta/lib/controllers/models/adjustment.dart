import 'package:get/get.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Adjustment {
  var switchOnOff = AdjustmentSwitches();
  var motor = AdjustmentMotors();
  var other = AdjustmentOthers();
  var hardwareVersion = 0.0.obs;
  
  Adjustment({
    AdjustmentSwitches? switchOnOff,
    AdjustmentMotors? motor,
    AdjustmentOthers? other,
    double? hardwareVersion
  }) {
    this.switchOnOff = switchOnOff ?? AdjustmentSwitches();
    this.motor = motor ?? AdjustmentMotors();
    this.other = other ?? AdjustmentOthers();
    this.hardwareVersion.value = hardwareVersion ?? 0.0;
  }

  factory Adjustment.from(Adjustment adjustment) =>
      Adjustment(
          switchOnOff: AdjustmentSwitches.from(adjustment.switchOnOff),
          motor: AdjustmentMotors.from(adjustment.motor),
          other: AdjustmentOthers.from(adjustment.other),
          hardwareVersion: adjustment.hardwareVersion.value
    );
}

class AdjustmentSwitches {
  var interiorLight = AdjustmentSwitchLimits();
  var exteriorLight = AdjustmentSwitchLimits();
  var vaultLight = AdjustmentSwitchLimits();
  var waterPumper = AdjustmentSwitchLimits();
  var generatorOn = AdjustmentSwitchLimits();
  var generatorOff = AdjustmentSwitchLimits();
  var generatorPrimer = AdjustmentSwitchLimits();
  var generic1 = AdjustmentSwitchLimits();
  var generic2 = AdjustmentSwitchLimits();
  var generic3 = AdjustmentSwitchLimits();
  var charger = AdjustmentSwitchLimits();
  var inverter = AdjustmentSwitchLimits();
  var heater = AdjustmentSwitchLimits();

  AdjustmentSwitches({
    AdjustmentSwitchLimits? interiorLight,
    AdjustmentSwitchLimits? exteriorLight,
    AdjustmentSwitchLimits? vaultLight,
    AdjustmentSwitchLimits? waterPumper,
    AdjustmentSwitchLimits? generatorOn,
    AdjustmentSwitchLimits? generatorOff,
    AdjustmentSwitchLimits? generatorPrimer,
    AdjustmentSwitchLimits? generic1,
    AdjustmentSwitchLimits? generic2,
    AdjustmentSwitchLimits? generic3,
    AdjustmentSwitchLimits? charger,
    AdjustmentSwitchLimits? inverter,
    AdjustmentSwitchLimits? heater,
  }) {
    this.interiorLight = interiorLight ?? AdjustmentSwitchLimits();
    this.exteriorLight = exteriorLight ?? AdjustmentSwitchLimits();
    this.vaultLight = vaultLight ?? AdjustmentSwitchLimits();
    this.waterPumper = waterPumper ?? AdjustmentSwitchLimits();
    this.generatorOn = generatorOn ?? AdjustmentSwitchLimits();
    this.generatorOff = generatorOff ?? AdjustmentSwitchLimits();
    this.generatorPrimer = generatorPrimer ?? AdjustmentSwitchLimits();
    this.generic1 = generic1 ?? AdjustmentSwitchLimits();
    this.generic2 = generic2 ?? AdjustmentSwitchLimits();
    this.generic3 = generic3 ?? AdjustmentSwitchLimits();
    this.charger = charger ?? AdjustmentSwitchLimits();
    this.inverter = inverter ?? AdjustmentSwitchLimits();
    this.heater = heater ?? AdjustmentSwitchLimits();
  }

  factory AdjustmentSwitches.from(AdjustmentSwitches adjustmentSwitches) {
    return AdjustmentSwitches(
      interiorLight: AdjustmentSwitchLimits.from(adjustmentSwitches.interiorLight),
      exteriorLight: AdjustmentSwitchLimits.from(adjustmentSwitches.exteriorLight),
      vaultLight: AdjustmentSwitchLimits.from(adjustmentSwitches.vaultLight),
      waterPumper: AdjustmentSwitchLimits.from(adjustmentSwitches.waterPumper),
      generatorOn: AdjustmentSwitchLimits.from(adjustmentSwitches.generatorOn),
      generatorOff: AdjustmentSwitchLimits.from(adjustmentSwitches.generatorOff),
      generatorPrimer: AdjustmentSwitchLimits.from(adjustmentSwitches.generatorPrimer),
      generic1: AdjustmentSwitchLimits.from(adjustmentSwitches.generic1),
      generic2: AdjustmentSwitchLimits.from(adjustmentSwitches.generic2),
      generic3: AdjustmentSwitchLimits.from(adjustmentSwitches.generic3),
      charger: AdjustmentSwitchLimits.from(adjustmentSwitches.charger),
      inverter: AdjustmentSwitchLimits.from(adjustmentSwitches.inverter),
      heater: AdjustmentSwitchLimits.from(adjustmentSwitches.heater),
    );
  }
}

class AdjustmentMotors {
  var table = AdjustmentOpenClose();
  var slider = AdjustmentOpenClose();
  var backSlider = AdjustmentOpenClose();
  var awning = AdjustmentOpenClose();
  var floodgateGreyWater = AdjustmentOpenClose();
  var floodgateBlackWater = AdjustmentOpenClose();

  AdjustmentMotors({
    AdjustmentOpenClose? table,
    AdjustmentOpenClose? slider,
    AdjustmentOpenClose? backSlider,
    AdjustmentOpenClose? awning,
    AdjustmentOpenClose? floodgateGreyWater,
    AdjustmentOpenClose? floodgateBlackWater,
  }) {
    this.table = table ?? AdjustmentOpenClose();
    this.slider = slider ?? AdjustmentOpenClose();
    this.backSlider = backSlider ?? AdjustmentOpenClose();
    this.awning = awning ?? AdjustmentOpenClose();
    this.floodgateGreyWater = floodgateGreyWater ?? AdjustmentOpenClose();
    this.floodgateBlackWater = floodgateBlackWater ?? AdjustmentOpenClose();
  }

  factory AdjustmentMotors.from(AdjustmentMotors adjustmentMotors) =>
      AdjustmentMotors(
        table: AdjustmentOpenClose.from(adjustmentMotors.table),
        slider: AdjustmentOpenClose.from(adjustmentMotors.slider),
        backSlider: AdjustmentOpenClose.from(adjustmentMotors.backSlider),
        awning: AdjustmentOpenClose.from(adjustmentMotors.awning),
        floodgateGreyWater: AdjustmentOpenClose.from(adjustmentMotors.floodgateGreyWater),
        floodgateBlackWater: AdjustmentOpenClose.from(adjustmentMotors.floodgateBlackWater),
      );
}

class AdjustmentOthers {
  var tableVoltage = AdjustmentTableVoltage.twelve.obs;
  var batteryVoltage = 0.0.obs;
  var acVoltage = 0.0.obs;
  var generatorMode = AdjustmentGeneratorMode.cece.obs;
  var inverterMode = AdjustmentInverterMode.pulse.obs;
  var storedLocally = AdjustmentStoredLocally();

  AdjustmentOthers({
    AdjustmentTableVoltage? tableVoltage,
    double? batteryVoltage,
    double? acVoltage,
    AdjustmentGeneratorMode? generatorMode,
    AdjustmentInverterMode? inverterMode
  }) {
      this.tableVoltage.value = tableVoltage ?? AdjustmentTableVoltage.twelve;
      this.batteryVoltage.value = batteryVoltage ?? 0.0;
      this.acVoltage.value = acVoltage ?? 0.0;
      this.generatorMode.value = generatorMode ?? AdjustmentGeneratorMode.cece;
      this.inverterMode.value = inverterMode ?? AdjustmentInverterMode.pulse;
  }

  factory AdjustmentOthers.from(AdjustmentOthers adjustmentOthers) =>
      AdjustmentOthers(
        tableVoltage: adjustmentOthers.tableVoltage.value,
        batteryVoltage: adjustmentOthers.batteryVoltage.value,
        acVoltage: adjustmentOthers.acVoltage.value,
        generatorMode: adjustmentOthers.generatorMode.value,
        inverterMode: adjustmentOthers.inverterMode.value,
      );

  void sendVoltagesIfChanged(AdjustmentOthers newValue, Function(double tableVoltage, double batteryVoltage, double acVoltage) sendFunction) {
    if (newValue.tableVoltage.value != tableVoltage.value || newValue.batteryVoltage.value != batteryVoltage.value || newValue.acVoltage.value != acVoltage.value) {
      sendFunction(newValue.tableVoltage.value.value.toDouble(), newValue.batteryVoltage.value, newValue.acVoltage.value);
    }
  }

  void sendModesIfChanged(AdjustmentOthers newValue, Function(AdjustmentGeneratorMode generatorMode, AdjustmentInverterMode inverterMode) sendFunction) {
    if (newValue.generatorMode.value != generatorMode.value || newValue.inverterMode.value != inverterMode.value) {
      sendFunction(newValue.generatorMode.value, newValue.inverterMode.value);
    }
  }
}

class AdjustmentOpenClose {
  var open = AdjustmentMotorLimits();
  var close = AdjustmentMotorLimits();

  AdjustmentOpenClose({
    AdjustmentMotorLimits? open,
    AdjustmentMotorLimits? close
  }) {
    this.open = open ?? AdjustmentMotorLimits();
    this.close = close ?? AdjustmentMotorLimits();
  }

  factory AdjustmentOpenClose.from(AdjustmentOpenClose adjustmentOpenClose) =>
      AdjustmentOpenClose(
        open: AdjustmentMotorLimits.from(adjustmentOpenClose.open),
        close: AdjustmentMotorLimits.from(adjustmentOpenClose.close),
      );

  void sendIfChanged(
    AdjustmentOpenClose newLimit,
    Function(double newOpenValue, double newCloseValue) sendCurrentFunction,
    Function(double newOpenValue, double newCloseValue) sendTimeFunction
  ) {
    if (newLimit.open.currentLimitAdjustment.value != open.currentLimitAdjustment.value || newLimit.close.currentLimitAdjustment.value != close.currentLimitAdjustment.value) {
      sendCurrentFunction.call(newLimit.open.currentLimitAdjustment.value, newLimit.close.currentLimitAdjustment.value);
    }
    if (newLimit.open.timeLimitAdjustment.value != open.timeLimitAdjustment.value || newLimit.close.timeLimitAdjustment.value != close.timeLimitAdjustment.value) {
      sendTimeFunction.call(newLimit.open.timeLimitAdjustment.value, newLimit.close.timeLimitAdjustment.value);
    }
  }
}

class AdjustmentMotorLimits {
  var currentLimit = 0.0.obs;
  var currentLimitAdjustment = 0.0.obs;
  var timeLimit = 0.0.obs;
  var timeLimitAdjustment = 0.0.obs;

  AdjustmentMotorLimits({
    double? currentLimit,
    double? currentLimitAdjustment,
    double? timeLimit,
    double? timeLimitAdjustment,
  }) {
      this.currentLimit.value = currentLimit ?? 0.0;
      this.currentLimitAdjustment.value = currentLimitAdjustment ?? 0.0;
      this.timeLimit.value = timeLimit ?? 0.0;
      this.timeLimitAdjustment.value = timeLimitAdjustment ?? 0.0;
  }

  factory AdjustmentMotorLimits.from(AdjustmentMotorLimits adjustmentMotorLimits) =>
      AdjustmentMotorLimits(
        currentLimit: adjustmentMotorLimits.currentLimit.value,
        currentLimitAdjustment: adjustmentMotorLimits.currentLimitAdjustment.value,
        timeLimit: adjustmentMotorLimits.timeLimit.value,
        timeLimitAdjustment: adjustmentMotorLimits.timeLimitAdjustment.value,
      );
}

class AdjustmentSwitchLimits {
  var currentLimit = 0.0.obs;
  var currentLimitAdjustment = 0.0.obs;

  AdjustmentSwitchLimits({
    double? currentLimit,
    double? currentLimitAdjustment
  }) {
    this.currentLimit.value = currentLimit ?? 0.0;
    this.currentLimitAdjustment.value = currentLimitAdjustment ?? 0.0;
  }

  factory AdjustmentSwitchLimits.from(AdjustmentSwitchLimits adjustmentSwitchLimits) =>
      AdjustmentSwitchLimits(
          currentLimitAdjustment: adjustmentSwitchLimits.currentLimitAdjustment.value,
          currentLimit: adjustmentSwitchLimits.currentLimit.value
      );

  void sendIfChanged(AdjustmentSwitchLimits newLimit, Function(double newValue) sendFunction) {
    if (newLimit.currentLimitAdjustment.value != currentLimitAdjustment.value) {
      sendFunction.call(newLimit.currentLimitAdjustment.value);
    }
  }
}

enum AdjustmentTableVoltage {
  twelve(12), twentyFour(24);

  const AdjustmentTableVoltage(this.value);
  final int value;
}

enum AdjustmentGeneratorMode {
  ceec(1, "+C +E -E -C"),
  cece(2, "+C +E -C -E");

  const AdjustmentGeneratorMode(this.modeNumber, this.legibleName);
  final int modeNumber;
  final String legibleName;

  static AdjustmentGeneratorMode fromByte(int addressByte) =>
      AdjustmentGeneratorMode.values.firstWhere((e) => e.modeNumber == addressByte, orElse: () => AdjustmentGeneratorMode.cece);
}

enum AdjustmentInverterMode {
  pulse(1, "PULSO"),
  switched(2, "INTERRUPTOR");

  const AdjustmentInverterMode(this.modeNumber, this.legibleName);
  final int modeNumber;
  final String legibleName;

  static AdjustmentInverterMode fromByte(int addressByte) =>
      AdjustmentInverterMode.values.firstWhere((e) => e.modeNumber == addressByte, orElse: () => AdjustmentInverterMode.pulse);
}

class AdjustmentStoredLocally {
  var motorhomeNumber = 0.obs;
  var waterLevelsSource = AdjustmentWaterLevelSource.prc10.obs;
  var temperatureSource = AdjustmentTemperatureSource.airConditioning.obs;
  var motorsBlocker = AdjustmentMotorsBlocker.handbrake.obs;
  var generatorAutoButtonFunction = AdjustmentGeneratorAutoButtonFunction.automaticPrimer.obs;
  var bluetoothEnabled = false.obs;
  var airQualityValue = 0.obs;
  var airQualityTime = 0.obs;

  var gasSensorEnabled = true.obs;
  var hvacEnabled = true.obs;
  var awningEnabled = true.obs;
  var musicEnabled = true.obs;

  void storeIfChanged(AdjustmentStoredLocally newStoredLocally) async {
    var dataController = Get.find<DataController>();
    var sharedPreferences = await SharedPreferences.getInstance();
    if (motorhomeNumber.value != newStoredLocally.motorhomeNumber.value) {
      dataController.adjustment.other.storedLocally.motorhomeNumber.value = newStoredLocally.motorhomeNumber.value;
      sharedPreferences.setInt(MHConstantsStoredLocally.motorhomeNumber, newStoredLocally.motorhomeNumber.value);
    }
    if (waterLevelsSource.value != newStoredLocally.waterLevelsSource.value) {
      dataController.adjustment.other.storedLocally.waterLevelsSource.value = newStoredLocally.waterLevelsSource.value;
      sharedPreferences.setString(MHConstantsStoredLocally.waterLevelsSource, newStoredLocally.waterLevelsSource.value.name);
    }
    if (temperatureSource.value != newStoredLocally.temperatureSource.value) {
      dataController.adjustment.other.storedLocally.temperatureSource.value = newStoredLocally.temperatureSource.value;
      sharedPreferences.setString(MHConstantsStoredLocally.temperatureSource, newStoredLocally.temperatureSource.value.name);
    }
    if (motorsBlocker.value != newStoredLocally.motorsBlocker.value) {
      dataController.adjustment.other.storedLocally.motorsBlocker.value = newStoredLocally.motorsBlocker.value;
      sharedPreferences.setString(MHConstantsStoredLocally.motorsBlocker, newStoredLocally.motorsBlocker.value.name);
    }
    if (generatorAutoButtonFunction.value != newStoredLocally.generatorAutoButtonFunction.value) {
      dataController.adjustment.other.storedLocally.generatorAutoButtonFunction.value = newStoredLocally.generatorAutoButtonFunction.value;
      sharedPreferences.setString(MHConstantsStoredLocally.generatorAutoButtonFunction, newStoredLocally.generatorAutoButtonFunction.value.name);
    }
    if (bluetoothEnabled.value != newStoredLocally.bluetoothEnabled.value) {
      dataController.adjustment.other.storedLocally.bluetoothEnabled.value = newStoredLocally.bluetoothEnabled.value;
      sharedPreferences.setBool(MHConstantsStoredLocally.bluetoothEnabled, newStoredLocally.bluetoothEnabled.value);
    }
    if (airQualityValue.value != newStoredLocally.airQualityValue.value) {
      dataController.adjustment.other.storedLocally.airQualityValue.value = newStoredLocally.airQualityValue.value;
      sharedPreferences.setInt(MHConstantsStoredLocally.airQualityValue, newStoredLocally.airQualityValue.value);
    }
    if (airQualityTime.value != newStoredLocally.airQualityTime.value) {
      dataController.adjustment.other.storedLocally.airQualityTime.value = newStoredLocally.airQualityTime.value;
      sharedPreferences.setInt(MHConstantsStoredLocally.airQualityTime, newStoredLocally.airQualityTime.value);
    }

    if (gasSensorEnabled.value != newStoredLocally.gasSensorEnabled.value) {
      dataController.adjustment.other.storedLocally.gasSensorEnabled.value = newStoredLocally.gasSensorEnabled.value;
      sharedPreferences.setBool(MHConstantsStoredLocally.gasSensorEnabled, newStoredLocally.gasSensorEnabled.value);
    }
    if (hvacEnabled.value != newStoredLocally.hvacEnabled.value) {
      dataController.adjustment.other.storedLocally.hvacEnabled.value = newStoredLocally.hvacEnabled.value;
      sharedPreferences.setBool(MHConstantsStoredLocally.hvacEnabled, newStoredLocally.hvacEnabled.value);
    }
    if (awningEnabled.value != newStoredLocally.awningEnabled.value) {
      dataController.adjustment.other.storedLocally.awningEnabled.value = newStoredLocally.awningEnabled.value;
      sharedPreferences.setBool(MHConstantsStoredLocally.awningEnabled, newStoredLocally.awningEnabled.value);
    }
    if (musicEnabled.value != newStoredLocally.musicEnabled.value) {
      dataController.adjustment.other.storedLocally.musicEnabled.value = newStoredLocally.musicEnabled.value;
      sharedPreferences.setBool(MHConstantsStoredLocally.musicEnabled, newStoredLocally.musicEnabled.value);
    }
  }

  void restoreValues() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    motorhomeNumber.value = sharedPreferences.getInt(MHConstantsStoredLocally.motorhomeNumber) ?? 0;
    var waterLevelsSourceName = sharedPreferences.getString(MHConstantsStoredLocally.waterLevelsSource);
    waterLevelsSource.value = AdjustmentWaterLevelSource.values.firstWhereOrNull((element) => element.name == waterLevelsSourceName)  ?? AdjustmentWaterLevelSource.tank100;
    var temperatureSourceName = sharedPreferences.getString(MHConstantsStoredLocally.temperatureSource);
    temperatureSource.value = AdjustmentTemperatureSource.values.firstWhereOrNull((element) => element.name == temperatureSourceName) ?? AdjustmentTemperatureSource.airConditioning;
    var motorsBlockerName = sharedPreferences.getString(MHConstantsStoredLocally.motorsBlocker);
    motorsBlocker.value = AdjustmentMotorsBlocker.values.firstWhereOrNull((element) => element.name == motorsBlockerName) ?? AdjustmentMotorsBlocker.handbrake;
    var generatorAutoButtonFunctionName = sharedPreferences.getString(MHConstantsStoredLocally.generatorAutoButtonFunction);
    generatorAutoButtonFunction.value = AdjustmentGeneratorAutoButtonFunction.values.firstWhereOrNull((element) => element.name == generatorAutoButtonFunctionName) ?? AdjustmentGeneratorAutoButtonFunction.automaticPrimer;
    bluetoothEnabled.value = sharedPreferences.getBool(MHConstantsStoredLocally.bluetoothEnabled) ?? false;
    airQualityValue.value = sharedPreferences.getInt(MHConstantsStoredLocally.airQualityValue) ?? 0;
    airQualityTime.value = sharedPreferences.getInt(MHConstantsStoredLocally.airQualityTime) ?? 0;
    gasSensorEnabled.value = sharedPreferences.getBool(MHConstantsStoredLocally.gasSensorEnabled) ?? true;
    hvacEnabled.value = sharedPreferences.getBool(MHConstantsStoredLocally.hvacEnabled) ?? true;
    awningEnabled.value = sharedPreferences.getBool(MHConstantsStoredLocally.awningEnabled) ?? true;
    musicEnabled.value = sharedPreferences.getBool(MHConstantsStoredLocally.musicEnabled) ?? true;
  }
}

enum AdjustmentTemperatureSource {
  airConditioning("A/C"), heater("CALEFACTOR");

  const AdjustmentTemperatureSource(this.legibleName);
  final String legibleName;
}

enum AdjustmentWaterLevelSource {
  prc10("PRC"), tank100("TANK");

  const AdjustmentWaterLevelSource(this.legibleName);
  final String legibleName;
}

enum AdjustmentMotorsBlocker {
  handbrake("F. MANO"), vehicle("VEHICULO");

  const AdjustmentMotorsBlocker(this.legibleName);
  final String legibleName;
}

enum AdjustmentGeneratorAutoButtonFunction {
  startGenerator("ENC. GRUPO"), automaticPrimer("CEBADOR A/M");

  const AdjustmentGeneratorAutoButtonFunction(this.legibleName);
  final String legibleName;
}

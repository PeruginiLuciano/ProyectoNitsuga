import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/data_controller.dart';
import 'package:motorhome/controllers/communication_controller.dart';
import 'package:motorhome/controllers/views/config_view_controller.dart';
import 'package:motorhome/controllers/views/energy_view_controller.dart';
import 'package:motorhome/controllers/views/heating_view_controller.dart';
import 'package:motorhome/controllers/views/home_view_controller.dart';
import 'package:motorhome/controllers/views/lights_view_controller.dart';
import 'package:motorhome/controllers/views/main_view_controller.dart';
import 'package:motorhome/controllers/views/motors_view_controller.dart';
import 'package:motorhome/controllers/views/music_view_controller.dart';
import 'package:motorhome/utils/routes.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return GetMaterialApp(
      title: 'MotorHome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        fontFamily: 'Poppins',
        canvasColor: MHColors.blueDark,
      ),
      getPages: appRoutes,
      initialRoute: MHRoutes.main,
      // localizationsDelegates: [FormBuilderLocalizations.delegate],
      initialBinding: BindingsBuilder(
        () {
          Get.put(DataController());
          Get.put(CommunicationController());
          Get.put(MainViewController());

          Get.put(HomeViewController());
          Get.put(LightsViewController());
          Get.put(MotorsViewController());
          Get.put(EnergyViewController());
          Get.put(HeatingViewController());
          Get.put(MusicViewController());
          Get.put(ConfigViewController());
        },
      ),
    );
  }
}

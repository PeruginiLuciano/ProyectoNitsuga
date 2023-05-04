import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/main_view_controller.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/screens/config_screen.dart';
import 'package:motorhome/views/screens/energy_screen.dart';
import 'package:motorhome/views/screens/heating_screen.dart';
import 'package:motorhome/views/screens/home_screen.dart';
import 'package:motorhome/views/screens/lights_screen.dart';
import 'package:motorhome/views/screens/motors_screen.dart';
import 'package:motorhome/views/screens/music_screen.dart';
import 'package:motorhome/views/widgets/side_menu.dart';
import 'package:motorhome/views/widgets/top_bar.dart';

class MainScreen extends StatelessWidget {
  static String route = '/splash';

  const MainScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewController>(
    builder: (controller) => Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopBar(),
                Expanded(
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      width: screenWidth - 72,
                      child: const [
                        HomeScreen(),
                        LightsScreen(),
                        MotorsScreen(),
                        EnergyScreen(),
                        HeatingScreen(),
                        MusicScreen(),
                        ConfigScreen(),
                      ][controller.page.value.index],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SideMenu()
        ],
      ),
    )
    );
  }
}

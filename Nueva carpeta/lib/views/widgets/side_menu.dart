import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/main_view_controller.dart';
import 'package:motorhome/utils/routes.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewController>(
      builder: (controller) => 
      Container(
        width: 80,
        color: Colors.black,
        child: Obx(() =>
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SideMenuIconButton(
                icon: MHIcons.home,
                active: controller.page.value == Pages.home,
                onTap: () {
                  controller.page.value = Pages.home;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.bulb,
                active: controller.page.value == Pages.lights,
                onTap: () {
                  controller.page.value = Pages.lights;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.engine,
                active: controller.page.value == Pages.motors,
                onTap: () {
                  controller.page.value = Pages.motors;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.lightning,
                active: controller.page.value == Pages.energy,
                onTap: () {
                  controller.page.value = Pages.energy;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.thermometer,
                active: controller.page.value == Pages.heating,
                onTap: () {
                  controller.page.value = Pages.heating;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.music,
                active: controller.page.value == Pages.music,
                onTap: () {
                  controller.page.value = Pages.music;
                }
              ),
              SideMenuIconButton(
                icon: MHIcons.sliders,
                active: controller.page.value == Pages.config,
                onTap: () {
                  controller.page.value = Pages.config;
                }
              ),
            ],
          ),
        ),
      )
    );
  }
}

class SideMenuIconButton extends StatelessWidget {
  final String icon;
  final bool active;
  final Function() onTap;

  const SideMenuIconButton({
    Key? key,
    required this.icon,
    required this.active,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: svgIcon(
          icon,
          color: active ? MHColors.green : Colors.white,
          size: 42
        ),
      ),
    );
  }
}

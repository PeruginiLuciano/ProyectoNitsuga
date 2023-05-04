import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/controllers/views/modal_adjust_controller.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/modals/adjust_widgets/list_apperance.dart';
import 'package:motorhome/views/modals/adjust_widgets/list_engines.dart';
import 'package:motorhome/views/modals/adjust_widgets/list_others.dart';
import 'package:motorhome/views/modals/adjust_widgets/list_switches.dart';
import 'package:motorhome/views/modals/adjust_widgets/list_times.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/widgets/buttons/config_button.dart';
import 'package:motorhome/views/widgets/buttons/state_button.dart';

class ModalAdjust extends StatefulWidget {
  final bool isChangingPattern;

  const ModalAdjust({Key? key, this.isChangingPattern = false}) : super(key: key);

  @override
  State<ModalAdjust> createState() => _ModalAdjustState();
}

class _ModalAdjustState extends State<ModalAdjust> {

  @override
  Widget build(BuildContext context) {
    ModalAdjustViewController controller = Get.put(ModalAdjustViewController());

    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for(var item in ConfigItem.values)
                Obx(() =>
                  AdjustMenuButton(
                    title: item.name.toUpperCase(),
                    active: controller.currentConfig.value == item,
                    onTap: () {
                      controller.currentConfig.value = item;
                    },
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        Flexible(
          flex: 10,
          child: Obx(() =>
              Column(
                children: <Widget>[
                  Container(
                    child: const[
                      ListSwitchesTitle(),
                      ListEnginesTitle(),
                      ListEnginesTitle(),
                      ListOthersTitle(),
                      ListOthersTitle(),
                    ][controller.currentConfig.value.index],
                  ),
                const SizedBox(height: 15.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: const [
                      ListSwitches(),
                      ListEngines(),
                      ListTimes(),
                      ListOthers(),
                      ListApperance()
                    ][controller.currentConfig.value.index],
                  ),
                ),
                const Divider(color: Colors.white, height: 0),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StateButton(
                      width: 230,
                      title: 'CANCELAR',
                      active: false,
                      onTap: () {
                        Dialogs.remove();
                      },
                    ),

                    const SizedBox(width: 20.0),

                    StateButton(
                      width: 230,
                      title: 'ACEPTAR',
                      active: false,
                      onTap: () async {
                        Dialogs.spin();
                        await controller.sendNewValues();
                        Dialogs.remove();
                        Dialogs.remove();
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

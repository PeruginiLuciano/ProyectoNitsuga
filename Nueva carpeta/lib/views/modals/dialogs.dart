
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motorhome/utils/theme.dart';

class Dialogs {
  static Future launch({
    required Widget child,
    bool? clear = false
  }) {
    return Get.generalDialog(
      pageBuilder: (context, __, ___) => BlurBackground(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: clear! ? const EdgeInsets.all(20) : const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
          child: Container(
            decoration: BoxDecoration(
              color: clear ? Colors.transparent : MHColors.modalBackground,
              borderRadius: const BorderRadius.all(Radius.circular(35.0))
            ),
            padding: EdgeInsets.all(clear ? 0 : 20.0),
            child: child,
            // child: SingleChildScrollView(child: child)
          )
        )
      )
    );
  }

  static Future spin() {
    return Get.generalDialog(
      pageBuilder: (context, __, ___) => BlurBackground(
        child: WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MHColors.blue
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 10,
                  )
                ),
              ],
            ),
          ],
        ),
      )
    ));
  }
  
  static void remove() {
    return Get.back();
  }
}

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      top: 0.0,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: const Icon(
            Icons.close,
            color: MHColors.greyDark,
          ),
        )
      ),
    );
  }
}

class BlurBackground extends StatelessWidget {
  final Widget child;
  final double sigma;

  const BlurBackground({Key? key, required this.child, this.sigma = 10.0}) : super(key: key);

  @override
  Widget build(BuildContext context) => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
    child: child
  );
}

import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/widgets/buttons/modal_button.dart';
import 'package:motorhome/views/widgets/slide_unlock.dart';


class ModalUnlock extends StatefulWidget {
  final String title;
  final Function() onAccept;

  const ModalUnlock({
    Key? key,
    required this.title,
    required this.onAccept
  }) : super(key: key);

  @override
  State<ModalUnlock> createState() => _ModalUnlockState();
}

class _ModalUnlockState extends State<ModalUnlock> {
  bool _unlocked = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        svgIcon(MHIcons.alert, size: 80),
        const SizedBox(height: 25),
        Text(
          widget.title,
          style: MHTextStyles.h.copyWith(
            color: MHColors.blueDark
          ),
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 10),
        Text(
          'DESLICE EL BLOQUEO Y CONFIRME',
          style: MHTextStyles.h1.copyWith(
            color: MHColors.blueDark
          ),
          textAlign: TextAlign.center
        ),

        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: SlideUnlock(
            onSubmit: () {
              setState(() {
                _unlocked = true;
              });
            },
          ),
        ),
        const SizedBox(height: 50),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 130),

            Expanded(
              child: ModalButton(
                text: 'ABRIR',
                enabled: _unlocked,
                filled: true,
                onTap: () {

                  widget.onAccept();
                  Dialogs.remove();

                },
              ),
            ),

            const SizedBox(width: 30),
            Expanded(
              child: ModalButton(
                text: 'CANCELAR',
                enabled: true,
                filled: false,
                onTap: () {
                  Dialogs.remove();
                },
              ),
            ),

            const SizedBox(width: 130),

          ],
        ),
      ],
    );
  }
}



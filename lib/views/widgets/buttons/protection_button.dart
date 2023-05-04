import 'package:flutter/widgets.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';

class ProtectionButton extends StatefulWidget {
  final String title;
  final String details;
  final bool active;
  final Function() onTap;

  const ProtectionButton({Key? key, required this.title, required this.details, required this.active, required this.onTap})
      : super(key: key);

  @override
  State<ProtectionButton> createState() => _ProtectionButtonState();
}

class _ProtectionButtonState extends State<ProtectionButton> {
  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    border: Border.all(color: widget.active ? MHColors.green : MHColors.blueLight, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: svgIcon(widget.active ? MHIcons.checkFilled : MHIcons.checkOutline,
                      size: 70, color: widget.active ? MHColors.green : MHColors.blueLight),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: MHTextStyles.h1Bold),
                    Text(widget.details, style: MHTextStyles.h2, maxLines: 2)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

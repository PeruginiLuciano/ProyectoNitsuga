import 'package:flutter/material.dart';
import 'package:motorhome/utils/color_picker/picker.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/widgets/buttons/modal_button.dart';

class ModalColorPicker extends StatefulWidget {
  final ColorPickerType type;
  final Function(Color color) onSelect;
  final Color? initColor;

  const ModalColorPicker({
    Key? key,
    required this.type,
    required this.onSelect,
    this.initColor
  }) : super(key: key);

  @override
  State<ModalColorPicker> createState() => _ModalColorPickerState();
}

class _ModalColorPickerState extends State<ModalColorPicker> {
  Color? currentColor;
  Color? selectedColor;

  @override
  void initState() {
    currentColor = widget.initColor;
    selectedColor = widget.initColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
    widget.type == ColorPickerType.single ? buildSingle(context) : buildCustom(context);

  Widget buildSingle(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SingleColorBox(color: Colors.red, onTap: widget.onSelect),
                    _SingleColorBox(color: Colors.yellow, onTap: widget.onSelect),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SingleColorBox(color: Colors.green, onTap: widget.onSelect),
                    _SingleColorBox(color: Colors.cyan, onTap: widget.onSelect),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SingleColorBox(color: Colors.blue, onTap: widget.onSelect),
                    _SingleColorBox(color: Colors.purpleAccent, onTap: widget.onSelect),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SingleColorBox(color: Colors.orange, onTap: widget.onSelect),
                    _SingleColorBox(color: Colors.white, onTap: widget.onSelect),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 240,
          child: ModalButton(
            text: 'CERRAR',
            enabled: true,
            filled: false,
            onTap: () {
              Dialogs.remove();
            },
          ),
        )
      ],
    );
  }

  Widget buildCustom(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ColorBox(width: 350, height: 250, onChanged: (color) {
                  if (color != null) {
                    setState(() {
                      currentColor = color;
                      selectedColor = color;
                    });
                  }
                }),
                _ColorBox(width: 250, height: 250, color: currentColor, onChanged: (color) {
                  if (color != null) {
                    setState(() {
                      selectedColor = color;
                    });
                  }
                }),
                _SingleColorBox(width: 80, height: 250, color: selectedColor ?? Colors.white, onTap: (color) {},),
              ],
            )
        ),
        SizedBox(
          width: 240,
          child: ModalButton(
            text: 'CONFIRMAR',
            enabled: true,
            filled: false,
            onTap: () {
              final color = selectedColor;
              if (color != null) {
                widget.onSelect(color);
              }
              Dialogs.remove();
            },
          ),
        )
      ],
    );
  }
}

enum ColorPickerType {
  single, custom
}

class _SingleColorBox extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final Function(Color color) onTap;

  const _SingleColorBox({
    Key? key,
    required this.color,
    this.width = 100,
    this.height = 100,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: () {
          onTap.call(color);
        },
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: 3
              ),
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20.0))
          ),
        ),
      );
}

class _ColorBox extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Function(Color? color) onChanged;

  const _ColorBox({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.color,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      PixelColorPicker(
        color: color,
        onChanged: onChanged,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: 3
              ),
              gradient: color != null ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    color ?? Colors.white,
                    Colors.black
                  ]
              ) :
              const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.pink,
                    Colors.purple,
                    Colors.blue,
                    Colors.cyan,
                    Colors.green,
                    Colors.yellow,
                    Colors.red
                  ]
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0))
          ),
        ),
      );
}

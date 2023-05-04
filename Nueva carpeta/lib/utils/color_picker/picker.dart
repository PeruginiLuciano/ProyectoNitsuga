import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:motorhome/utils/color_picker/color_picker.dart';

class PixelColorPicker extends StatefulWidget {
  final Widget child;
  final Color? color;  // It's just to force redraw
  final Function(Color? color) onChanged;

  const PixelColorPicker({
    Key? key,
    required this.child,
    required this.color,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PixelColorPickerState createState() => _PixelColorPickerState();
}

class _PixelColorPickerState extends State<PixelColorPicker> {
  ColorPicker? _colorPicker;
  int _widthLimit = 0;
  int _heightLimit = 0;
  static const int borderWidth = 5;
  Color? _oldColor;

  final _repaintBoundaryKey = GlobalKey();
  final _interactiveViewerKey = GlobalKey();

  Future<ui.Image> _loadSnapshot() async {
    final RenderRepaintBoundary _repaintBoundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final _snapshot = await _repaintBoundary.toImage();
    return _snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: InteractiveViewer(
            key: _interactiveViewerKey,
            maxScale: 10,
            onInteractionUpdate: (details) {
              final _offset = details.focalPoint;

              _onInteract(_offset);
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }

  _onInteract(Offset offset) async {
    if (_colorPicker == null || _oldColor != widget.color) {
      final _snapshot = await _loadSnapshot();
      final _imageByteData = await _snapshot.toByteData(format: ui.ImageByteFormat.png);
      final _imageBuffer = _imageByteData!.buffer;
      final _uint8List = _imageBuffer.asUint8List();
      _colorPicker = ColorPicker(bytes: _uint8List);
      _widthLimit = _snapshot.width - borderWidth;
      _heightLimit = _snapshot.height - borderWidth;
      _snapshot.dispose();
      if (_oldColor != widget.color) {
        _oldColor = widget.color;
        return;
      }
    }

    final _localOffset = _findLocalOffset(offset);
    if (_localOffset.dx < borderWidth || _localOffset.dy < borderWidth || _localOffset.dx > _widthLimit || _localOffset.dy > _heightLimit) {
      return;
    }
    final _color = await _colorPicker!.getColor(pixelPosition: _localOffset);

    widget.onChanged(_color);
  }

  Offset _findLocalOffset(Offset offset) {
    final RenderBox _interactiveViewerBox = _interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
    final _localOffset = _interactiveViewerBox.globalToLocal(offset);
    return _localOffset;
  }
}

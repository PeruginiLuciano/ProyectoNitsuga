import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class AdjustRow extends StatefulWidget {
  final String title;
  final String unit;
  final double step;
  final double fixedValue;
  final double initialValue;
  final double limit;
  final Function(double value) onChange;

  const AdjustRow({
    Key? key,
    required this.title,
    this.unit = "A",
    this.step = 0.5,
    required this.fixedValue,
    required this.initialValue,
    this.limit = 10,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AdjustRow> createState() => _AdjustRowState();
}

class _AdjustRowState extends State<AdjustRow> {
  var currentValue = 0.0;

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(widget.title, style: MHTextStyles.adjustmentRow),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("${widget.fixedValue}${widget.unit}", style: MHTextStyles.adjustmentRow),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_circle_down_outlined, color: Colors.amber, size: 50.0),
                  onTap: () {
                    if (widget.fixedValue + currentValue > 0 && currentValue > (-1 * widget.limit)) {
                      setState(() {
                        currentValue -= widget.step;
                      });
                      widget.onChange(currentValue);
                    }
                  },
                ),

                Text("${currentValue >= 0 ? '+' : '-'}$currentValue${widget.unit}", style: MHTextStyles.adjustmentRow),

                GestureDetector(
                  child: const Icon(Icons.arrow_circle_up_outlined, color: Colors.amber, size: 50.0),
                  onTap: () {
                    if (widget.fixedValue + currentValue < 20 && currentValue < widget.limit) {
                      setState(() {
                        currentValue += widget.step;
                      });
                      widget.onChange(currentValue);
                    }
                  },
                ),
              ]
            ),
          )
        ],
      )
    );
  }
}

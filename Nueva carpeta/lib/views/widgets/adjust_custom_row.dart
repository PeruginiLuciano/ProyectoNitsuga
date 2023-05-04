import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';

class AdjustCustomRow extends StatefulWidget {
  final String title;
  final List<String> values;
  final String initialValue;
  final Function(int indexValue) onChange;

  const AdjustCustomRow({
    Key? key,
    required this.title,
    required this.values,
    required this.initialValue,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AdjustCustomRow> createState() => _AdjustCustomRowState();
}

class _AdjustCustomRowState extends State<AdjustCustomRow> {
  int current = 0;

  @override
  void initState() {
    current = widget.values.indexOf(widget.initialValue);
    current = current < 0 ? 0 : current;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(widget.title, style: MHTextStyles.adjustmentRow),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_circle_down_outlined, color: Colors.amber, size: 50.0),
                  onTap: () {
                    if (current > 0) {
                      setState(() {
                        current--;
                      });
                      widget.onChange(current);
                    }
                  },
                ),

                Text(widget.values[current], style: MHTextStyles.adjustmentRow),

                GestureDetector(
                  child: const Icon(Icons.arrow_circle_up_outlined, color: Colors.amber, size: 50.0),
                  onTap: () {
                    if (current < widget.values.length - 1) {
                      setState(() {
                        current++;
                      });
                      widget.onChange(current);
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

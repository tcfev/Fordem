import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_widget.dart';

class ColorSelector extends StatefulWidget {
  /// The list of colors you want to show
  final List<Color> colors;

  /// The index of selected color from list e.g. 0 for first one
  final int selectedColor;

  /// This parameter notify you when a color change
  // ignore: inference_failure_on_function_return_type
  final Function(int index, Color color) onSelect;

  /// The radius of the color buttons
  final double radius;

  /// The space between items and colors
  final int spaceBetweenItems;

  const ColorSelector(
      {Key key,
      @required this.colors,
      this.onSelect,
      this.selectedColor = 0,
      this.spaceBetweenItems = 20,
      this.radius = 18})
      : super(key: key);

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int selectedColor = 0;

  @override
  void initState() {
    selectedColor = widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.colors.map((e) => Row(
            children: [
              SizedBox(
                width: widget.spaceBetweenItems / 2,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = widget.colors.indexOf(e);
                  });
                  if (widget.onSelect != null) {
                    widget.onSelect(selectedColor, e);
                  }
                },
                child: ColorWidget(
                  shadow: true,
                  radius: widget.radius,
                  color: e,
                  selected: widget.colors.indexOf(e) == selectedColor,
                ),
              ),
              SizedBox(
                width: widget.spaceBetweenItems / 2,
              )
            ],
          )).toList(),
      ],
    );
}

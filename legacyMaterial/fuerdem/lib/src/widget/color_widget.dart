import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget(
      {Key key,
      this.selected = false,
      this.color = Colors.orange,
      this.radius = 10, this.shadow = false})
      : super(key: key);

  /// The Radius of the circle image selector
  final double radius;

  /// If the color is selected make it true
  final bool selected;

  /// The color of widget
  final Color color;

   /// Use shadow
  final bool shadow;

  @override
  Widget build(BuildContext context) => Container(
        child: Container(
          width: radius * 2 + 4,
          height: radius * 2 + 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius * 2),
            border: selected ? Border.all(color: Colors.grey, width: 1) : null,
            boxShadow: shadow ? [
              BoxShadow(color: Colors.black12, spreadRadius: 0.2, blurRadius: 0.5)
            ] : []
          ),
          child: Container(
            margin: EdgeInsets.all(2),
            width: radius * 2 - 8,
            height: radius * 2 - 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius * 2),
            ),
          ),
        ),
      );
}

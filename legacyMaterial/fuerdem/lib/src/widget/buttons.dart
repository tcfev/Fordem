import 'package:flutter/material.dart';

/// Simple Icon Button
class IconBtn<T> extends StatelessWidget {
  const IconBtn(
      {Key key, this.child, this.onTap, this.padding = 8, this.radius = 8})
      : super(key: key);

  final T child;
  final double padding;
  final VoidCallback onTap;
  final double radius;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(padding),
            child: T == IconData
                ? Icon(
                    child as IconData,
                    color: Colors.white,
                  )
                : child,
          ),
        ),
      );
}

/// Outlined button
class OutlinedBtn extends StatelessWidget {
  const OutlinedBtn(
      {Key key,
      this.child,
      this.onTap,
      this.padding = 8,
      this.radius = 8,
      this.stroke = 1,
      this.border,
      this.borderRadius})
      : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final double radius, stroke, padding;
  final BorderRadius borderRadius;
  final BoxBorder border;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: border ??
                  Border.all(
                      color: Colors.grey[900],
                      width: stroke,
                      style: BorderStyle.solid),
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      );
}

/// Filled Button
class FilledBtn extends StatelessWidget {
  const FilledBtn(
      {Key key,
      this.child,
      this.onTap,
      this.padding = 8,
      this.radius = 8,
      this.borderRadius})
      : super(key: key);

  final Widget child;
  final double padding;
  final VoidCallback onTap;
  final double radius;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900].withAlpha(240),
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      );
}

enum BtnTypes { outlined, filled }

class DynamicBtn extends StatelessWidget {
  const DynamicBtn(
      {Key key,
      this.padding = 8,
      this.onTap,
      this.radius = 8,
      this.child,
      this.buttonType = BtnTypes.outlined,
      this.stroke = 1,
      this.border,
      this.borderRadius})
      : super(key: key);

  final Widget child;
  final double padding;
  final VoidCallback onTap;
  final double radius, stroke;
  final BtnTypes buttonType;
  final BoxBorder border;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (buttonType == BtnTypes.outlined) {
      return OutlinedBtn(
        padding: padding,
        onTap: onTap,
        radius: radius,
        stroke: stroke,
        border: border,
        borderRadius: borderRadius,
        child: child,
      );
    } else {
      return FilledBtn(
        padding: padding,
        onTap: onTap,
        borderRadius: borderRadius,
        radius: radius,
        child: child,
      );
    }
  }
}

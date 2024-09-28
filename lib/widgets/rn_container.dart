import 'package:flutter/material.dart';
import 'package:local_tl_app/controllers/theme_controller.dart';

class RnContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding, margin;
  final Color? color;
  final BoxDecoration? decoration;

  // TODO: how much can I gain from making this const?
  RnContainer({
    required this.child,
    required this.color,
    this.padding = ThemeController.containerPadding,
    this.margin = EdgeInsets.zero,
    BoxDecoration? decoration,
    super.key,
  }) : decoration = decoration ??
            BoxDecoration(
              color: color,
              borderRadius: ThemeController.containerBorderRadius,
            );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}

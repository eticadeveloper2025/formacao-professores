import 'package:flutter/material.dart';

class ResponsiveContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ResponsiveContentContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.maxWidth = 1040,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

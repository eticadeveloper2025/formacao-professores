import 'package:flutter/material.dart';
import '../../../shared/widgets/circular_progress_widget.dart';

class ProgressRing extends StatelessWidget {
  final double percent;
  final double size;

  const ProgressRing({super.key, required this.percent, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return CircularProgressWidget(percent: percent, radius: size / 2);
  }
}

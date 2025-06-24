import 'package:client/core/widgets/custom_shapes/wave_bottom_clipper/wave_bottom_clipper.dart';
import 'package:flutter/material.dart';

class GWaveBottomClipperWidget extends StatelessWidget {
  const GWaveBottomClipperWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: WaveBottomClipper(), child: child);
  }
}
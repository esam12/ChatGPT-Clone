import 'package:flutter/material.dart';

class WaveBottomClipper extends CustomClipper<Path> {
  final double topBorderRadius;
  final double waveHeight; // Controls the depth of the dip from the bottom edge
  final double
  bottomCornerWaveDepth; // How much the wave dips at the corners before the main wave

  WaveBottomClipper({
    this.topBorderRadius = 15.0,
    this.waveHeight = 15.0, // How deep the main wave goes
    this.bottomCornerWaveDepth =
        15.0, // Depth of the curve at the immediate corners
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // Define key points for clarity
    final Offset topLeftStart = Offset(topBorderRadius, 0);
    final Offset topRight = Offset(width, 0);
    final Offset topRightCornerEnd = Offset(width, topBorderRadius);

    final Offset bottomRightStraightEnd = Offset(
      width,
      height - bottomCornerWaveDepth,
    );
    final Offset bottomRightCornerControl = Offset(width, height);
    final Offset bottomRightCornerEnd = Offset(
      width - bottomCornerWaveDepth,
      height,
    );

    final Offset bottomLeftCornerControl = Offset(0, height);
    final Offset bottomLeftCornerEnd = Offset(
      0,
      height - bottomCornerWaveDepth,
    );

    final Offset topLeftCornerEnd = Offset(0, topBorderRadius);

    // --- Drawing the Path ---

    // 1. Start at the top-left, after the radius start
    path.moveTo(topLeftStart.dx, topLeftStart.dy);

    // 2. Top straight line to top-right
    path.lineTo(topRight.dx, topRight.dy);

    // 3. Top-right rounded corner
    path.quadraticBezierTo(
      topRight.dx,
      topRightCornerEnd.dy,
      topRightCornerEnd.dx,
      topRightCornerEnd.dy,
    );

    // 4. Right straight side down to where the bottom wave/curve begins
    path.lineTo(bottomRightStraightEnd.dx, bottomRightStraightEnd.dy);

    // 5. Bottom-right corner curve (part of the wave starting from the right)
    // This creates a smooth transition from the straight edge to the wave.
    path.quadraticBezierTo(
      bottomRightCornerControl.dx,
      bottomRightCornerControl.dy,
      bottomRightCornerEnd.dx,
      bottomRightCornerEnd.dy,
    );

    // 6. Main wave segment (from bottom-right curve end to the deepest point)
    // The control point `cp1` dictates the curve's arc.
    final double cp1x = width * 0.75;
    final double cp1y = height - waveHeight;
    final Offset controlPoint1 = Offset(cp1x, cp1y);

    // The deepest point of the wave, which can dip below `height`
    final double midX = width / 2;
    final double midY = height + waveHeight;
    final Offset waveDeepestPoint = Offset(midX, midY);

    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      waveDeepestPoint.dx,
      waveDeepestPoint.dy,
    );

    // 7. Second part of the wave (from main dip to bottom-left corner curve start)
    // `cp2` is symmetric to `cp1` for a balanced wave.
    final double cp2x = width * 0.25;
    final double cp2y = height - waveHeight;
    final Offset controlPoint2 = Offset(cp2x, cp2y);

    final Offset waveEndToLeft = Offset(bottomCornerWaveDepth, height);

    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      waveEndToLeft.dx,
      waveEndToLeft.dy,
    );

    // 8. Bottom-left corner curve (completing the wave and connecting to the left side)
    path.quadraticBezierTo(
      bottomLeftCornerControl.dx,
      bottomLeftCornerControl.dy,
      bottomLeftCornerEnd.dx,
      bottomLeftCornerEnd.dy,
    );

    // 9. Left straight side up to top-left rounded corner start
    path.lineTo(topLeftCornerEnd.dx, topLeftCornerEnd.dy);

    // 10. Top-left rounded corner (closing the path)
    // This corner needs to connect back to the initial `moveTo` point.
    // The control point would be at (0,0) and the end point is `topRightStart`.
    path.quadraticBezierTo(0, 0, topLeftStart.dx, topLeftStart.dy);

    path.close(); // Closes the path by drawing a line from the current point to the first point

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper is WaveBottomClipper) {
      return oldClipper.topBorderRadius != topBorderRadius ||
          oldClipper.waveHeight != waveHeight ||
          oldClipper.bottomCornerWaveDepth != bottomCornerWaveDepth;
    }
    return true;
  }
}
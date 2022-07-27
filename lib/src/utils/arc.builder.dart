import 'dart:math';
import 'dart:ui';

/// Method that builds arcs based on the center point, radius and angles.
Path buildArc({
  required Point<double> center,
  required double radius,
  required double innerRadius,
  required double startAngle,
  required double endAngle,
}) {
  final innerRadiusStartPoint = Point<double>(
    innerRadius * cos(startAngle) + center.x,
    innerRadius * sin(startAngle) + center.y,
  );
  final innerRadiusEndPoint = Point<double>(
    innerRadius * cos(endAngle) + center.x,
    innerRadius * sin(endAngle) + center.y,
  );
  final radiusStartPoint = Point<double>(
    radius * cos(startAngle) + center.x,
    radius * sin(startAngle) + center.y,
  );
  final centerOffset = Offset(center.x, center.y);
  final path = Path();

  path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  path.arcTo(
    Rect.fromCircle(center: centerOffset, radius: radius),
    startAngle,
    endAngle - startAngle,
    true,
  );
  path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);
  path.arcTo(
    Rect.fromCircle(center: centerOffset, radius: innerRadius),
    endAngle,
    startAngle - endAngle,
    true,
  );
  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);

  return path;
}

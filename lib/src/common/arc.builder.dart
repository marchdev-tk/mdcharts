import 'dart:math';
import 'dart:ui';

/// Method that builds arcs based on the center point, radius and angles.
///
/// If edges of the arc must be rounded set [rounded] to `true`, otherwise edges
/// will be flat.
Path buildArc({
  required Point<double> center,
  required double outerRadius,
  required double innerRadius,
  required double startAngle,
  required double endAngle,
  bool rounded = false,
}) {
  final isFullCircle = endAngle - startAngle == 2 * pi;

  final innerRadiusStartPoint = Point<double>(
    innerRadius * cos(startAngle) + center.x,
    innerRadius * sin(startAngle) + center.y,
  );
  final innerRadiusEndPoint = Point<double>(
    innerRadius * cos(endAngle) + center.x,
    innerRadius * sin(endAngle) + center.y,
  );
  final radiusStartPoint = Point<double>(
    outerRadius * cos(startAngle) + center.x,
    outerRadius * sin(startAngle) + center.y,
  );
  final midpointAngle = (endAngle + startAngle) / 2;
  final centerOffset = Offset(center.x, center.y);
  final path = Path();

  path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  if (isFullCircle) {
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: outerRadius),
      startAngle,
      midpointAngle - startAngle,
      true,
    );
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: outerRadius),
      midpointAngle,
      endAngle - midpointAngle,
      true,
    );
  } else {
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: outerRadius),
      startAngle,
      endAngle - startAngle,
      true,
    );
  }
  if (rounded && endAngle > startAngle) {
    path.arcToPoint(
      Offset(innerRadiusEndPoint.x, innerRadiusEndPoint.y),
      radius: Radius.circular((outerRadius - innerRadius) / 2),
    );
  } else {
    path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);
  }
  if (isFullCircle) {
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: innerRadius),
      endAngle,
      midpointAngle - endAngle,
      true,
    );
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: innerRadius),
      midpointAngle,
      startAngle - midpointAngle,
      true,
    );
  } else {
    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: innerRadius),
      endAngle,
      startAngle - endAngle,
      true,
    );
  }
  if (rounded && endAngle > startAngle) {
    path.arcToPoint(
      Offset(radiusStartPoint.x, radiusStartPoint.y),
      radius: Radius.circular((outerRadius - innerRadius) / 2),
    );
  } else {
    path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  }

  return path;
}

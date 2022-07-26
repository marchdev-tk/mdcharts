// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/rendering.dart';

import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [GaugeChart].
class GaugeChartPainter extends CustomPainter {
  /// Constructs an instance of [GaugeChartPainter].
  const GaugeChartPainter(
    this.data,
    this.style,
    this.settings,
    this.valueCoef,
  );

  /// Set of required (and optional) data to construct the gauge chart.
  final GaugeChartData data;

  /// Provides various customizations for the gauge chart.
  final GaugeChartStyle style;

  /// Provides various settings for the gauge chart.
  final GaugeChartSettings settings;

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

  /// Normalization method.
  ///
  /// Converts provided [value] based on [data.total] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value) {
    final normalizedValue = 1 - value / data.total;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  double _radius(Size size) => size.width / 2;

  Point _centerPoint(Size size) => Point(_radius(size), size.height / 2);

  double get endAngle {
    double angle = (settings.gaugeAngle - 180) / 2 * pi / 180;
    return 2 * pi + angle;
  }

  double get startAngle {
    double angle = (settings.gaugeAngle - 180) / 2 * pi / 180;
    return pi - angle;
  }

  /// Background painter.
  void paintBackground(Canvas canvas, Size size) {
    final path = buildArc(
      center: _centerPoint(size),
      innerRadius: _radius(size) - settings.sectionStroke,
      radius: _radius(size),
      startAngle: startAngle,
      endAngle: endAngle,
    );
    final borderPath = buildArc(
      center: _centerPoint(size),
      innerRadius: _radius(size) -
          settings.sectionStroke +
          style.backgroundStyle.borderStroke / 2,
      radius: _radius(size) - style.backgroundStyle.borderStroke / 2,
      startAngle: startAngle,
      endAngle: endAngle,
    );

    canvas.drawPath(
      path,
      style.backgroundStyle.backgroundPaint,
    );
    canvas.drawPath(
      borderPath,
      style.backgroundStyle.getBorderPaint(path.getBounds()),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GaugeChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

Path buildArc({
  required Point center,
  required double radius,
  required double innerRadius,
  required double startAngle,
  required double endAngle,
  bool rounded = false,
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
  final centerOffset = Offset(center.x as double, center.y as double);

  final path = Path();

  path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);

  path.arcTo(
    Rect.fromCircle(center: centerOffset, radius: radius),
    startAngle,
    endAngle - startAngle,
    true,
  );

  if (rounded && endAngle > startAngle) {
    path.arcToPoint(
      Offset(innerRadiusEndPoint.x, innerRadiusEndPoint.y),
      radius: Radius.circular((radius - innerRadius) / 2),
    );
  } else {
    path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);
  }

  path.arcTo(
    Rect.fromCircle(center: centerOffset, radius: innerRadius),
    endAngle,
    startAngle - endAngle,
    true,
  );

  // Drawing two copies of this line segment, before and after the arcs,
  // ensures that the path actually gets closed correctly.
  if (rounded && endAngle > startAngle) {
    path.arcToPoint(
      Offset(radiusStartPoint.x, radiusStartPoint.y),
      radius: Radius.circular((radius - innerRadius) / 2),
    );
  } else {
    path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  }

  return path;
}

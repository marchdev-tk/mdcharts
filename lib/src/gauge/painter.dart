// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:ui';

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';

import '../utils.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [GaugeChart].
class GaugeChartPainter extends CustomPainter {
  /// Constructs an instance of [GaugeChartPainter].
  GaugeChartPainter(
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
  double normalize(double value) {
    final normalizedValue = value / data.total;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  /// Normalization method for the list of values.
  ///
  /// Under the hood uses [normalize] method.
  ///
  /// Converts [data.data] values based on [data.total] into a percentage
  /// proportion with valid values in inclusive range [0..1], so sum of the list
  /// values will be always `1`.
  List<double> get normalizedList {
    final values = data.data.map(normalize).toList();
    final rest = 1 - values.sum;

    if (rest == 1) {
      return [1];
    }

    final index = values.indexOf(values.min);
    values[index] += rest;
    return values;
  }

  /// Calculates section color based either on [settings.colorPattern] or
  /// [style.sectionStyle.colors].
  /// 
  /// Pattern takes precedence over color list, but it still uses color list to
  /// fullfill it's purpose.
  Color sectionColor(int index) {
    final pattern = settings.colorPattern;
    final colors = style.sectionStyle.colors;

    assert(pattern?.isNotEmpty == true ||
        colors.length == data.data.length ||
        colors.length == 1);

    if (pattern?.isNotEmpty == true) {
      return colors[pattern![index % pattern.length]];
    }
    if (colors.length == 1) {
      return colors[0];
    }

    return colors[index];
  }

  double _radius(Size size) => size.shortestSide / 2;

  Point<double>? _centerPoint;
  Point<double> _centerPointFallback(Size size) =>
      Point(_radius(size), size.height / 2);

  double get _gaugeExtraAngle => (settings.gaugeAngle - 180) / 2 * pi / 180;
  double get _startAngle => pi - _gaugeExtraAngle;
  double get _endAngle => 2 * pi + _gaugeExtraAngle;

  /// Background painter.
  void paintBackground(Canvas canvas, Size size) {
    final radius = _radius(size);
    final innerRadius = radius - settings.sectionStroke;
    _centerPoint ??= _centerPointFallback(size);

    // building arc to get size of the path
    var path = buildArc(
      center: _centerPoint!,
      innerRadius: innerRadius,
      radius: radius,
      startAngle: _startAngle,
      endAngle: _endAngle,
    );

    /// this Y axis bias calculation are `inaccurate` due to [path.getBounds()]
    /// elaborate paths accuracy issue
    final pathSize = path.getBounds().size;
    double yBias;
    if (settings.gaugeAngle > 180) {
      yBias = pathSize.height / 2 - (pathSize.height - radius) / 2;
    } else if (settings.gaugeAngle < 180) {
      yBias = pathSize.height / 2 - (radius - pathSize.height) / 2;
    } else {
      yBias = pathSize.height / 2;
    }
    // adjusting center point according to path size
    _centerPoint = Point(
      size.width / 2,
      size.height / 2 + yBias,
    );

    path = buildArc(
      center: _centerPoint!,
      innerRadius: innerRadius,
      radius: radius,
      startAngle: _startAngle,
      endAngle: _endAngle,
    );
    final borderPath = buildArc(
      center: _centerPoint!,
      innerRadius: innerRadius + style.backgroundStyle.borderStroke / 2,
      radius: radius - style.backgroundStyle.borderStroke / 2,
      startAngle: _startAngle,
      endAngle: _endAngle,
    );

    if (settings.debugMode) {
      canvas.drawPoints(
        PointMode.points,
        [Offset(_centerPoint!.x, _centerPoint!.y)],
        Paint()
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFFFF00),
      );
      canvas.drawPoints(
        PointMode.points,
        [Offset(size.width / 2, size.height / 2)],
        Paint()
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF00FFFF),
      );
      canvas.drawRect(
        path.getBounds(),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.square
          ..color = const Color(0xFFFF00FF),
      );
    }

    canvas.drawPath(
      path,
      style.backgroundStyle.backgroundPaint,
    );
    canvas.drawPath(
      borderPath,
      style.backgroundStyle.getBorderPaint(path.getBounds()),
    );
    canvas.drawShadow(
      path,
      style.backgroundStyle.shadowColor,
      style.backgroundStyle.shadowElevation,
      false,
    );
  }

  /// Sections painter.
  void paintSections(Canvas canvas, Size size) {
    if (data.data.isEmpty) {
      return;
    }

    final radius = _radius(size) - style.backgroundStyle.borderStroke;
    final innerRadius = radius -
        settings.sectionStroke +
        style.backgroundStyle.borderStroke * 2;
    final normalizedData = normalizedList;
    final angleDiff = _endAngle - _startAngle;
    double startAngle = _startAngle;

    for (var i = 0; i < normalizedData.length; i++) {
      final endAngle = startAngle + angleDiff * normalizedData[i];

      final path = buildArc(
        center: _centerPoint!,
        radius: radius,
        innerRadius: innerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      canvas.drawPath(
        path,
        style.sectionStyle.sectionPaint..color = sectionColor(i),
      );

      startAngle = endAngle;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintSections(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GaugeChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      valueCoef != oldDelegate.valueCoef;
}

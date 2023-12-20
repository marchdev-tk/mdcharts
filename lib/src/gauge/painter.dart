// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:ui';

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';

import '../utils.dart';
import 'cache.dart';
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
    this.oldData,
    this.dataHashCode,
    this.valueCoef,
  );

  /// Set of required (and optional) data to construct the gauge chart.
  final GaugeChartData data;

  /// Provides various customizations for the gauge chart.
  final GaugeChartStyle style;

  /// Provides various settings for the gauge chart.
  final GaugeChartSettings settings;

  /// Set of required (and optional) `BUT OLD` data to construct the gauge
  /// chart.
  final GaugeChartData? oldData;

  /// Hash code of the `data` to use for cache storing.
  final int dataHashCode;

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

  /// List of path holders for hit tests and selection.
  final pathHolders = <GaugeChartPathDataHolder>[];

  /// Path of the background border to paint.
  Path? _borderPath;

  /// Normalization method.
  ///
  /// Converts provided [value] based on [total] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  double normalize(double value, double total) {
    final normalizedValue = value / total;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  /// Normalization method for the list of values.
  ///
  /// Under the hood uses [normalize] method.
  ///
  /// Converts [data.data] values based on [data.total] into a percentage
  /// proportion with valid values in inclusive range [0..1], so sum of the list
  /// values will be always `1`.
  List<double> normalizeList(GaugeChartData? data) {
    if (data == null) {
      return [0];
    }

    final values =
        data.data.map((value) => normalize(value, data.total)).toList();
    final rest = 1 - values.sum;

    if (rest == 1) {
      return List.generate(values.length, (index) => index == 0 ? 1 : 0);
    }

    if (rest == 0) {
      return values;
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

  /// Converts [HitTestBehavior] into a bool variable with corresponding state
  /// that is used by [hitTest].
  bool? get defualtHitTestResult {
    switch (settings.behavior) {
      case HitTestBehavior.deferToChild:
        return null;
      case HitTestBehavior.opaque:
        return true;
      case HitTestBehavior.translucent:
        return false;
    }
  }

  double _radius(Size size) => size.width / 2;

  Point<double>? _centerPoint;
  Point<double> _centerPointFallback(Size size) =>
      Point(_radius(size), size.height / 2);

  double get _gaugeExtraAngle => (settings.gaugeAngle - 180) / 2 * pi / 180;
  double get _startAngle => pi - _gaugeExtraAngle;
  double get _endAngle => 2 * pi + _gaugeExtraAngle;

  /// Background painter.
  void paintBackground(Canvas canvas, Size size) {
    final radius = _radius(size) -
        max(settings.selectedSectionStroke - settings.sectionStroke, 0);
    final innerRadius = radius - settings.sectionStroke;
    _centerPoint ??= _centerPointFallback(size);

    // building arc to get size of the path
    var path = buildArc(
      center: _centerPoint!,
      innerRadius: innerRadius,
      outerRadius: radius,
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
      outerRadius: radius,
      startAngle: _startAngle,
      endAngle: _endAngle,
    );
    if (style.backgroundStyle.borderFilled) {
      _borderPath = buildArc(
        center: _centerPoint!,
        innerRadius: innerRadius + style.backgroundStyle.borderStroke / 2,
        outerRadius: radius - style.backgroundStyle.borderStroke / 2,
        startAngle: _startAngle,
        endAngle: _endAngle,
      );
    }

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

    canvas.drawShadow(
      path,
      style.backgroundStyle.shadowColor,
      style.backgroundStyle.shadowElevation,
      false,
    );
    canvas.drawPath(
      path,
      style.backgroundStyle.backgroundPaint,
    );
  }

  /// Sections painter.
  void paintSections(Canvas canvas, Size size) {
    pathHolders.clear();

    if (data.data.isEmpty) {
      return;
    }

    final radius = _radius(size) -
        max(settings.selectedSectionStroke - settings.sectionStroke, 0);
    final innerRadius = radius - settings.sectionStroke;
    final normalizedData = normalizeList(data);
    final normalizedOldData = normalizeList(oldData);
    while (normalizedData.length < normalizedOldData.length) {
      normalizedData.add(0);
    }
    final angleDiff = _endAngle - _startAngle;
    double startAngle = _startAngle;

    for (var i = 0; i < normalizedData.length; i++) {
      final oldValue =
          i > normalizedOldData.length - 1 ? 0 : normalizedOldData[i];
      final newValue = normalizedData[i];
      final value = oldValue + (newValue - oldValue) * valueCoef;
      final endAngle = startAngle + angleDiff * value;

      final path = buildArc(
        center: _centerPoint!,
        outerRadius: radius,
        innerRadius: innerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      pathHolders.add(GaugeChartPathDataHolder(startAngle, endAngle, path));
      canvas.drawPath(
        path,
        style.sectionStyle.sectionPaint..color = sectionColor(i),
      );

      startAngle = endAngle;
    }
  }

  /// Background border painter.
  void paintBackgroundBorder(Canvas canvas, Size size) {
    if (_borderPath == null || !style.backgroundStyle.borderFilled) {
      return;
    }

    // TODO: large borders are drawing outside of the path on the bottom side,
    // need to figure out how to fix it.
    canvas.drawPath(
      _borderPath!,
      style.backgroundStyle.getBorderPaint(_borderPath!.getBounds()),
    );
  }

  /// Selected section painter.
  void paintSelectedSection(Canvas canvas, Size size) {
    if (data.selectedIndex == null && oldData?.selectedIndex == null) {
      return;
    }

    final i = data.selectedIndex ?? 0;
    final adjustedI = i >= data.data.length ? data.data.length - 1 : i;
    final oldI = oldData?.selectedIndex ?? 0;
    final adjustedOldI =
        oldI >= oldData!.data.length ? oldData!.data.length - 1 : oldI;
    final hasI = data.selectedIndex != null;
    final hasOldI = oldData?.selectedIndex != null;

    final radius = _radius(size);
    final innerRadius = radius -
        settings.sectionStroke -
        max(settings.selectedSectionStroke - settings.sectionStroke, 0);

    final oldStartAngle =
        hasOldI ? pathHolders[adjustedOldI].startAngle : _startAngle;
    final oldEndAngle =
        hasOldI ? pathHolders[adjustedOldI].endAngle : _startAngle;
    final newStartAngle =
        hasI ? pathHolders[adjustedI].startAngle : _startAngle;
    final newEndAngle = hasI ? pathHolders[adjustedI].endAngle : _startAngle;

    final startAngle =
        oldStartAngle + (newStartAngle - oldStartAngle) * valueCoef;
    final endAngle = oldEndAngle + (newEndAngle - oldEndAngle) * valueCoef;

    final path = buildArc(
      center: _centerPoint!,
      outerRadius: radius,
      innerRadius: innerRadius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
    canvas.drawPath(
      path,
      style.sectionStyle.selectedSectionPaint,
    );

    if (style.sectionStyle.selectedBorderStroke > 0) {
      final borderPath = buildArc(
        center: _centerPoint!,
        outerRadius: innerRadius + style.sectionStyle.selectedBorderStroke,
        innerRadius: innerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      canvas.drawPath(
        borderPath,
        style.sectionStyle.selectedSectionBorderPaint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintSections(canvas, size);
    paintBackgroundBorder(canvas, size);
    paintSelectedSection(canvas, size);

    cache.savePathHolders(dataHashCode, pathHolders);
  }

  @override
  bool shouldRepaint(covariant GaugeChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      oldData != oldDelegate.oldData ||
      valueCoef != oldDelegate.valueCoef;

  @override
  bool? hitTest(Offset position) => defualtHitTestResult;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show Point, max, pi, sqrt;

import 'package:flinq/flinq.dart';
import 'package:flutter/widgets.dart';

import '../common.dart';
import '../utils.dart';
import 'cache.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

class DonutPainter extends CustomPainter {
  DonutPainter(
    this.data,
    this.settings,
    this.style,
    this.oldData,
    this.dataHashCode,
    this.valueCoef,
  );

  /// Set of required (and optional) data to construct the donut chart.
  final DonutChartData data;

  /// Provides various customizations for the donut chart.
  final DonutChartStyle style;

  /// Provides various settings for the donut chart.
  final DonutChartSettings settings;

  /// Set of required (and optional) `BUT OLD` data to construct the donut
  /// chart.
  final DonutChartData? oldData;

  /// Hash code of the `data` to use for cache storing.
  final int dataHashCode;

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

  /// List of path holders for hit tests and selection.
  final pathHolders = <ArcDataHolder>[];

  double _innerWidth = 0;

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
  List<double> normalizeList(DonutChartData? data) {
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

  Point<double> _centerPoint(Size size) =>
      Point(size.width / 2, size.height / 2);
  double _radius(Size size) => size.shortestSide / 2;
  double _outerRadius(Size size) =>
      _radius(size) -
      max(settings.selectedSectionStroke - settings.sectionStroke, 0);
  double _innerRadius(Size size) => _outerRadius(size) - settings.sectionStroke;

  /// Background painter.
  void paintBackground(Canvas canvas, Size size) {
    final path = buildArc(
      center: _centerPoint(size),
      innerRadius: _innerRadius(size),
      outerRadius: _outerRadius(size),
      startAngle: 0,
      endAngle: 2 * pi,
    );

    canvas.drawShadow(
      path,
      style.backgroundStyle.shadowColor,
      style.backgroundStyle.shadowElevation,
      style.backgroundStyle.color.alpha < 255,
    );
    canvas.drawPath(
      path,
      style.backgroundStyle.backgroundPaint,
    );

    if (settings.debugMode) {
      const canvasColor = Color(0xAA00FF00);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = canvasColor
          ..style = PaintingStyle.stroke,
      );
      MDTextPainter(TextSpan(
        text: 'CANVAS W:${size.width} H:${size.height}',
        style: const TextStyle(
          color: canvasColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          backgroundColor: Color(0xFF000000),
        ),
      )).paint(canvas, const Offset(8, 4));

      final chartRect = path.getBounds();
      const chartColor = Color(0xAAFF0000);
      canvas.drawRect(
        chartRect,
        Paint()
          ..color = chartColor
          ..style = PaintingStyle.stroke,
      );
      MDTextPainter(TextSpan(
        text: 'CHART W:${chartRect.size.width} H:${chartRect.size.height}',
        style: const TextStyle(
          color: chartColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          backgroundColor: Color(0xFF000000),
        ),
      )).paint(canvas, Offset(chartRect.left + 8, chartRect.top + 4));
    }
  }

  /// Sections painter.
  void paintSections(Canvas canvas, Size size) {
    pathHolders.clear();

    if (data.data.isEmpty) {
      return;
    }

    final normalizedData = normalizeList(data);
    final normalizedOldData = normalizeList(oldData);
    while (normalizedData.length < normalizedOldData.length) {
      normalizedData.add(0);
    }
    var startAngle = -0.5 * pi;

    for (var i = 0; i < normalizedData.length; i++) {
      final oldValue =
          i > normalizedOldData.length - 1 ? 0 : normalizedOldData[i];
      final newValue = normalizedData[i];
      final value = oldValue + (newValue - oldValue) * valueCoef;
      final endAngle = startAngle + 2 * pi * value;

      final path = buildArc(
        center: _centerPoint(size),
        outerRadius: _outerRadius(size),
        innerRadius: _innerRadius(size),
        startAngle: startAngle,
        endAngle: endAngle,
      );
      pathHolders.add(ArcDataHolder(startAngle, endAngle, path));
      canvas.drawPath(
        path,
        style.sectionStyle.sectionPaint..color = sectionColor(i),
      );

      startAngle = endAngle;

      if (settings.debugMode) {
        final rect = path.getBounds();
        final color = sectionColor(i);
        canvas.drawRect(
          rect,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke,
        );
        MDTextPainter(TextSpan(
          text: 'CHART W:${rect.size.width} H:${rect.size.height}',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            backgroundColor: const Color(0xFF000000),
          ),
        )).paint(canvas, Offset(rect.left + 8, rect.top + 4 + 14 * (i + 1)));
      }
    }
  }

  /// Background border painter.
  void paintBackgroundBorder(Canvas canvas, Size size) {
    final center = _centerPoint(size);
    final outerRadius = _outerRadius(size);
    final innerRadius = _innerRadius(size);

    if (style.backgroundStyle.hasInnerBorder) {
      final innerBorderPath = buildArc(
        center: center,
        outerRadius: innerRadius + style.backgroundStyle.innerBorderStroke,
        innerRadius: innerRadius,
        startAngle: 0,
        endAngle: 2 * pi,
      );
      canvas.drawPath(
        innerBorderPath,
        style.backgroundStyle.getInnerBorderPaint(innerBorderPath.getBounds()),
      );
    }

    if (style.backgroundStyle.hasOuterBorder) {
      final outerBorderPath = buildArc(
        center: center,
        outerRadius: outerRadius,
        innerRadius: outerRadius - style.backgroundStyle.outerBorderStroke,
        startAngle: 0,
        endAngle: 2 * pi,
      );
      canvas.drawPath(
        outerBorderPath,
        style.backgroundStyle.getOuterBorderPaint(outerBorderPath.getBounds()),
      );
    }
  }

  /// Selected section painter
  void paintSelectedSection(Canvas canvas, Size size) {
    if (data.selectedIndex == null && oldData?.selectedIndex == null) {
      return;
    }

    final i = data.selectedIndex ?? 0;
    final adjustedI = i >= data.data.length ? data.data.length - 1 : i;
    final oldI = oldData?.selectedIndex ?? 0;
    final adjustedOldI =
        oldI >= (oldData?.data.length ?? -1) ? oldData!.data.length - 1 : oldI;
    final hasI = data.selectedIndex != null;
    final hasOldI = oldData?.selectedIndex != null;

    final center = _centerPoint(size);
    final outerRadius = _radius(size);
    final innerRadius = _innerRadius(size);

    const baseAngle = -0.5 * pi;
    final oldStartAngle =
        hasOldI ? pathHolders[adjustedOldI].startAngle : baseAngle;
    final oldEndAngle =
        hasOldI ? pathHolders[adjustedOldI].endAngle : baseAngle;
    final newStartAngle = hasI ? pathHolders[adjustedI].startAngle : baseAngle;
    final newEndAngle = hasI ? pathHolders[adjustedI].endAngle : baseAngle;

    final startAngle =
        oldStartAngle + (newStartAngle - oldStartAngle) * valueCoef;
    final endAngle = oldEndAngle + (newEndAngle - oldEndAngle) * valueCoef;

    final path = buildArc(
      center: center,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
    canvas.drawPath(
      path,
      style.sectionStyle.selectedSectionPaint,
    );

    if (style.sectionStyle.hasSelectedInnerBorder) {
      final innerBorderPath = buildArc(
        center: center,
        outerRadius: innerRadius + style.sectionStyle.selectedInnerBorderStroke,
        innerRadius: innerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      canvas.drawPath(
        innerBorderPath,
        style.sectionStyle
            .getSelectedInnerBorderPaint(innerBorderPath.getBounds()),
      );
    }

    if (style.sectionStyle.hasSelectedOuterBorder) {
      final outerBorderPath = buildArc(
        center: center,
        outerRadius: outerRadius,
        innerRadius: outerRadius - style.sectionStyle.selectedOuterBorderStroke,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      canvas.drawPath(
        outerBorderPath,
        style.sectionStyle
            .getSelectedOuterBorderPaint(outerBorderPath.getBounds()),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final innerWidth = _innerRadius(size) * sqrt(2);
    if (_innerWidth != innerWidth) {
      _innerWidth = innerWidth;
      data.onInscribedInCircleSizeChanged?.call(innerWidth);
    }

    paintBackground(canvas, size);
    paintSections(canvas, size);
    paintBackgroundBorder(canvas, size);
    paintSelectedSection(canvas, size);

    cache.savePathHolders(dataHashCode, pathHolders);
  }

  @override
  bool shouldRepaint(DonutPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      oldData != oldDelegate.oldData ||
      valueCoef != oldDelegate.valueCoef;

  @override
  bool? hitTest(Offset position) => defualtHitTestResult;
}

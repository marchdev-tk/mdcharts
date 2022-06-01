// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

import '../common.dart';
import '../utils.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [BarChart].
class BarChartPainter extends CustomPainter {
  /// Constructs an instance of [BarChartPainter].
  const BarChartPainter(
    this.data,
    this.style,
    this.settings,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the bar chart.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with "beautiful" integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  double get roundedMaxValue => getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );

  /// Normalization method.
  ///
  /// Converts provided [value] based on [roundedMaxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value) {
    final normalizedValue = 1 - value / roundedMaxValue;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  /// Axis painter.
  void paintAxis(Canvas canvas, Size size) {
    if (!settings.showAxisX) {
      return;
    }

    final axisPaint = style.axisStyle.paint;
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    canvas.drawLine(bottomLeft, bottomRight, axisPaint);
  }

  /// Bar painter.
  void paintBar(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final barTopRadius = Radius.circular(style.barStyle.topRadius);
    final zeroBarTopRadius = Radius.circular(style.barStyle.zeroBarTopRadius);

    final barItemQuantity = data.data.values.first.length;
    final barWidth = style.barStyle.width;
    final barSpacing = settings.barSpacing;
    final itemSpacing = settings.itemSpacing;

    final itemWidth =
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    final colors = List.of(style.barStyle.colors);

    assert(
      colors.length == 1 || colors.length == barItemQuantity,
      'List of colors must contain either 1 color or quantity that is equal to '
      'bar quantity in an item',
    );
    if (colors.length == 1 && barItemQuantity > 1) {
      colors.add(colors.first
          .withOpacity((barItemQuantity - 1) * 1 / barItemQuantity));
    }

    for (var i = 0; i < data.data.length; i++) {
      final item = data.data.entries.elementAt(i);

      for (var j = item.value.length - 1; j >= 0; j--) {
        final barValue = item.value[j];

        final radius = style.barStyle.showZeroBars && barValue == 0
            ? zeroBarTopRadius
            : barTopRadius;
        final top =
            normalize(barValue) * size.height - style.barStyle.zeroBarHeight;

        final itemOffset = (itemSpacing + itemWidth) * i;
        final barRight = size.width -
            barWidth * (item.value.length - 1 - j) -
            barSpacing * (item.value.length - 1 - j);
        final barLeft = barRight - barWidth;

        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            barLeft - itemOffset,
            top,
            barRight - itemOffset,
            size.height,
            topLeft: radius,
            topRight: radius,
          ),
          Paint()
            ..style = PaintingStyle.fill
            ..color = colors[j],
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintAxis(canvas, size);
    paintBar(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// Grid painter of the [BarChart].
class BarChartGridPainter extends CustomPainter {
  /// Constructs an instance of [BarChartGridPainter].
  const BarChartGridPainter(
    this.data,
    this.style,
    this.settings,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the bar chart.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with "beautiful" integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  double get roundedMaxValue => getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.yAxisDivisions == 0) {
      return;
    }

    final yDivisions = settings.yAxisDivisions + 1;
    final heightFraction = size.height / yDivisions;
    final hasTop = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.vertical ||
        settings.axisDivisionEdges == AxisDivisionEdges.top;
    final hasBottom = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.vertical ||
        settings.axisDivisionEdges == AxisDivisionEdges.bottom;
    final yStart = hasTop ? 0 : 1;
    final yEnd = hasBottom ? yDivisions + 1 : yDivisions;
    for (var i = yStart; i < yEnd; i++) {
      canvas.drawLine(
        Offset(0, heightFraction * i),
        Offset(size.width, heightFraction * i),
        style.gridStyle.paint,
      );

      /// skip paint of y axis labels if [showAxisYLabels] is set to `true`
      /// or
      /// force to skip last (beneath axis) division paint of axis label.
      if (!settings.showAxisYLabels || hasBottom && i == yEnd - 1) {
        continue;
      }

      final labelValue = roundedMaxValue * (yDivisions - i) / yDivisions;
      final textPainter = MDTextPainter(
        TextSpan(
          text: data.yAxisLabelBuilder(labelValue),
          style: style.axisStyle.yAxisLabelStyle,
        ),
      );

      textPainter.paint(
        canvas,
        Offset(0, heightFraction * i + style.gridStyle.paint.strokeWidth),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartGridPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

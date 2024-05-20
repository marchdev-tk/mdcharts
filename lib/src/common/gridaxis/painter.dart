// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

import '../../models.dart';
import '../../utils.dart';
import '../text.painter.dart';
import 'cache.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';
import 'utils.dart';

/// Grid and Axis painter of the [GridAxis].
class GridAxisPainter extends CustomPainter {
  /// Constructs an instance of [GridAxisPainter].
  const GridAxisPainter(
    this.cache,
    this.data,
    this.style,
    this.settings,
    this.onYAxisLabelSizeCalculated,
  );

  /// Cache holder of the GridAxis data that requries heavy computing.
  final GridAxisCacheHolder cache;

  /// Set of required (and optional) data to construct the bar chart.
  final GridAxisData data;

  /// Provides various customizations for the bar chart.
  final GridAxisStyle style;

  /// Provides various settings for the bar chart.
  final GridAxisSettings settings;

  /// Callback that notifies that Y axis label size successfuly calculated.
  final ValueChanged<double> onYAxisLabelSizeCalculated;

  /// {@macro GridAxisUtils.getRoundedDivisionSize}
  double get roundedDivisionSize =>
      GridAxisUtils().getRoundedDivisionSize(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMinValue}
  double get roundedMinValue =>
      GridAxisUtils().getRoundedMinValue(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMaxValue}
  double get roundedMaxValue =>
      GridAxisUtils().getRoundedMaxValue(cache, data, settings);

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.xAxisDivisions == 0 && settings.yAxisDivisions == 0) {
      return;
    }

    var maxLabelWidth = .0;

    final xDivisions = settings.xAxisDivisions + 1;
    final widthFraction = size.width / xDivisions;
    final hasLeft = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.horizontal ||
        settings.axisDivisionEdges == AxisDivisionEdges.left;
    final hasRight = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.horizontal ||
        settings.axisDivisionEdges == AxisDivisionEdges.right;
    final xStart = hasLeft ? 0 : 1;
    final xEnd = hasRight ? xDivisions + 1 : xDivisions;
    for (var i = xStart; i < xEnd; i++) {
      canvas.drawLine(
        Offset(widthFraction * i, 0),
        Offset(widthFraction * i, size.height),
        style.gridStyle.xAxisPaint,
      );
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
        style.gridStyle.yAxisPaint,
      );

      /// skip paint of y axis labels if [showAxisYLabels] is set to `true`
      /// or
      /// force to skip last (beneath axis) division paint of axis label.
      if (!settings.showAxisYLabels || hasBottom && i == yEnd - 1) {
        continue;
      }

      final labelValue =
          roundedMaxValue * (yDivisions - i) / yDivisions - roundedMinValue;
      final textPainter = MDTextPainter(
        TextSpan(
          text: data.yAxisLabelBuilder(labelValue),
          style: style.axisStyle.yAxisLabelStyle,
        ),
      );

      if (settings.yAxisLayout == YAxisLayout.displace &&
          maxLabelWidth < textPainter.size.width) {
        maxLabelWidth = textPainter.size.width;
      }

      textPainter.paint(
        canvas,
        Offset(0, heightFraction * i + style.gridStyle.yAxisPaint.strokeWidth),
      );
    }

    onYAxisLabelSizeCalculated(maxLabelWidth);
  }

  /// Axis painter.
  void paintAxis(Canvas canvas, Size size) {
    if (!settings.showAxisX && !settings.showAxisY) {
      return;
    }

    final axisPaint = style.axisStyle.paint;

    const topLeft = Offset.zero;
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    // x axis
    if (settings.showAxisX) {
      if (data.hasNegativeMinValue) {
        final y =
            normalizeInverted(roundedMinValue, roundedMaxValue) * size.height;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), axisPaint);
      } else {
        canvas.drawLine(bottomLeft, bottomRight, axisPaint);
      }
    }
    // y axis
    if (settings.showAxisY) {
      canvas.drawLine(topLeft, bottomLeft, axisPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintAxis(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GridAxisPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

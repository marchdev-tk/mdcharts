// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

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
      cache != oldDelegate.cache ||
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// Drop line painter.
void paintDropLine(
  Canvas canvas,
  Size size,
  GridAxisData data,
  DropLineStyle dropLineStyle,
  double zeroHeight,
  Offset point,
) {
  if (!data.canDraw) {
    return;
  }

  final dashWidth = dropLineStyle.dashSize;
  final gapWidth = dropLineStyle.gapSize;

  final pathX = Path();
  final pathY = Path();

  pathX.moveTo(0, point.dy);
  pathY.moveTo(point.dx, zeroHeight);
  // ! uncomment if needed
  // pathY.moveTo(point.dx, size.height);

  final countX = (point.dx / (dashWidth + gapWidth)).round();
  for (var i = 1; i <= countX; i++) {
    pathX.relativeLineTo(dashWidth, 0);
    pathX.relativeMoveTo(gapWidth, 0);
  }

  final isNegativeValue = point.dy > zeroHeight;
  final countY =
      ((zeroHeight - point.dy) / (dashWidth + gapWidth)).round().abs();
  for (var i = 1; i <= countY; i++) {
    pathY.relativeLineTo(0, isNegativeValue ? dashWidth : -dashWidth);
    pathY.relativeMoveTo(0, isNegativeValue ? gapWidth : -gapWidth);
  }
  // ! uncomment if needed
  // final countY =
  //     ((size.height - point.dy) / (dashWidth + gapWidth)).round().abs();
  // for (var i = 1; i <= countY; i++) {
  //   pathY.relativeLineTo(0, -dashWidth);
  //   pathY.relativeMoveTo(0, -gapWidth);
  // }

  canvas.drawPath(pathX, dropLineStyle.paint);
  canvas.drawPath(pathY, dropLineStyle.paint);
}

/// Tooltip painter.
void paintTooltip<T>(
  Canvas canvas,
  Size size,
  GridAxisData<T> data,
  TooltipStyle tooltipStyle,
  MapEntry<DateTime, T> entry,
  Offset point,
) {
  if (!data.canDraw) {
    return;
  }

  final titlePainter = MDTextPainter(TextSpan(
    text: data.titleBuilder(entry.key, entry.value),
    style: tooltipStyle.titleStyle,
  ));
  final subtitlePainter = MDTextPainter(TextSpan(
    text: data.subtitleBuilder(entry.key, entry.value),
    style: tooltipStyle.subtitleStyle,
  ));
  final triangleWidth = tooltipStyle.triangleWidth;
  final triangleHeight = tooltipStyle.triangleHeight;
  final bottomMargin = tooltipStyle.bottomMargin + triangleHeight;
  final titleSize = titlePainter.size;
  final subtitleSize = subtitlePainter.size;
  final spacing = tooltipStyle.spacing;
  final padding = tooltipStyle.padding;
  final contentWidth = math.max(titleSize.width, subtitleSize.width);
  final tooltipSize = Size(
    contentWidth + padding.horizontal,
    titleSize.height + spacing + subtitleSize.height + padding.vertical,
  );
  final radius = Radius.circular(tooltipStyle.radius);
  final isSelectedIndexFirst = point.dx - tooltipSize.width / 2 < 0;
  final isSelectedIndexLast = point.dx + tooltipSize.width / 2 > size.width;
  final xBias = isSelectedIndexFirst
      ? tooltipSize.width / 2 - triangleWidth / 2 - radius.x
      : isSelectedIndexLast
          ? -tooltipSize.width / 2 + triangleWidth / 2 + radius.x
          : 0;
  final titleOffset = Offset(
    point.dx - titleSize.width / 2 + xBias,
    point.dy -
        bottomMargin -
        padding.bottom -
        subtitleSize.height -
        spacing -
        titleSize.height,
  );
  final subtitleOffset = Offset(
    point.dx - subtitleSize.width / 2 + xBias,
    point.dy - bottomMargin - padding.bottom - subtitleSize.height,
  );
  final rrect = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: Offset(
        point.dx + xBias,
        point.dy - bottomMargin - tooltipSize.height / 2,
      ),
      width: tooltipSize.width,
      height: tooltipSize.height,
    ),
    radius,
  );

  final path = Path();
  path.moveTo(point.dx, point.dy - bottomMargin + triangleHeight);
  path.relativeLineTo(-triangleWidth / 2, -triangleHeight);
  path.relativeLineTo(triangleWidth, 0);
  path.relativeLineTo(-triangleWidth / 2, triangleHeight);
  path.close();
  path.addRRect(rrect);

  canvas.drawShadow(
    path,
    tooltipStyle.shadowColor,
    tooltipStyle.shadowElevation,
    false,
  );
  canvas.drawPath(path, tooltipStyle.paint);

  titlePainter.paint(canvas, titleOffset);
  subtitlePainter.paint(canvas, subtitleOffset);
}

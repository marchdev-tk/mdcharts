// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

import '../utils.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [LineChart].
class LineChartPainter extends CustomPainter {
  /// Constructs an instance of [LineChartPainter].
  const LineChartPainter(
    this.data,
    this.style,
    this.settings,
  );

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Normalization method.
  ///
  /// Converts provided [value] based on [data.maxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value) {
    final max = data.maxValue;
    return 1 - value / max;
  }

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.xAxisDivisions == 0 && settings.yAxisDivisions == 0) {
      return;
    }

    final gridPaint = style.gridStyle.paint;

    final xDivisions = settings.xAxisDivisions + 1;
    final widthFraction = size.width / xDivisions;
    for (var i = 1; i < xDivisions; i++) {
      canvas.drawLine(
        Offset(widthFraction * i, 0),
        Offset(widthFraction * i, size.height),
        gridPaint,
      );
    }

    final yDivisions = settings.yAxisDivisions + 1;
    final heightFraction = size.height / yDivisions;
    for (var i = 1; i < yDivisions; i++) {
      canvas.drawLine(
        Offset(0, heightFraction * i),
        Offset(size.width, heightFraction * i),
        gridPaint,
      );
    }
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
      canvas.drawLine(bottomLeft, bottomRight, axisPaint);
    }
    // y axis
    if (settings.showAxisY) {
      canvas.drawLine(topLeft, bottomLeft, axisPaint);
    }
  }

  /// Line painter.
  void paintChartLine(Canvas canvas, Size size) {
    final map = data.typedData;
    final widthFraction = size.width / data.xAxisDivisions;
    final path = Path();

    final isDescending = data.dataType == LineChartDataType.unidirectional &&
        data.dataDirection == LineChartDataDirection.descending;

    if (!isDescending) {
      path.moveTo(0, size.height);
    }

    double firstY = 0;
    double x = 0;
    double y = 0;
    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;

      x = widthFraction * i;
      y = normalize(value) * size.height;

      if (i == 0) {
        firstY = y;
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      if (i == map.length - 1) {
        path.moveTo(x, y);
      }
    }

    if (settings.lineFilling) {
      final gradientPath = Path.from(path);

      // finishing path to create valid gradient/color fill
      gradientPath.lineTo(x, size.height);
      gradientPath.lineTo(0, size.height);
      gradientPath.lineTo(0, firstY);

      canvas.drawPath(
        gradientPath,
        style.lineStyle.getFillPaint(gradientPath.getBounds()),
      );
    }

    if (settings.altitudeLine) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, size.height),
        style.lineStyle.altitudeLinePaint,
      );
    }

    if (settings.lineShadow) {
      final shadowPath = path.shift(const Offset(0, 2));
      canvas.drawPath(shadowPath, style.lineStyle.shadowPaint);
    }

    canvas.drawPath(path, style.lineStyle.linePaint);
  }

  /// Limit line painter.
  void paintChartLimitLine(Canvas canvas, Size size) {
    if (data.limit == null) {
      return;
    }

    final path = Path();
    final y = normalize(data.limit!) * size.height;

    path.moveTo(0, y);

    final dashWidth = style.limitStyle.dashSize;
    final gapWidth = style.limitStyle.gapSize;
    final count = (size.width / (dashWidth + gapWidth)).round();
    for (var i = 1; i <= count; i++) {
      path.relativeLineTo(dashWidth, 0);
      path.relativeMoveTo(gapWidth, 0);
    }

    canvas.drawPath(path, style.limitStyle.linePaint);
  }

  /// Limit label painter.
  void paintChartLimitLabel(Canvas canvas, Size size) {
    if (data.limit == null) {
      return;
    }

    final yCenter = normalize(data.limit!) * size.height;
    final textSpan = TextSpan(
      text: data.limitText ?? data.limit.toString(),
      style: data.limitOverused
          ? style.limitStyle.labelOveruseStyle
          : style.limitStyle.labelStyle,
    );
    final textPainter = MDTextPainter(textSpan);
    final textSize = textPainter.size;
    final textPaddings = style.limitStyle.labelTextPadding;
    final textOffset = Offset(textPaddings.left, yCenter - textSize.height / 2);
    final labelHeight = textPaddings.vertical + textSize.height;
    final labelRadius = labelHeight / 2;

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        yCenter - labelHeight / 2,
        textPaddings.horizontal + textSize.width,
        yCenter + labelHeight / 2,
        topRight: Radius.circular(labelRadius),
        bottomRight: Radius.circular(labelRadius),
      ),
      style.limitStyle.labelPaint,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintAxis(canvas, size);
    paintChartLine(canvas, size);
    paintChartLimitLine(canvas, size);
    paintChartLimitLabel(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

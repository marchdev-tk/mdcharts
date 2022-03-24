// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flinq/flinq.dart';

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
    this.selectedXPosition,
  );

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Selected position on the X axis.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final double? selectedXPosition;

  /// Normalization method.
  ///
  /// Converts provided [value] based on [maxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value) {
    return 1 - value / data.maxValue;
  }

  bool get _isDescendingChart =>
      data.dataType == LineChartDataType.unidirectional &&
      data.dataDirection == LineChartDataDirection.descending;

  int? _getSelectedIndex(Size size) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, data.typedData.length - 1);

    return index;
  }

  Offset _getPoint(Size size, [int? precalculatedSelectedIndex]) {
    final selectedIndex = precalculatedSelectedIndex ?? _getSelectedIndex(size);
    final index = selectedIndex ?? data.lastDivisionIndex;
    final entry = selectedIndex == null
        ? data.data.entries.last
        : data.typedData.entries.elementAt(index);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * index;
    final y = normalize(entry.value) * size.height;
    final point = Offset(x, y);

    return point;
  }

  bool get _showDetails => selectedXPosition != null;

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
    final selectedIndex = _getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;
    final map = data.typedData;
    final path = Path();

    Path? pathSelected;

    if (!_isDescendingChart) {
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

      if (selectedXPosition != null && selectedIndex! == i) {
        pathSelected = Path.from(path);
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

    if (pathSelected != null) {
      canvas.drawPath(path, style.lineStyle.lineInactivePaint);
      canvas.drawPath(pathSelected, style.lineStyle.linePaint);
    } else {
      canvas.drawPath(path, style.lineStyle.linePaint);
    }
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

  /// Drop line painter.
  void paintDropLine(Canvas canvas, Size size) {
    if (!_showDetails) {
      return;
    }

    final point = _getPoint(size);
    final dashWidth = style.pointStyle.dropLineDashSize;
    final gapWidth = style.pointStyle.dropLineGapSize;

    final pathX = Path();
    final pathY = Path();

    pathX.moveTo(0, point.dy);
    pathY.moveTo(point.dx, size.height);

    final countX = (point.dx / (dashWidth + gapWidth)).round();
    for (var i = 1; i <= countX; i++) {
      pathX.relativeLineTo(dashWidth, 0);
      pathX.relativeMoveTo(gapWidth, 0);
    }

    final countY = ((size.height - point.dy) / (dashWidth + gapWidth)).round();
    for (var i = 1; i <= countY; i++) {
      pathY.relativeLineTo(0, -dashWidth);
      pathY.relativeMoveTo(0, -gapWidth);
    }

    canvas.drawPath(pathX, style.pointStyle.dropLinePaint);
    canvas.drawPath(pathY, style.pointStyle.dropLinePaint);
  }

  /// Point painter.
  void paintPoint(Canvas canvas, Size size) {
    final point = _getPoint(size);

    canvas.drawCircle(
      point + style.pointStyle.shadowOffset,
      style.pointStyle.outerSize / 2,
      style.pointStyle.shadowPaint,
    );
    canvas.drawCircle(
      point,
      style.pointStyle.outerSize / 2,
      style.pointStyle.outerPaint,
    );
    canvas.drawCircle(
      point,
      style.pointStyle.innerSize / 2,
      style.pointStyle.innerPaint,
    );
  }

  /// Tooltip painter.
  void paintTooltip(Canvas canvas, Size size) {
    if (!_showDetails) {
      return;
    }

    const triangleWidth = 12.0;
    const triangleHeight = 5.0;

    final selectedIndex = _getSelectedIndex(size)!;
    final entry = data.typedData.entries.elementAt(selectedIndex);
    final titlePainter = MDTextPainter(TextSpan(
      text: data.titleBuilder(entry.key, entry.value),
      style: style.pointStyle.tooltipTitleStyle,
    ));
    final subtitlePainter = MDTextPainter(TextSpan(
      text: data.subtitleBuilder(entry.key, entry.value),
      style: style.pointStyle.tooltipSubtitleStyle,
    ));
    final point = _getPoint(size, selectedIndex);
    final outerRadius = style.pointStyle.outerSize / 2;
    final bottomMargin =
        style.pointStyle.tooltopBottomMargin + outerRadius + triangleHeight;
    final titleSize = titlePainter.size;
    final subtitleSize = subtitlePainter.size;
    final spacing = style.pointStyle.tooltipSpacing;
    final padding = style.pointStyle.tooltipPadding;
    final contentWidth = math.max(titleSize.width, subtitleSize.width);
    final tooltipSize = Size(
      contentWidth + padding.horizontal,
      titleSize.height + spacing + subtitleSize.height + padding.vertical,
    );
    final isSelectedIndexFirst = point.dx - tooltipSize.width / 2 < 0;
    final isSelectedIndexLast = point.dx + tooltipSize.width / 2 > size.width;
    final xBias = isSelectedIndexFirst
        ? tooltipSize.width / 2 - triangleWidth / 2
        : isSelectedIndexLast
            ? -tooltipSize.width / 2 + triangleWidth / 2
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
    const radius = Radius.circular(8);
    final rrect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(
          point.dx + xBias,
          point.dy - bottomMargin - tooltipSize.height / 2,
        ),
        width: tooltipSize.width,
        height: tooltipSize.height,
      ),
      topLeft: radius,
      topRight: radius,
      bottomLeft: isSelectedIndexFirst ? Radius.zero : radius,
      bottomRight: isSelectedIndexLast ? Radius.zero : radius,
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
      style.pointStyle.tooltipShadowColor,
      style.pointStyle.tooltipShadowElevation,
      false,
    );
    canvas.drawPath(path, style.pointStyle.tooltipPaint);

    titlePainter.paint(canvas, titleOffset);
    subtitlePainter.paint(canvas, subtitleOffset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintAxis(canvas, size);
    paintChartLine(canvas, size);
    paintChartLimitLine(canvas, size);
    paintChartLimitLabel(canvas, size);
    paintDropLine(canvas, size);
    paintPoint(canvas, size);
    paintTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      selectedXPosition != oldDelegate.selectedXPosition;
}

/// X axis label painter of the [LineChart].
class LineChartXAxisLabelPainter extends CustomPainter {
  /// Constructs an instance of [LineChartPainter].
  const LineChartXAxisLabelPainter(
    this.data,
    this.style,
  );

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the chart axis.
  final LineChartAxisStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final map = data.xAxisDates;
    final painters = <MDTextPainter>[];

    for (var i = 0; i < map.length; i++) {
      final item = map[i];
      final text = data.xAxisLabelBuilder(item);
      final painter = MDTextPainter(TextSpan(
        text: text,
        style: style.labelStyle,
      ));
      painters.add(painter);
    }

    double totalWidth = 0;
    while (true) {
      final gapCount = painters.length - 1;
      totalWidth =
          painters.map((painter) => painter.size.width).sum.toDouble() +
              gapCount * style.labelSpacing;

      if (totalWidth > size.width) {
        final isEven = painters.length % 2 == 0;

        if (isEven) {
          painters.removeAt(painters.length ~/ 2);
        }

        for (var i = painters.length - 2; i > 0; i -= 2) {
          painters.removeAt(i);
        }
      } else {
        break;
      }
    }

    final gapWidth =
        (size.width - totalWidth) / (painters.length - 1) + style.labelSpacing;

    for (var i = 0, dx = .0; i < painters.length; i++) {
      final painter = painters[i];

      painter.paint(
        canvas,
        Offset(dx, 0),
      );

      dx += painter.size.width;
      if (i < painters.length - 1) {
        dx += gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

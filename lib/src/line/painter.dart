// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';

import '../common.dart';
import '../utils.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [LineChart].
class LineChartPainter extends CustomPainter {
  /// Constructs an instance of [LineChartPainter].
  LineChartPainter(
    this.data,
    this.style,
    this.settings,
    this.padding,
    this.selectedXPosition,
  );

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Padding around the chart.
  ///
  /// If not set, will be used default one:
  /// - left/right/bottom: `0`;
  /// - top: dynamic value that depends on the style of the tooltip, more info
  /// at [LineChartPointStyle.tooltipHeight].
  final EdgeInsets? padding;

  /// Selected position on the X axis.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final double? selectedXPosition;

  /// Cached value of [data.typedData].
  ///
  /// It is needed to store this cache due to lots of calculations that
  /// "low-end" devices couldn't complete fast enough (escpecially on mobile
  /// devices).
  Map<DateTime, double>? _cachedTypedData;

  /// Cached value of [roundedDivisionSize].
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation.
  double? _cachedRoundedDivisionSize;

  /// Smart getter of the [data.typedData].
  ///
  /// If there's cache - it will be used instead of basic [data.typedData].
  Map<DateTime, double> get _typedData {
    if (_cachedTypedData != null) {
      return _cachedTypedData!;
    }

    final typedData = data.typedData;
    _cachedTypedData = typedData;

    return typedData;
  }

  /// Rounding method that calculates and rounds Y axis division size.
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedDivisionSize {
    if (_cachedRoundedDivisionSize != null) {
      return _cachedRoundedDivisionSize!;
    }

    final yDivisions = settings.yAxisDivisions + 1;
    double divisionSize;

    if (yDivisions == 1) {
      divisionSize = data.totalValue;
    } else if (yDivisions == 2 && data.maxValue == 0) {
      divisionSize = data.minValue.abs() / 2;
    } else if (yDivisions == 2) {
      divisionSize = math.max(data.maxValue, data.minValue.abs());
    } else if (data.minValue == 0 || data.maxValue == 0) {
      divisionSize = data.totalValue / yDivisions;
    } else {
      var size = data.totalValue / yDivisions;
      var maxDivisions = (data.maxValue / size).ceil();
      var minDivisions = (data.minValue.abs() / size).ceil();

      // TODO: find a better way to calculate size of the division.
      while (maxDivisions + minDivisions > yDivisions) {
        size = size + 1;
        maxDivisions = (data.maxValue / size).ceil();
        minDivisions = (data.minValue.abs() / size).ceil();
      }

      divisionSize = size;
    }

    final roundedSize =
        getRoundedMaxValue(data.maxValueRoundingMap, divisionSize, 1);
    _cachedRoundedDivisionSize = roundedSize;

    return roundedSize;
  }

  /// Rounding method that rounds [data.minValue] to achieve beautified value
  /// so, it could be multiplied by [settings.yAxisDivisions].
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedMinValue {
    if (data.hasNegativeMinValue) {
      final size = roundedDivisionSize;
      final divisions = (data.minValue.abs() / size).ceil();
      return size * divisions;
    }

    return 0;
  }

  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with beautified integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  double get roundedMaxValue {
    if (data.hasNegativeMinValue) {
      final yDivisions = settings.yAxisDivisions + 1;
      return roundedDivisionSize * yDivisions;
    }

    return getRoundedMaxValue(
      data.maxValueRoundingMap,
      data.maxValue,
      settings.yAxisDivisions,
    );
  }

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

  bool get _isDescendingChart =>
      data.dataType == LineChartDataType.unidirectional &&
      data.dataDirection == LineChartDataDirection.descending;

  int? _getSelectedIndex(Size size) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, _typedData.length - 1);

    return index;
  }

  /// Height of the X axis.
  double _getZeroHeight(Size size) => data.hasNegativeMinValue
      ? normalize(roundedMinValue) * size.height
      : size.height;

  Offset _getPoint(Size size, [int? precalculatedSelectedIndex]) {
    if (!data.canDraw) {
      return Offset(0, size.height);
    }

    final selectedIndex = precalculatedSelectedIndex ?? _getSelectedIndex(size);
    final index = selectedIndex ?? data.lastDivisionIndex;
    final entry = selectedIndex == null
        ? data.data.entries.last
        : _typedData.entries.elementAt(index);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * index;
    final y = normalize(entry.value + roundedMinValue) * size.height;
    final point = Offset(x, y);

    return point;
  }

  bool get _showDetails => selectedXPosition != null;

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.xAxisDivisions == 0 && settings.yAxisDivisions == 0) {
      return;
    }

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

      textPainter.paint(
        canvas,
        Offset(0, heightFraction * i + style.gridStyle.yAxisPaint.strokeWidth),
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
      if (data.hasNegativeMinValue) {
        final y = normalize(roundedMinValue) * size.height;
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

  /// Line painter.
  void paintChartLine(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;
    final map = _typedData;
    final zeroHeight = _getZeroHeight(size);
    final path = Path();

    Path? pathSelected;

    if (!_isDescendingChart) {
      path.moveTo(0, zeroHeight);
    }

    double x = 0;
    double y = 0;
    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;

      x = widthFraction * i;
      y = normalize(value + roundedMinValue) * size.height;

      path.lineTo(x, y);

      if (i == map.length - 1) {
        path.moveTo(x, y);
      }

      if (selectedXPosition != null && selectedIndex! == i) {
        pathSelected = Path.from(path);
      }
    }

    if (settings.lineFilling) {
      final firstY = _isDescendingChart ? 0 : zeroHeight;
      final dy = style.lineStyle.stroke / 2;
      final gradientPath = path.shift(Offset(0, -dy));

      // finishing path to create valid gradient/color fill
      gradientPath.lineTo(x, zeroHeight);
      gradientPath.lineTo(0, zeroHeight);
      gradientPath.lineTo(0, firstY - dy);

      canvas.drawPath(
        gradientPath,
        style.lineStyle.getFillPaint(gradientPath.getBounds()),
      );
    }

    if (settings.altitudeLine) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, _getZeroHeight(size)),
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
    final y = normalize(data.limit!) * _getZeroHeight(size);

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

    final snapBias =
        settings.limitLabelSnapPosition == LimitLabelSnapPosition.chartBoundary
            ? (padding?.left ?? style.pointStyle.tooltipHorizontalOverflowWidth)
            : .0;
    final yCenter = normalize(data.limit!) * _getZeroHeight(size);
    final textSpan = TextSpan(
      text: data.limitText ?? data.limit.toString(),
      style: data.limitOverused
          ? style.limitStyle.labelOveruseStyle
          : style.limitStyle.labelStyle,
    );
    final textPainter = MDTextPainter(textSpan);
    final textSize = textPainter.size;
    final textPaddings = style.limitStyle.labelTextPadding;
    final textOffset =
        Offset(textPaddings.left - snapBias, yCenter - textSize.height / 2);
    final labelHeight = textPaddings.vertical + textSize.height;
    final labelRadius = labelHeight / 2;

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        -snapBias,
        yCenter - labelHeight / 2,
        textPaddings.horizontal + textSize.width - snapBias,
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
    if (!data.canDraw || !_showDetails) {
      return;
    }

    final zeroHeight = _getZeroHeight(size);
    final point = _getPoint(size);
    final dashWidth = style.pointStyle.dropLineDashSize;
    final gapWidth = style.pointStyle.dropLineGapSize;

    final pathX = Path();
    final pathY = Path();

    pathX.moveTo(0, point.dy);
    pathY.moveTo(point.dx, zeroHeight);

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

    canvas.drawPath(pathX, style.pointStyle.dropLinePaint);
    canvas.drawPath(pathY, style.pointStyle.dropLinePaint);
  }

  /// Point painter.
  void paintPoint(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

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
    if (!data.canDraw || !_showDetails) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size)!;
    final entry = _typedData.entries.elementAt(selectedIndex);
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
    final triangleWidth = style.pointStyle.tooltipTriangleWidth;
    final triangleHeight = style.pointStyle.tooltipTriangleHeight;
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
    final radius = Radius.circular(style.pointStyle.tooltipRadius);
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
    this.settings,
  );

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the chart axis.
  final LineChartAxisStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Unlimited X axis labels painter.
  void paintUnlimited(Canvas canvas, Size size) {
    final dates = data.xAxisDates;
    final painters = <MDTextPainter, bool>{};

    for (var i = 0; i < dates.length; i++) {
      final item = dates[i];
      final text = data.xAxisLabelBuilder(item);
      final painter = MDTextPainter(TextSpan(
        text: text,
        style: style.xAxisLabelStyle,
      ));
      painters[painter] = true;
    }

    double totalWidth = 0;
    while (true) {
      final visiblePainters =
          painters.entries.where((painter) => painter.value);
      final gapCount = visiblePainters.length - 1;
      totalWidth = visiblePainters
              .map((painter) => painter.key.size.width)
              .sum
              .toDouble() +
          gapCount * style.xAxisLabelSpacing;

      if (totalWidth > size.width && visiblePainters.length > 3) {
        for (var i = 1; i < visiblePainters.length / 2; i++) {
          final left = visiblePainters.elementAt(i).key;
          final right =
              visiblePainters.elementAt(visiblePainters.length - 1 - i).key;

          painters[left] = false;
          painters[right] = false;
        }

        if (painters.length % 2 == 0) {
          final left = painters.entries.elementAt(painters.length ~/ 2 - 1);
          final right = painters.entries.elementAt(painters.length ~/ 2);

          if (visiblePainters.length > 4) {
            if (left.value && right.value) {
              painters[right.key] = false;
            } else if (!left.value && !right.value) {
              painters[right.key] = true;
            }
          }
        } else {
          final left = painters.entries.elementAt(painters.length ~/ 2 - 1);
          final center = painters.entries.elementAt(painters.length ~/ 2);
          final right = painters.entries.elementAt(painters.length ~/ 2 + 1);

          painters[center.key] = !left.value && !right.value;
        }
      } else {
        break;
      }
    }

    final widthFactor = size.width / data.xAxisDivisions;

    for (var i = 0; i < painters.length; i++) {
      final painter = painters.entries.elementAt(i);

      if (painter.value) {
        final dxBias = i == 0
            ? 0
            : i == painters.length - 1
                ? -painter.key.size.width
                : -painter.key.size.width / 2;
        final dx = widthFactor * i + dxBias;

        painter.key.paint(
          canvas,
          Offset(dx, 0),
        );
      }
    }
  }

  /// Limited X axis labels painter.
  void paintLimited(Canvas canvas, Size size) {
    final dates = data.xAxisDates;
    final count = math.min(settings.xAxisLabelQuantity!, dates.length);
    var innerCount = math.max(count - 2, 0);

    final datesToPaint = <DateTime>[
      dates.first,
      dates.last,
    ];

    while (innerCount > 0) {
      final datesLength = dates.length - 2;
      final step = (datesLength / (innerCount + 1)).round();
      final innerDatesToPaint = <DateTime>[];

      for (var i = 1; i <= innerCount / 2; i++) {
        final stepDuration = Duration(days: step * i);
        innerDatesToPaint.add(datesToPaint.first.add(stepDuration));
        innerDatesToPaint.add(datesToPaint.last.subtract(stepDuration));
      }
      if (innerCount % 2 == 1) {
        final centralDay = dates.length ~/ 2;
        innerDatesToPaint.insert(
          innerDatesToPaint.length ~/ 2,
          datesToPaint.first.add(Duration(days: centralDay)),
        );
      }

      final localDatesToPaint = List.of(datesToPaint);
      localDatesToPaint.insertAll(1, innerDatesToPaint);

      double totalWidth = .0;
      for (var i = 0; i < localDatesToPaint.length; i++) {
        final item = localDatesToPaint[i];
        final text = data.xAxisLabelBuilder(item);
        final painter = MDTextPainter(TextSpan(
          text: text,
          style: style.xAxisLabelStyle,
        ));
        totalWidth += painter.size.width;
      }

      if (totalWidth <= size.width) {
        datesToPaint.insertAll(1, innerDatesToPaint);
        break;
      }

      innerCount = innerCount - 1;
    }

    for (var i = 0; i < datesToPaint.length; i++) {
      final item = datesToPaint[i];
      final text = data.xAxisLabelBuilder(item);
      final painter = MDTextPainter(TextSpan(
        text: text,
        style: style.xAxisLabelStyle,
      ));

      double dx;
      if (i == 0) {
        dx = 0;
      } else if (i == datesToPaint.length - 1) {
        dx = size.width - painter.size.width;
      } else {
        final widthFactor = size.width / data.xAxisDivisions;
        final index = dates.indexOf(datesToPaint[i]);
        dx = widthFactor * index - painter.size.width / 2;
      }

      painter.paint(
        canvas,
        Offset(dx, 0),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.gridType == LineChartGridType.undefined && !data.canDraw) {
      return;
    }

    if (settings.xAxisLabelQuantity == null) {
      paintUnlimited(canvas, size);
    } else {
      paintLimited(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartXAxisLabelPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

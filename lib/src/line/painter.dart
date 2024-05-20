// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

import 'cache.dart';

/// Main painter of the [LineChart].
class LineChartPainter extends CustomPainter {
  /// Constructs an instance of [LineChartPainter].
  LineChartPainter(
    this.cache,
    this.data,
    this.style,
    this.settings,
    this.oldDataHashCode,
    this.padding,
    this.selectedXPosition,
    this.valueCoef,
  );

  /// Cache holder of the LineChart data that requries heavy computing.
  final LineChartCacheHolder cache;

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Hash code of the `old data` to perform animation of the chart.
  final int oldDataHashCode;

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

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

  /// Smart getter of the [data.typedData].
  ///
  /// If there's cache - it will be used instead of basic [data.typedData].
  Map<DateTime, double> get _typedData {
    final cachedTypedData = cache.getTypedData(data.hashCode);
    if (cachedTypedData != null) {
      return cachedTypedData;
    }

    final typedData = data.typedData;
    cache.saveTypedData(data.hashCode, typedData);

    return typedData;
  }

  /// {@macro GridAxisUtils.getRoundedDivisionSize}
  double get roundedDivisionSize =>
      GridAxisUtils().getRoundedDivisionSize(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMinValue}
  double get roundedMinValue =>
      GridAxisUtils().getRoundedMinValue(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMaxValue}
  double get roundedMaxValue =>
      GridAxisUtils().getRoundedMaxValue(cache, data, settings);

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

  Map<DateTime, double> _adjustMap(
    Map<DateTime, double> sourceMap,
    Map<DateTime, double>? mapToAdjust,
  ) {
    Map<DateTime, double> adjustedMap;
    if (mapToAdjust != null) {
      adjustedMap = Map.of(mapToAdjust);
    } else {
      adjustedMap = {
        for (var i = 0; i < sourceMap.length; i++)
          sourceMap.keys.elementAt(i): 0,
      };
    }

    if (adjustedMap.length <= sourceMap.length) {
      adjustedMap = Map.fromEntries([
        ...adjustedMap.entries,
        for (var i = adjustedMap.length; i < sourceMap.length; i++)
          MapEntry(sourceMap.keys.elementAt(i), 0),
      ]);
    }

    return adjustedMap;
  }

  /// Height of the X axis.
  double _getZeroHeight(Size size) => data.hasNegativeMinValue
      ? normalizeInverted(roundedMinValue, roundedMaxValue) * size.height
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
    final y =
        normalizeInverted(entry.value + roundedMinValue, roundedMaxValue) *
            size.height;
    final point = Offset(x, y);

    if (!_showDetails) {
      cache.saveDefaultPointOffset(data.hashCode, point);
    }

    return point;
  }

  bool get _showDetails => selectedXPosition != null && settings.showTooltip;

  /// Line painter.
  void paintChartLine(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;
    final map = _typedData;
    final oldMap = _adjustMap(map, cache.getTypedData(oldDataHashCode));
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
      final oldValue = // TODO: figure out why it is needed (case: from 7 dots to 30 dots)
          i >= oldMap.entries.length ? 0 : oldMap.entries.elementAt(i).value;

      final normalizedOldY = normalizeInverted(
        oldValue + (cache.getRoundedMinValue(oldDataHashCode) ?? 0),
        cache.getRoundedMaxValue(oldDataHashCode) ?? 1,
      );
      final normalizedY =
          normalizeInverted(value + roundedMinValue, roundedMaxValue);
      final animatedY =
          normalizedOldY + (normalizedY - normalizedOldY) * valueCoef;

      x = widthFraction * i;
      y = animatedY * size.height;

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
    final y =
        normalizeInverted(data.limit!, roundedMaxValue) * _getZeroHeight(size);

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

    final snapBias = settings.limitLabelSnapPosition ==
            LimitLabelSnapPosition.chartBoundary
        ? (padding?.left ?? style.tooltipStyle.tooltipHorizontalOverflowWidth)
        : .0;
    final yCenter =
        normalizeInverted(data.limit!, roundedMaxValue) * _getZeroHeight(size);
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
    if (!data.canDraw || !settings.showPoint) {
      return;
    }

    var point = _getPoint(size);

    // if cannot show details (default point position) - animation is needed
    if (!_showDetails) {
      final oldPoint = cache.getDefaultPointOffset(oldDataHashCode) ??
          Offset(point.dx, size.height);
      final pointDiff = point - oldPoint;
      point =
          oldPoint + Offset(pointDiff.dx * valueCoef, pointDiff.dy * valueCoef);
    }

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
      style: style.tooltipStyle.titleStyle,
    ));
    final subtitlePainter = MDTextPainter(TextSpan(
      text: data.subtitleBuilder(entry.key, entry.value),
      style: style.tooltipStyle.subtitleStyle,
    ));
    final point = _getPoint(size, selectedIndex);
    final outerRadius = style.pointStyle.outerSize / 2;
    final triangleWidth = style.tooltipStyle.triangleWidth;
    final triangleHeight = style.tooltipStyle.triangleHeight;
    final bottomMargin =
        style.tooltipStyle.bottomMargin + outerRadius + triangleHeight;
    final titleSize = titlePainter.size;
    final subtitleSize = subtitlePainter.size;
    final spacing = style.tooltipStyle.spacing;
    final padding = style.tooltipStyle.padding;
    final contentWidth = math.max(titleSize.width, subtitleSize.width);
    final tooltipSize = Size(
      contentWidth + padding.horizontal,
      titleSize.height + spacing + subtitleSize.height + padding.vertical,
    );
    final radius = Radius.circular(style.tooltipStyle.radius);
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
      style.tooltipStyle.shadowColor,
      style.tooltipStyle.shadowElevation,
      false,
    );
    canvas.drawPath(path, style.tooltipStyle.tooltipPaint);

    titlePainter.paint(canvas, titleOffset);
    subtitlePainter.paint(canvas, subtitleOffset);
  }

  @override
  void paint(Canvas canvas, Size size) {
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
      oldDataHashCode != oldDelegate.oldDataHashCode ||
      selectedXPosition != oldDelegate.selectedXPosition ||
      valueCoef != oldDelegate.valueCoef;
}

/// X axis label painter of the [LineChart].
class LineChartXAxisLabelPainter extends CustomPainter {
  /// Constructs an instance of [LineChartPainter].
  const LineChartXAxisLabelPainter(
    this.cache,
    this.data,
    this.style,
    this.settings,
    this.selectedXPosition,
  );

  /// Cache holder of the LineChart data that requries heavy computing.
  final LineChartCacheHolder cache;

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the chart axis.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Selected position on the X axis.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final double? selectedXPosition;

  /// Smart getter of the [data.typedData].
  ///
  /// If there's cache - it will be used instead of basic [data.typedData].
  Map<DateTime, double> get _typedData {
    final cachedTypedData = cache.getTypedData(data.hashCode);
    if (cachedTypedData != null) {
      return cachedTypedData;
    }

    final typedData = data.typedData;
    cache.saveTypedData(data.hashCode, typedData);

    return typedData;
  }

  int? _getSelectedIndex(Size size) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, _typedData.length - 1);

    return index;
  }

  List<int> _getXAxisLabelIndexesToPaint(int? labelQuantity) {
    final length = data.xAxisDates.length;
    final labelStep = labelQuantity != null ? length / (labelQuantity - 1) : .0;
    final halfLabelQty = (labelQuantity ?? 0) ~/ 2;
    final labelQtyIsOdd = (labelQuantity ?? 0) % 2 == 1;
    final steps = [
      for (var i = 0; i < halfLabelQty; i++) ...[
        (i * labelStep).truncate(),
        (length - 1 - (i * labelStep).truncate()),
      ],
      if (labelQtyIsOdd) length ~/ 2,
    ]..sort();

    return steps;
  }

  void _paintLabel(
    Canvas canvas,
    Size size,
    int index,
    MapEntry<MDTextPainter, bool> painter,
    int length,
  ) {
    if (!painter.value) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;

    Offset point;
    if (index == 0) {
      point = Offset(widthFraction * index, 0);
    } else if (index == length - 1) {
      point = Offset(widthFraction * index - painter.key.size.width, 0);
    } else {
      point = Offset(widthFraction * index - painter.key.size.width / 2, 0);
    }

    if (index == selectedIndex && settings.showAxisXLabelSelection) {
      canvas.drawRRect(
        style.axisStyle.xAxisSelectedLabelBorderRadius.toRRect(
          Rect.fromLTWH(
            point.dx - style.axisStyle.xAxisLabelPadding.left,
            point.dy,
            painter.key.size.width +
                style.axisStyle.xAxisLabelPadding.horizontal,
            painter.key.size.height +
                style.axisStyle.xAxisLabelPadding.vertical,
          ),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..color = style.axisStyle.xAxisSelectedLabelBackgroundColor,
      );
    }
    painter.key.paint(
      canvas,
      point.translate(0, style.axisStyle.xAxisLabelPadding.top),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.gridType == LineChartGridType.undefined && !data.canDraw) {
      return;
    }

    final dates = data.xAxisDates;
    final steps = _getXAxisLabelIndexesToPaint(settings.xAxisLabelQuantity);
    final painters = <MDTextPainter, bool>{};
    final selectedIndex = _getSelectedIndex(size);

    MDTextPainter? selectedPainter;
    for (var i = 0; i < dates.length; i++) {
      final item = dates[i];
      final textStyle = i == selectedIndex && settings.showAxisXLabelSelection
          ? style.axisStyle.xAxisSelectedLabelStyle
          : style.axisStyle.xAxisLabelStyle;
      final text = data.xAxisLabelBuilder(item, textStyle);
      final painter = MDTextPainter(text);
      painters[painter] =
          settings.xAxisLabelQuantity == null ? true : steps.contains(i);
      if (i == selectedIndex) {
        selectedPainter = painter;
      }
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
          gapCount * style.axisStyle.xAxisLabelPadding.horizontal;

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

    for (var i = 0; i < painters.length; i++) {
      final painter = painters.entries.elementAt(i);

      if (i == selectedIndex && settings.showAxisXSelectedLabelIfConcealed) {
        continue;
      }

      _paintLabel(canvas, size, i, painter, dates.length);
    }

    if (selectedPainter != null && settings.showAxisXSelectedLabelIfConcealed) {
      final index = painters.keys.toList().indexOf(selectedPainter);

      _paintLabel(
        canvas,
        size,
        index,
        MapEntry(selectedPainter, true),
        dates.length,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LineChartXAxisLabelPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      selectedXPosition != oldDelegate.selectedXPosition;
}

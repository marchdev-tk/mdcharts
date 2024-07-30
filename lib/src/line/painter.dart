// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
    this.oldData,
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

  /// Set of required (and optional) `BUT OLD` data to perform an animtion of
  /// the chart.
  final LineChartData oldData;

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

  /// Normalization method.
  ///
  /// For more info refer to [GridAxisUtils.normalize].
  double normalize(double value) =>
      GridAxisUtils().normalize(value, cache, data, settings);

  /// Normalization method for old data.
  ///
  /// For more info refer to [GridAxisUtils.normalizeOld].
  double normalizeOld(double oldValue) => GridAxisUtils()
      .normalizeOld(oldValue, oldDataHashCode, cache, data, settings);

  /// Map adjustment method.
  ///
  /// For more info refer to [GridAxisUtils.adjustMap].
  Map<DateTime, double> adjustMap(
    Map<DateTime, double> sourceMap,
    Map<DateTime, double>? mapToAdjust,
  ) {
    return GridAxisUtils().adjustMap(
      sourceMap,
      mapToAdjust,
      .0,
    );
  }

  /// Height of the zero point on y axis.
  double _getZeroHeight(Size size) {
    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        data.hasNegativeMinValueZeroBased) {
      return normalize(0) * size.height;
    }

    if (settings.yAxisBaseline == YAxisBaseline.axis &&
        data.minValueAxisBased <= 0 &&
        data.maxValue >= 0) {
      return normalize(0) * size.height;
    }

    return size.height;
  }

  /// Retrieves data entry index.
  ///
  /// For more info refer to [GridAxisUtils.getSelectedIndex].
  int? getSelectedIndex(Size size) =>
      GridAxisUtils().getSelectedIndex(size, selectedXPosition, data);

  Offset _getPoint(Size size, [int? precalculatedSelectedIndex]) {
    if (!data.canDraw) {
      return Offset(0, size.height);
    }

    final selectedIndex = precalculatedSelectedIndex ?? getSelectedIndex(size);
    final index = selectedIndex ?? data.lastDivisionIndex;
    final entry = selectedIndex == null
        ? data.data.entries.last
        : _typedData.entries.elementAt(index);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * index;
    final y = normalize(entry.value) * size.height;
    final point = Offset(x, y);

    if (selectedXPosition == null) {
      cache.saveDefaultPointOffset(data.hashCode, point);
    }

    return point;
  }

  /// Line painter.
  void paintLine(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final selectedIndex = getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;
    final map = _typedData;
    final oldMap = adjustMap(map, cache.getTypedData(oldDataHashCode));
    final zeroHeight = _getZeroHeight(size);
    final path = Path();

    Path? pathSelected;

    double initialY = zeroHeight;
    double x = 0;
    double y = 0;
    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;
      final oldValue = oldMap.entries.elementAt(i).value;

      final normalizedOldY = normalizeOld(oldValue);
      final normalizedY = normalize(value);
      final animatedY =
          normalizedOldY + (normalizedY - normalizedOldY) * valueCoef;

      x = widthFraction * i;
      y = animatedY * size.height;

      if (i == 0) {
        if (!settings.startLineFromZero) {
          initialY = y;
        }
        path.moveTo(x, initialY);
      }

      path.lineTo(x, y);

      if (i == map.length - 1) {
        path.moveTo(x, y);
      }

      if (selectedXPosition != null && selectedIndex! == i) {
        pathSelected = Path.from(path);
      }
    }

    if (settings.lineFilling) {
      final dy = style.lineStyle.stroke / 2;
      final gradientPath = path.shift(Offset(0, -dy));

      // finishing path to create valid gradient/color fill
      if (data.isNegative) {
        gradientPath.lineTo(x, 0);
        gradientPath.lineTo(0, 0);
      } else {
        gradientPath.lineTo(x, size.height);
        gradientPath.lineTo(0, size.height);
      }
      gradientPath.lineTo(0, initialY - dy);

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
  void paintLimitLine(Canvas canvas, Size size) {
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
  void paintLimitLabel(Canvas canvas, Size size) {
    if (data.limit == null) {
      return;
    }

    final snapBias = settings.limitLabelSnapPosition ==
            LimitLabelSnapPosition.chartBoundary
        ? (padding?.left ?? style.tooltipStyle.tooltipHorizontalOverflowWidth)
        : .0;
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
    final showDropLine = selectedXPosition != null && settings.showDropLine;

    if (!data.canDraw || !showDropLine) {
      return;
    }

    final point = _getPoint(size);

    GridAxisPainter.paintDropLine(
      canvas,
      size,
      data,
      style.dropLineStyle,
      point,
    );
  }

  /// Point painter.
  void paintPoint(Canvas canvas, Size size) {
    if (!data.canDraw || !settings.showPoint) {
      return;
    }

    var point = _getPoint(size);

    // if there is no selected point (default point position) - animation is needed
    if (selectedXPosition == null) {
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
    final showTooltip = selectedXPosition != null && settings.showTooltip;

    if (!data.canDraw || !showTooltip) {
      return;
    }

    final selectedIndex = getSelectedIndex(size)!;
    final entry = _typedData.entries.elementAt(selectedIndex);
    final point = _getPoint(size, selectedIndex);

    GridAxisPainter.paintTooltip(
      canvas,
      size,
      data,
      style.tooltipStyle,
      entry,
      point,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintLine(canvas, size);
    paintLimitLine(canvas, size);
    paintLimitLabel(canvas, size);
    paintDropLine(canvas, size);
    paintPoint(canvas, size);
    paintTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) =>
      cache != oldDelegate.cache ||
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

  /// Retrieves data entry index.
  ///
  /// For more info refer to [GridAxisUtils.getSelectedIndex].
  int? getSelectedIndex(Size size) =>
      GridAxisUtils().getSelectedIndex(size, selectedXPosition, data);

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

    final selectedIndex = getSelectedIndex(size);
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
    final selectedIndex = getSelectedIndex(size);

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
      cache != oldDelegate.cache ||
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      selectedXPosition != oldDelegate.selectedXPosition;
}

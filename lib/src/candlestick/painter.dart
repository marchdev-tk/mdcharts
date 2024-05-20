// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';

import '../common.dart';
import '../utils.dart';
import 'cache.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [LineChart].
class CandlestickChartPainter extends CustomPainter {
  /// Constructs an instance of [CandlestickChartPainter].
  CandlestickChartPainter(
    this.data,
    this.style,
    this.settings,
    this.oldData,
    this.oldDataHashCode,
    this.padding,
    this.selectedXPosition,
    this.valueCoef,
  );

  /// Set of required (and optional) data to construct the line chart.
  final CandlestickChartData data;

  /// Provides various customizations for the line chart.
  final CandlestickChartStyle style;

  /// Provides various settings for the line chart.
  final CandlestickChartSettings settings;

  /// Set of required (and optional) `BUT OLD` data to perform an animtion of
  /// the chart.
  final CandlestickChartData oldData;

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

  /// Rounding method that calculates and rounds Y axis division size.
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedDivisionSize {
    final cachedRoundedSize = cache.getRoundedDivisionSize(data.hashCode);
    if (cachedRoundedSize != null) {
      return cachedRoundedSize;
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
    cache.saveRoundedDivisionSize(data.hashCode, roundedSize);

    return roundedSize;
  }

  /// Rounding method that rounds [data.minValue] to achieve beautified value
  /// so, it could be multiplied by [settings.yAxisDivisions].
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedMinValue {
    final cachedMinValue = cache.getRoundedMinValue(data.hashCode);
    if (cachedMinValue != null) {
      return cachedMinValue;
    }

    double minValue = 0;
    if (data.hasNegativeMinValue) {
      final size = roundedDivisionSize;
      final divisions = (data.minValue.abs() / size).ceil();
      minValue = size * divisions;
    }
    cache.saveRoundedMinValue(data.hashCode, minValue);

    return minValue;
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
    final cachedMaxValue = cache.getRoundedMaxValue(data.hashCode);
    if (cachedMaxValue != null) {
      return cachedMaxValue;
    }

    double maxValue;
    if (data.hasNegativeMinValue) {
      final yDivisions = settings.yAxisDivisions + 1;
      maxValue = roundedDivisionSize * yDivisions;
    } else {
      maxValue = getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );
    }
    cache.saveRoundedMaxValue(data.hashCode, maxValue);

    return maxValue;
  }

  /// Normalization method.
  ///
  /// Converts provided [value] based on [maxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value, double maxValue) {
    final normalizedValue = 1 - value / maxValue;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  // int? _getSelectedIndex(Size size) {
  //   if (selectedXPosition == null) {
  //     return null;
  //   }

  //   final widthFraction = size.width / data.lastDivisionIndex;

  //   int index = math.max((selectedXPosition! / widthFraction).round(), 0);
  //   index = math.min(index, _typedData.length - 1);

  //   return index;
  // }

  Map<DateTime, CandlestickData> _adjustMap(
    Map<DateTime, CandlestickData> sourceMap,
    Map<DateTime, CandlestickData>? mapToAdjust,
  ) {
    Map<DateTime, CandlestickData> adjustedMap;
    if (mapToAdjust != null) {
      adjustedMap = Map.of(mapToAdjust);
    } else {
      adjustedMap = {
        for (var i = 0; i < sourceMap.length; i++)
          sourceMap.keys.elementAt(i): const CandlestickData.zero(),
      };
    }

    if (adjustedMap.length <= sourceMap.length) {
      adjustedMap = Map.fromEntries([
        ...adjustedMap.entries,
        for (var i = adjustedMap.length; i < sourceMap.length; i++)
          MapEntry(sourceMap.keys.elementAt(i), const CandlestickData.zero()),
      ]);
    }

    return adjustedMap;
  }

  /// Height of the X axis.
  // double _getZeroHeight(Size size) => data.hasNegativeMinValue
  //     ? normalize(roundedMinValue, roundedMaxValue) * size.height
  //     : size.height;

  // bool get _showDetails => selectedXPosition != null && settings.showTooltip;

  /// Candlestick painter.
  void paintCandlesticks(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    double getYValue(double y, double oldY) {
      final normalizedOldY = normalize(
        oldY + (cache.getRoundedMinValue(oldDataHashCode) ?? 0),
        cache.getRoundedMaxValue(oldDataHashCode) ?? 1,
      );
      final normalizedY = normalize(y + roundedMinValue, roundedMaxValue);
      final animatedY =
          normalizedOldY + (normalizedY - normalizedOldY) * valueCoef;

      return animatedY;
    }

    // final selectedIndex = _getSelectedIndex(size);
    final widthFraction = size.width / data.lastDivisionIndex;
    final map = data.data;
    final oldMap = _adjustMap(data.data, oldData.data);
    // final zeroHeight = _getZeroHeight(size);

    double x = 0;
    double yLow = 0;
    double yHigh = 0;
    double yBid = 0;
    double yAsk = 0;
    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;
      final oldValue = // TODO: figure out why it is needed (case: from 7 dots to 30 dots)
          i >= oldMap.entries.length
              ? const CandlestickData.zero()
              : oldMap.entries.elementAt(i).value;

      x = widthFraction * i;
      yLow = getYValue(value.low, oldValue.low) * size.height;
      yHigh = getYValue(value.high, oldValue.high) * size.height;
      yBid = getYValue(value.bid, oldValue.bid) * size.height;
      yAsk = getYValue(value.ask, oldValue.ask) * size.height;

      final stickStyle = value.isAscending
          ? style.candleStickStyle.bullishStickPaint
          : style.candleStickStyle.bearishStickPaint;
      final candleStyle = value.isAscending
          ? style.candleStickStyle.bullishCandlePaint
          : style.candleStickStyle.bearishCandlePaint;

      canvas.drawLine(Offset(x, yLow), Offset(x, yHigh), stickStyle);
      canvas.drawLine(Offset(x, yBid), Offset(x, yAsk), candleStyle);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintCandlesticks(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CandlestickChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      oldDataHashCode != oldDelegate.oldDataHashCode ||
      selectedXPosition != oldDelegate.selectedXPosition ||
      valueCoef != oldDelegate.valueCoef;
}

/// Grid and Axis painter of the [CandlestickChart].
class CandlestickChartGridPainter extends CustomPainter {
  /// Constructs an instance of [CandlestickChartGridPainter].
  const CandlestickChartGridPainter(
    this.data,
    this.style,
    this.settings,
    this.onYAxisLabelSizeCalculated,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final CandlestickChartData data;

  /// Provides various customizations for the bar chart.
  final CandlestickChartStyle style;

  /// Provides various settings for the bar chart.
  final CandlestickChartSettings settings;

  /// Callback that notifies that Y axis label size successfuly calculated.
  final ValueChanged<double> onYAxisLabelSizeCalculated;

  /// Normalization method.
  ///
  /// Converts provided [value] based on [maxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value, double maxValue) {
    final normalizedValue = 1 - value / maxValue;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  /// Rounding method that calculates and rounds Y axis division size.
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedDivisionSize {
    final cachedRoundedSize = cache.getRoundedDivisionSize(data.hashCode);
    if (cachedRoundedSize != null) {
      return cachedRoundedSize;
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
    cache.saveRoundedDivisionSize(data.hashCode, roundedSize);

    return roundedSize;
  }

  /// Rounding method that rounds [data.minValue] to achieve beautified value
  /// so, it could be multiplied by [settings.yAxisDivisions].
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  double get roundedMinValue {
    final cachedMinValue = cache.getRoundedMinValue(data.hashCode);
    if (cachedMinValue != null) {
      return cachedMinValue;
    }

    double minValue = 0;
    if (data.hasNegativeMinValue) {
      final size = roundedDivisionSize;
      final divisions = (data.minValue.abs() / size).ceil();
      minValue = size * divisions;
    }
    cache.saveRoundedMinValue(data.hashCode, minValue);

    return minValue;
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
    final cachedMaxValue = cache.getRoundedMaxValue(data.hashCode);
    if (cachedMaxValue != null) {
      return cachedMaxValue;
    }

    double maxValue;
    if (data.hasNegativeMinValue) {
      final yDivisions = settings.yAxisDivisions + 1;
      maxValue = roundedDivisionSize * yDivisions;
    } else {
      maxValue = getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );
    }
    cache.saveRoundedMaxValue(data.hashCode, maxValue);

    return maxValue;
  }

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
        final y = normalize(roundedMinValue, roundedMaxValue) * size.height;
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
  bool shouldRepaint(covariant CandlestickChartGridPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// X axis label painter of the [CandlestickChart].
class CandlestickChartXAxisLabelPainter extends CustomPainter {
  /// Constructs an instance of [CandlestickChartPainter].
  const CandlestickChartXAxisLabelPainter(
    this.data,
    this.style,
    this.settings,
    this.selectedXPosition,
  );

  /// Set of required (and optional) data to construct the candlestick chart.
  final CandlestickChartData data;

  /// Provides various customizations for the candlestick axis.
  final CandlestickChartStyle style;

  /// Provides various settings for the candlestick chart.
  final CandlestickChartSettings settings;

  /// Selected position on the X axis.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final double? selectedXPosition;

  int? _getSelectedIndex(Size size) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.lastDivisionIndex;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, data.lastDivisionIndex);

    return index;
  }

  List<int> _getXAxisLabelIndexesToPaint(int? labelQuantity) {
    final length = data.data.length;
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
    final widthFraction = size.width / data.lastDivisionIndex;

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
    if (!data.canDraw) {
      return;
    }

    final dates = data.data.keys.toList();
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
  bool shouldRepaint(covariant CandlestickChartXAxisLabelPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      selectedXPosition != oldDelegate.selectedXPosition;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

/// Main painter of the [LineChart].
class CandlestickChartPainter extends CustomPainter {
  /// Constructs an instance of [CandlestickChartPainter].
  CandlestickChartPainter(
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

  /// Cache holder of the GridAxis data that requries heavy computing.
  final GridAxisCacheHolder cache;

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

  /// {@macro GridAxisUtils.getRoundedDivisionSize}
  double get roundedDivisionSize =>
      GridAxisUtils().getRoundedDivisionSize(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMinValue}
  double get roundedMinValue =>
      GridAxisUtils().getRoundedMinValue(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMaxValue}
  double get roundedMaxValue =>
      GridAxisUtils().getRoundedMaxValue(cache, data, settings);

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
  double _getZeroHeight(Size size) => data.hasNegativeMinValue
      ? normalizeInverted(roundedMinValue, roundedMaxValue) * size.height
      : size.height;

  int? _getSelectedIndex(Size size) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, data.xAxisDivisions);

    return index;
  }

  Offset _getPoint(Size size, int selectedIndex) {
    if (!data.canDraw) {
      return Offset(0, size.height);
    }

    final entry = data.data.entries.elementAt(selectedIndex);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * selectedIndex;
    final y =
        normalizeInverted(entry.value.high + roundedMinValue, roundedMaxValue) *
            size.height;
    final point = Offset(x, y);

    return point;
  }

  /// Drop line painter.
  void _paintDropLine(Canvas canvas, Size size) {
    final showDropLine = selectedXPosition != null && settings.showDropLine;

    if (!data.canDraw || !showDropLine) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size)!;
    final zeroHeight = _getZeroHeight(size);
    final point = _getPoint(size, selectedIndex);

    paintDropLine(
      canvas,
      size,
      data,
      style.dropLineStyle,
      zeroHeight,
      point,
    );
  }

  /// Candlestick painter.
  void paintCandlesticks(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    double getYValue(double y, double oldY) {
      final normalizedOldY = normalizeInverted(
        oldY + (cache.getRoundedMinValue(oldDataHashCode) ?? 0),
        cache.getRoundedMaxValue(oldDataHashCode) ?? 1,
      );
      final normalizedY =
          normalizeInverted(y + roundedMinValue, roundedMaxValue);
      final animatedY =
          normalizedOldY + (normalizedY - normalizedOldY) * valueCoef;

      return animatedY;
    }

    final widthFraction = size.width / data.xAxisDivisions;
    final map = data.data;
    final oldMap = _adjustMap(data.data, oldData.data);

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

  /// Tooltip painter.
  void _paintTooltip(Canvas canvas, Size size) {
    final showTooltip = selectedXPosition != null && settings.showTooltip;

    if (!data.canDraw || !showTooltip) {
      return;
    }

    final selectedIndex = _getSelectedIndex(size)!;
    final entry = data.data.entries.elementAt(selectedIndex);
    final point = _getPoint(size, selectedIndex);

    paintTooltip(
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
    _paintDropLine(canvas, size);
    paintCandlesticks(canvas, size);
    _paintTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CandlestickChartPainter oldDelegate) =>
      cache != oldDelegate.cache ||
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      oldDataHashCode != oldDelegate.oldDataHashCode ||
      selectedXPosition != oldDelegate.selectedXPosition ||
      valueCoef != oldDelegate.valueCoef;
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

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition! / widthFraction).round(), 0);
    index = math.min(index, data.xAxisDivisions);

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

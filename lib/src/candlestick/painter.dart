// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

/// Main painter of the [LineChart].
class CandlestickChartPainter extends CustomPainter {
  /// Constructs an instance of [CandlestickChartPainter].
  const CandlestickChartPainter(
    this.cache,
    this.data,
    this.style,
    this.settings,
    this.oldData,
    this.oldDataHashCode,
    this.selectedPosition,
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

  /// Selected position.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X and Y axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final Offset? selectedPosition;

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

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
  Map<DateTime, CandlestickData> adjustMap(
    Map<DateTime, CandlestickData> sourceMap,
    Map<DateTime, CandlestickData>? mapToAdjust,
  ) {
    return GridAxisUtils().adjustMap(
      sourceMap,
      mapToAdjust,
      const CandlestickData.zero(),
    );
  }

  /// Retrieves data entry index.
  ///
  /// For more info refer to [GridAxisUtils.getSelectedIndex].
  int? getSelectedIndex(Size size) =>
      GridAxisUtils().getSelectedIndex(size, selectedPosition?.dx, data);

  ({Offset point, double value}) _getPointData(Size size, int selectedIndex) {
    var pointValue = double.nan;

    if (!data.canDraw) {
      return (point: Offset(0, size.height), value: pointValue);
    }

    final entry = data.data.entries.elementAt(selectedIndex);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * selectedIndex;
    final yLow = normalize(entry.value.low) * size.height;
    final yHigh = normalize(entry.value.high) * size.height;
    final yBid = normalize(entry.value.bid) * size.height;
    final yAsk = normalize(entry.value.ask) * size.height;
    final selectedY = selectedPosition!.dy;
    final list = [yLow, yHigh, yAsk, yBid, selectedY]..sort();
    final indexOfSelected = list.indexOf(selectedY);
    double y;
    if (indexOfSelected == 0) {
      y = yHigh;
    } else if (indexOfSelected == 4) {
      y = yLow;
    } else {
      final prev = list[indexOfSelected - 1];
      final next = list[indexOfSelected + 1];
      if ((selectedY - prev).abs() > (selectedY - next).abs()) {
        y = next;
      } else {
        y = prev;
      }
    }
    final point = Offset(x, y);
    if (y == yLow) {
      pointValue = entry.value.low;
    } else if (y == yHigh) {
      pointValue = entry.value.high;
    } else if (y == yBid) {
      pointValue = entry.value.bid;
    } else if (y == yAsk) {
      pointValue = entry.value.ask;
    }

    return (point: point, value: pointValue);
  }

  /// Drop line painter.
  void paintDropLine(Canvas canvas, Size size) {
    final showDropLine = selectedPosition != null && settings.showDropLine;

    if (!data.canDraw || !showDropLine) {
      return;
    }

    final selectedIndex = getSelectedIndex(size)!;
    final point = _getPointData(size, selectedIndex).point;

    GridAxisPainter.paintDropLine(
      canvas,
      size,
      data,
      style.dropLineStyle,
      point,
    );
  }

  /// Candlestick painter.
  void paintCandlesticks(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    double getYValue(double y, double oldY) {
      final normalizedOldY = normalizeOld(oldY);
      final normalizedY = normalize(y);
      final animatedY =
          normalizedOldY + (normalizedY - normalizedOldY) * valueCoef;

      return animatedY;
    }

    final widthFraction = size.width / data.xAxisDivisions;
    final map = data.data;
    final oldMap = adjustMap(data.data, oldData.data);

    double x = 0;
    double yLow = 0;
    double yHigh = 0;
    double yBid = 0;
    double yAsk = 0;
    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;
      final oldValue = oldMap.entries.elementAt(i).value;

      x = widthFraction * i;
      yLow = getYValue(value.low, oldValue.low) * size.height;
      yHigh = getYValue(value.high, oldValue.high) * size.height;
      yBid = getYValue(value.bid, oldValue.bid) * size.height;
      yAsk = getYValue(value.ask, oldValue.ask) * size.height;

      final stickStyle = value.isBullish
          ? style.candleStickStyle.bullishStickPaint
          : style.candleStickStyle.bearishStickPaint;
      final candleStyle = value.isBullish
          ? style.candleStickStyle.bullishCandlePaint
          : style.candleStickStyle.bearishCandlePaint;

      canvas.drawLine(Offset(x, yLow), Offset(x, yHigh), stickStyle);
      if (yBid == yAsk) {
        // painting doji
        canvas.drawLine(
          Offset(x, yBid - stickStyle.strokeWidth / 2),
          Offset(x, yAsk + stickStyle.strokeWidth / 2),
          candleStyle,
        );
      } else {
        canvas.drawLine(Offset(x, yBid), Offset(x, yAsk), candleStyle);
      }
    }
  }

  /// Tooltip painter.
  void paintTooltip(Canvas canvas, Size size) {
    final showTooltip = selectedPosition != null && settings.showTooltip;

    if (!data.canDraw || !showTooltip) {
      return;
    }

    final selectedIndex = getSelectedIndex(size)!;
    final entry = data.data.entries.elementAt(selectedIndex);
    final pointData = _getPointData(size, selectedIndex);
    final modifiedEntry = MapEntry(
      entry.key,
      ValueCandlestickData.of(entry.value, pointData.value),
    );

    GridAxisPainter.paintTooltip(
      canvas,
      size,
      data,
      style.tooltipStyle,
      modifiedEntry,
      pointData.point,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintDropLine(canvas, size);
    paintCandlesticks(canvas, size);
    paintTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CandlestickChartPainter oldDelegate) =>
      cache != oldDelegate.cache ||
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      oldDataHashCode != oldDelegate.oldDataHashCode ||
      selectedPosition != oldDelegate.selectedPosition ||
      valueCoef != oldDelegate.valueCoef;
}

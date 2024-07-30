// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
      GridAxisUtils().getSelectedIndex(size, selectedXPosition, data);

  Offset _getPoint(Size size, int selectedIndex) {
    if (!data.canDraw) {
      return Offset(0, size.height);
    }

    final entry = data.data.entries.elementAt(selectedIndex);
    final widthFraction = size.width / data.xAxisDivisions;

    final x = widthFraction * selectedIndex;
    final y = normalize(entry.value.high) * size.height;
    final point = Offset(x, y);

    return point;
  }

  /// Drop line painter.
  void paintDropLine(Canvas canvas, Size size) {
    final showDropLine = selectedXPosition != null && settings.showDropLine;

    if (!data.canDraw || !showDropLine) {
      return;
    }

    final selectedIndex = getSelectedIndex(size)!;
    final point = _getPoint(size, selectedIndex);

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

      final stickStyle = value.isAscending
          ? style.candleStickStyle.bullishStickPaint
          : style.candleStickStyle.bearishStickPaint;
      final candleStyle = value.isAscending
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
    final showTooltip = selectedXPosition != null && settings.showTooltip;

    if (!data.canDraw || !showTooltip) {
      return;
    }

    final selectedIndex = getSelectedIndex(size)!;
    final entry = data.data.entries.elementAt(selectedIndex);
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
      selectedXPosition != oldDelegate.selectedXPosition ||
      valueCoef != oldDelegate.valueCoef;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';
import 'package:mdcharts/_internal.dart';

/// Contains various customization options for the [CandleStickChart].
class CandlestickChartStyle extends GridAxisStyle {
  /// Constructs an instance of [CandlestickChartStyle].
  const CandlestickChartStyle({
    super.gridStyle = const GridStyle(),
    super.axisStyle = const AxisStyle(),
    this.candleStickStyle = const CandlestickChartCandleStickStyle(),
  });

  /// Style of the candle and stick.
  final CandlestickChartCandleStickStyle candleStickStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  @override
  CandlestickChartStyle copyWith({
    GridStyle? gridStyle,
    AxisStyle? axisStyle,
    CandlestickChartCandleStickStyle? candleStickStyle,
  }) =>
      CandlestickChartStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
        candleStickStyle: candleStickStyle ?? this.candleStickStyle,
      );

  @override
  int get hashCode =>
      gridStyle.hashCode ^ axisStyle.hashCode ^ candleStickStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      candleStickStyle == other.candleStickStyle;
}

/// Contains various customization options for the line of the chart itself.
class CandlestickChartCandleStickStyle {
  /// Constructs an instance of [CandlestickChartCandleStickStyle].
  const CandlestickChartCandleStickStyle({
    this.bullishColor = const Color(0xFF00FF00),
    this.bearishColor = const Color(0xFFFF0000),
    this.stickStroke = 1,
    this.candleStroke = 5,
  });

  /// Bullish or ascending color of the candle and the stick.
  ///
  /// Defaults to `0xFF00FF00`.
  final Color bullishColor;

  /// Bearish or descending color of the candle and the stick.
  ///
  /// Defaults to `0xFFFF0000`.
  final Color bearishColor;

  /// Stroke of the stick.
  ///
  /// Defaults to `1`.
  final double stickStroke;

  /// Stroke of the candle.
  ///
  /// Defaults to `5`.
  final double candleStroke;

  /// Gets a [Paint] for the bullish stick drawing.
  Paint get bullishStickPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stickStroke
    ..color = bullishColor;

  /// Gets a [Paint] for the bearish stick drawing.
  Paint get bearishStickPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stickStroke
    ..color = bearishColor;

  /// Gets a [Paint] for the bullish candle drawing.
  Paint get bullishCandlePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = candleStroke
    ..color = bullishColor;

  /// Gets a [Paint] for the bearish candle drawing.
  Paint get bearishCandlePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = candleStroke
    ..color = bearishColor;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartCandleStickStyle copyWith({
    Color? bullishColor,
    Color? bearishColor,
    double? stickStroke,
    double? candleStroke,
  }) =>
      CandlestickChartCandleStickStyle(
        bullishColor: bullishColor ?? this.bullishColor,
        bearishColor: bearishColor ?? this.bearishColor,
        stickStroke: stickStroke ?? this.stickStroke,
        candleStroke: candleStroke ?? this.candleStroke,
      );

  @override
  int get hashCode =>
      bullishColor.hashCode ^
      bearishColor.hashCode ^
      stickStroke.hashCode ^
      candleStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartCandleStickStyle &&
      bullishColor == other.bullishColor &&
      bearishColor == other.bearishColor &&
      stickStroke == other.stickStroke &&
      candleStroke == other.candleStroke;
}

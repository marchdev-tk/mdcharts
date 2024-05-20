// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

import '../common.dart';

/// Contains various customization options for the [CandleStickChart].
class CandlestickChartStyle {
  /// Constructs an instance of [CandlestickChartStyle].
  const CandlestickChartStyle({
    this.gridStyle = const CandlestickChartGridStyle(),
    this.axisStyle = const CandlestickChartAxisStyle(),
    this.candleStickStyle = const CandlestickChartCandleStickStyle(),
  });

  /// Style of the grid lines.
  final CandlestickChartGridStyle gridStyle;

  /// Style of the axis lines.
  final CandlestickChartAxisStyle axisStyle;

  /// Style of the candle and stick.
  final CandlestickChartCandleStickStyle candleStickStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartStyle copyWith({
    CandlestickChartGridStyle? gridStyle,
    CandlestickChartAxisStyle? axisStyle,
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

/// Contains various customization options for the grid lines of the chart.
class CandlestickChartGridStyle {
  /// Constructs an instance of [CandlestickChartGridStyle].
  const CandlestickChartGridStyle({
    this.xAxisColor = const Color(0x33FFFFFF),
    this.xAxisStroke = 1,
    this.yAxisColor = const Color(0x33FFFFFF),
    this.yAxisStroke = 1,
  });

  /// Constructs an instance of [CandlestickChartGridStyle] for same color and
  /// stroke for both axis.
  const CandlestickChartGridStyle.same({
    Color color = const Color(0x33FFFFFF),
    double stroke = 1,
  })  : xAxisColor = color,
        xAxisStroke = stroke,
        yAxisColor = color,
        yAxisStroke = stroke;

  /// Color of the X axis grid lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color xAxisColor;

  /// Stroke of the X axis grid lines.
  ///
  /// Defaults to `1`.
  final double xAxisStroke;

  /// Color of the Y axis grid lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color yAxisColor;

  /// Stroke of the Y axis grid lines.
  ///
  /// Defaults to `1`.
  final double yAxisStroke;

  /// Gets a [Paint] for the X axis grid drawing.
  Paint get xAxisPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = xAxisStroke
    ..color = xAxisColor;

  /// Gets a [Paint] for the Y axis grid drawing.
  Paint get yAxisPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = yAxisStroke
    ..color = yAxisColor;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartGridStyle copyWith({
    Color? xAxisColor,
    double? xAxisStroke,
    Color? yAxisColor,
    double? yAxisStroke,
  }) =>
      CandlestickChartGridStyle(
        xAxisColor: xAxisColor ?? this.xAxisColor,
        xAxisStroke: xAxisStroke ?? this.xAxisStroke,
        yAxisColor: yAxisColor ?? this.yAxisColor,
        yAxisStroke: yAxisStroke ?? this.yAxisStroke,
      );

  @override
  int get hashCode =>
      xAxisColor.hashCode ^
      xAxisStroke.hashCode ^
      yAxisColor.hashCode ^
      yAxisStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartGridStyle &&
      xAxisColor == other.xAxisColor &&
      xAxisStroke == other.xAxisStroke &&
      yAxisColor == other.yAxisColor &&
      yAxisStroke == other.yAxisStroke;
}

/// Contains various customization options for the axis of the chart.
class CandlestickChartAxisStyle {
  /// Constructs an instance of [CandlestickChartAxisStyle].
  const CandlestickChartAxisStyle({
    this.stroke = 1,
    this.color = const Color(0x33FFFFFF),
    this.yAxisLabelStyle = defaultYAxisLabelStyle,
    this.xAxisLabelStyle = defaultXAxisLabelStyle,
    this.xAxisSelectedLabelStyle = defaultXAxisSelectedLabelStyle,
    this.xAxisLabelTopMargin = 6,
    this.xAxisLabelPadding = defaultXAxisLabelPadding,
    this.xAxisSelectedLabelBackgroundColor = const Color(0xFFFFFFFF),
    this.xAxisSelectedLabelBorderRadius = defaultXAxisSelectedLabelBorderRadius,
  });

  static const defaultYAxisLabelStyle = TextStyle(
    height: 16 / 11,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0x66FFFFFF),
  );
  static const defaultXAxisLabelStyle = TextStyle(
    height: 16 / 11,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );
  static const defaultXAxisSelectedLabelStyle = TextStyle(
    height: 16 / 11,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0xFF000000),
  );
  static const defaultXAxisLabelPadding = EdgeInsets.fromLTRB(8, 2, 8, 2);
  static const defaultXAxisSelectedLabelBorderRadius =
      BorderRadius.all(Radius.circular(12));

  /// Stroke of the axis lines.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Color of the axis lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Y axis label style.
  ///
  /// Defaults to [defaultYAxisLabelStyle].
  final TextStyle yAxisLabelStyle;

  /// X axis label style.
  ///
  /// Defaults to [defaultXAxisLabelStyle].
  final TextStyle xAxisLabelStyle;

  /// X axis selected label style.
  ///
  /// Defaults to [defaultXAxisSelectedLabelStyle].
  final TextStyle xAxisSelectedLabelStyle;

  /// Top margin of the X axis label.
  ///
  /// Defaults to `6`.
  final double xAxisLabelTopMargin;

  /// Padding of the X axis label.
  ///
  /// Defaults to [defaultXAxisLabelPadding].
  final EdgeInsets xAxisLabelPadding;

  /// Background color of the selected X axis label.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color xAxisSelectedLabelBackgroundColor;

  /// Border radius of the selected X axis label.
  ///
  /// Defaults to [defaultXAxisSelectedLabelBorderRadius].
  final BorderRadius xAxisSelectedLabelBorderRadius;

  /// Gets height of the label.
  double get labelHeight {
    final labelHeight = MDTextPainter(TextSpan(
      text: '',
      style: xAxisLabelStyle,
    )).size.height;

    return labelHeight;
  }

  /// Gets a [Paint] for the axis drawing.
  Paint get paint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartAxisStyle copyWith({
    double? stroke,
    Color? color,
    TextStyle? yAxisLabelStyle,
    TextStyle? xAxisLabelStyle,
    TextStyle? xAxisSelectedLabelStyle,
    double? xAxisLabelTopMargin,
    EdgeInsets? xAxisLabelPadding,
    Color? xAxisSelectedLabelBackgroundColor,
    BorderRadius? xAxisSelectedLabelBorderRadius,
  }) =>
      CandlestickChartAxisStyle(
        stroke: stroke ?? this.stroke,
        color: color ?? this.color,
        yAxisLabelStyle: yAxisLabelStyle ?? this.yAxisLabelStyle,
        xAxisLabelStyle: xAxisLabelStyle ?? this.xAxisLabelStyle,
        xAxisSelectedLabelStyle:
            xAxisSelectedLabelStyle ?? this.xAxisSelectedLabelStyle,
        xAxisLabelTopMargin: xAxisLabelTopMargin ?? this.xAxisLabelTopMargin,
        xAxisLabelPadding: xAxisLabelPadding ?? this.xAxisLabelPadding,
        xAxisSelectedLabelBackgroundColor: xAxisSelectedLabelBackgroundColor ??
            this.xAxisSelectedLabelBackgroundColor,
        xAxisSelectedLabelBorderRadius: xAxisSelectedLabelBorderRadius ??
            this.xAxisSelectedLabelBorderRadius,
      );

  @override
  int get hashCode =>
      stroke.hashCode ^
      color.hashCode ^
      yAxisLabelStyle.hashCode ^
      xAxisLabelStyle.hashCode ^
      xAxisSelectedLabelStyle.hashCode ^
      xAxisLabelTopMargin.hashCode ^
      xAxisLabelPadding.hashCode ^
      xAxisSelectedLabelBackgroundColor.hashCode ^
      xAxisSelectedLabelBorderRadius.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartAxisStyle &&
      stroke == other.stroke &&
      color == other.color &&
      yAxisLabelStyle == other.yAxisLabelStyle &&
      xAxisLabelStyle == other.xAxisLabelStyle &&
      xAxisLabelTopMargin == other.xAxisLabelTopMargin &&
      xAxisLabelPadding == other.xAxisLabelPadding &&
      xAxisSelectedLabelBackgroundColor ==
          other.xAxisSelectedLabelBackgroundColor &&
      xAxisSelectedLabelBorderRadius == other.xAxisSelectedLabelBorderRadius;
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

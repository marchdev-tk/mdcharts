// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../utils.dart';

/// Contains various customization options for the [BarChart].
class BarChartStyle {
  /// Constructs an instance of [BarChartStyle].
  const BarChartStyle({
    this.gridStyle = const BarChartGridStyle(),
    this.axisStyle = const BarChartAxisStyle(),
    this.barStyle = const BarChartBarStyle(),
  });

  /// Style of the grid lines.
  final BarChartGridStyle gridStyle;

  /// Style of the axis lines.
  final BarChartAxisStyle axisStyle;

  /// Style of the bar.
  final BarChartBarStyle barStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartStyle copyWith({
    BarChartGridStyle? gridStyle,
    BarChartAxisStyle? axisStyle,
    BarChartBarStyle? barStyle,
  }) =>
      BarChartStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
        barStyle: barStyle ?? this.barStyle,
      );

  @override
  int get hashCode =>
      gridStyle.hashCode ^ axisStyle.hashCode ^ barStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      barStyle == other.barStyle;
}

/// Contains various customization options for the grid lines of the chart.
class BarChartGridStyle {
  /// Constructs an instance of [BarChartGridStyle].
  const BarChartGridStyle({
    this.color = const Color(0x33FFFFFF),
    this.stroke = 1,
  });

  /// Color of the grid lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Stroke of the grid lines.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Gets a [Paint] for the X axis grid drawing.
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = stroke
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartGridStyle copyWith({
    Color? color,
    double? stroke,
  }) =>
      BarChartGridStyle(
        color: color ?? this.color,
        stroke: stroke ?? this.stroke,
      );

  @override
  int get hashCode => color.hashCode ^ stroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartGridStyle &&
      color == other.color &&
      stroke == other.stroke;
}

/// Contains various customization options for the axis of the chart.
class BarChartAxisStyle {
  /// Constructs an instance of [BarChartAxisStyle].
  const BarChartAxisStyle({
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

  /// Stroke of the X axis line.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Color of the X axis line.
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

  /// TODO: add docs
  ///
  /// Defaults to [defaultXAxisLabelPadding].
  final EdgeInsets xAxisLabelPadding;

  /// TODO: add docs
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color xAxisSelectedLabelBackgroundColor;

  /// TODO: add docs
  ///
  /// Defaults to [defaultXAxisSelectedLabelBorderRadius].
  final BorderRadius xAxisSelectedLabelBorderRadius;

  /// Gets height of the label.
  double get labelHeight {
    final labelHeight = MDTextPainter(TextSpan(
      text: '',
      style: xAxisLabelStyle,
    )).size.height;
    final selectedLabelHeight = MDTextPainter(TextSpan(
      text: '',
      style: xAxisSelectedLabelStyle,
    )).size.height;

    final maxHeight = math.max(labelHeight, selectedLabelHeight);

    return maxHeight + xAxisLabelPadding.vertical;
  }

  /// Gets a [Paint] for the axis drawing.
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartAxisStyle copyWith({
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
      BarChartAxisStyle(
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
      other is BarChartAxisStyle &&
      stroke == other.stroke &&
      color == other.color &&
      yAxisLabelStyle == other.yAxisLabelStyle &&
      xAxisLabelStyle == other.xAxisLabelStyle &&
      xAxisSelectedLabelStyle == other.xAxisSelectedLabelStyle &&
      xAxisLabelTopMargin == other.xAxisLabelTopMargin &&
      xAxisLabelPadding == other.xAxisLabelPadding &&
      xAxisSelectedLabelBackgroundColor ==
          other.xAxisSelectedLabelBackgroundColor &&
      xAxisSelectedLabelBorderRadius == other.xAxisSelectedLabelBorderRadius;
}

/// Contains various customization options for the bars of the chart.
class BarChartBarStyle {
  /// Constructs an instance of [BarChartBarStyle].
  const BarChartBarStyle({
    this.width = 32,
    this.colors = const [Color(0xFFFFFFFF)],
    this.zeroBarHeight = 2,
    this.topRadius = 6,
    this.zeroBarTopRadius = 2,
  });

  /// TODO: add docs
  ///
  /// Defautls to `32`.
  final double width;

  /// TODO: add docs
  ///
  /// Defaults to `[Color(0xFFFFFFFF)]`.
  final List<Color> colors;

  /// TODO: add docs
  ///
  /// Defaults to `2`.
  final double zeroBarHeight;

  /// TODO: add docs
  ///
  /// Defaults to `6`.
  final double topRadius;

  /// TODO: add docs
  ///
  /// Defaults to `2`.
  final double zeroBarTopRadius;

  /// TODO: add docs
  bool get showZeroBars => zeroBarHeight > 0;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartBarStyle copyWith({
    double? width,
    List<Color>? colors,
    double? zeroBarHeight,
    double? topRadius,
    double? zeroBarTopRadius,
  }) =>
      BarChartBarStyle(
        width: width ?? this.width,
        colors: colors ?? this.colors,
        zeroBarHeight: zeroBarHeight ?? this.zeroBarHeight,
        topRadius: topRadius ?? this.topRadius,
        zeroBarTopRadius: zeroBarTopRadius ?? this.zeroBarTopRadius,
      );

  @override
  int get hashCode =>
      width.hashCode ^
      colors.hashCode ^
      zeroBarHeight.hashCode ^
      topRadius.hashCode ^
      zeroBarTopRadius.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartBarStyle &&
      width == other.width &&
      listEquals(colors, other.colors) &&
      zeroBarHeight == other.zeroBarHeight &&
      topRadius == other.topRadius &&
      zeroBarTopRadius == other.zeroBarTopRadius;
}

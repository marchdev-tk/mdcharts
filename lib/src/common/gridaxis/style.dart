// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';
import 'package:mdcharts/_internal.dart';

/// Contains various customization options for the [GridAxis].
class GridAxisStyle {
  /// Constructs an instance of [GridAxisStyle].
  const GridAxisStyle({
    this.gridStyle = const GridStyle(),
    this.axisStyle = const AxisStyle(),
  });

  /// Style of the grid lines.
  final GridStyle gridStyle;

  /// Style of the axis lines.
  final AxisStyle axisStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GridAxisStyle copyWith({
    GridStyle? gridStyle,
    AxisStyle? axisStyle,
  }) =>
      GridAxisStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
      );

  @override
  int get hashCode => gridStyle.hashCode ^ axisStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GridAxisStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle;
}

/// Contains various customization options for the grid lines of the chart.
class GridStyle {
  /// Constructs an instance of [GridStyle].
  const GridStyle({
    this.xAxisColor = const Color(0x33FFFFFF),
    this.xAxisStroke = 1,
    this.yAxisColor = const Color(0x33FFFFFF),
    this.yAxisStroke = 1,
  });

  /// Constructs an instance of [GridStyle] for same color and
  /// stroke for both axis.
  const GridStyle.same({
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
  GridStyle copyWith({
    Color? xAxisColor,
    double? xAxisStroke,
    Color? yAxisColor,
    double? yAxisStroke,
  }) =>
      GridStyle(
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
      other is GridStyle &&
      xAxisColor == other.xAxisColor &&
      xAxisStroke == other.xAxisStroke &&
      yAxisColor == other.yAxisColor &&
      yAxisStroke == other.yAxisStroke;
}

/// Contains various customization options for the axis of the chart.
class AxisStyle {
  /// Constructs an instance of [AxisStyle].
  const AxisStyle({
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
  AxisStyle copyWith({
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
      AxisStyle(
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
      other is AxisStyle &&
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

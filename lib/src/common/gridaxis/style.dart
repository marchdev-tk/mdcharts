// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';
import 'package:mdcharts/src/_internal.dart';

/// Contains various customization options for the [GridAxis].
class GridAxisStyle {
  /// Constructs an instance of [GridAxisStyle].
  const GridAxisStyle({
    this.gridStyle = const GridStyle(),
    this.axisStyle = const AxisStyle(),
    this.dropLineStyle = const DropLineStyle(),
    this.tooltipStyle = const TooltipStyle(),
  });

  /// Style of the grid lines.
  final GridStyle gridStyle;

  /// Style of the axis lines.
  final AxisStyle axisStyle;

  /// Style of the drop line.
  final DropLineStyle dropLineStyle;

  /// Style of the tooltip.
  final TooltipStyle tooltipStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GridAxisStyle copyWith({
    GridStyle? gridStyle,
    AxisStyle? axisStyle,
    TooltipStyle? tooltipStyle,
  }) =>
      GridAxisStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
        tooltipStyle: tooltipStyle ?? this.tooltipStyle,
      );

  @override
  int get hashCode =>
      gridStyle.hashCode ^ axisStyle.hashCode ^ tooltipStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GridAxisStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      tooltipStyle == other.tooltipStyle;
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

/// Contains various customization options for the drop line.
class DropLineStyle {
  /// Constructs an instance of [DropLineStyle].
  const DropLineStyle({
    this.color = const Color(0xFFFFFFFF),
    this.stroke = 1,
    this.dashSize = 2,
    this.gapSize = 2,
  });

  /// Color of the drop line.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color color;

  /// Stroke of the drop line.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Dash size of the drop line.
  ///
  /// Defaults to `2`.
  final double dashSize;

  /// Gap size of the drop line.
  ///
  /// Defaults to `2`.
  final double gapSize;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DropLineStyle copyWith({
    Color? color,
    double? stroke,
    double? dashSize,
    double? gapSize,
  }) =>
      DropLineStyle(
        color: color ?? this.color,
        stroke: stroke ?? this.stroke,
        dashSize: dashSize ?? this.dashSize,
        gapSize: gapSize ?? this.gapSize,
      );

  /// Gets a [Paint] for the drop line drawing.
  Paint get paint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = stroke
    ..color = color;

  @override
  int get hashCode =>
      color.hashCode ^ stroke.hashCode ^ dashSize.hashCode ^ gapSize.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DropLineStyle &&
      color == other.color &&
      stroke == other.stroke &&
      dashSize == other.dashSize &&
      gapSize == other.gapSize;
}

/// Contains various customization options for the tooltip.
class TooltipStyle {
  /// Constructs an instance of [TooltipStyle].
  const TooltipStyle({
    this.color = const Color(0xFFFFFFFF),
    this.titleStyle = defaultTitleStyle,
    this.subtitleStyle = defaultSubtitleStyle,
    this.padding = defaultPadding,
    this.spacing = 2,
    this.radius = 8,
    this.triangleWidth = 12,
    this.triangleHeight = 5,
    this.shadowColor = const Color(0xFF000000),
    this.shadowElevation = 4,
    this.bottomMargin = 6,
  });

  static const defaultTitleStyle = TextStyle(
    height: 1,
    fontSize: 10,
    color: Color(0xCC000000),
  );
  static const defaultSubtitleStyle = TextStyle(
    height: 16 / 12,
    fontSize: 12,
    color: Color(0xFF000000),
  );
  static const defaultPadding = EdgeInsets.fromLTRB(12, 4, 12, 4);

  /// Color of the tooltip.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color color;

  /// Title style of the tooltip.
  ///
  /// Defaults to [defaultTitleStyle].
  final TextStyle titleStyle;

  /// Subtitle style of the tooltip.
  ///
  /// Defaults to [defaultSubtitleStyle].
  final TextStyle subtitleStyle;

  /// Padding around title and subtitle of the tooltip.
  ///
  /// Defaults to [defaultPadding].
  final EdgeInsets padding;

  /// Spacing between title and subtitle of the tooltip.
  ///
  /// Defaults to `2`.
  final double spacing;

  /// Circular radius of the tooltip.
  ///
  /// Defaults to `8`.
  final double radius;

  /// Width of the tooltip triangle.
  ///
  /// Defaults to `12`.
  final double triangleWidth;

  /// Height of the tooltip triangle.
  ///
  /// Defaults to `5`.
  final double triangleHeight;

  /// Shadow color of the tooltip.
  ///
  /// Defaults to `0xFF000000`.
  final Color shadowColor;

  /// Elevation of the tooltip.
  ///
  /// Defaults to `4`.
  final double shadowElevation;

  /// Bottom margin of the tooltip.
  ///
  /// Defaults to `6`.
  final double bottomMargin;

  /// Gets size of the tooltip based on following:
  /// - [bottomMargin];
  /// - [padding.vertical];
  /// - [spacing];
  /// - [titleStyle];
  /// - [subtitleStyle].
  double get tooltipHeight {
    final titleHeight = MDTextPainter(TextSpan(
      text: '',
      style: titleStyle,
    )).size.height;
    final subtitleHeight = MDTextPainter(TextSpan(
      text: '',
      style: subtitleStyle,
    )).size.height;

    return bottomMargin +
        padding.vertical +
        spacing +
        titleHeight +
        subtitleHeight;
  }

  /// Gets horizontal overflow width of the tooltip based on following:
  /// - [radius];
  /// - half size of [triangleWidth].
  double get tooltipHorizontalOverflowWidth {
    return radius + triangleWidth / 2;
  }

  /// Default padding of the chart caused by tooltip.
  ///
  /// Description:
  /// - left/right: [tooltipHorizontalOverflowWidth].
  /// - bottom: `0`;
  /// - top: [tooltipHeight].
  EdgeInsets get defaultChartPadding {
    return EdgeInsets.fromLTRB(
      tooltipHorizontalOverflowWidth,
      tooltipHeight,
      tooltipHorizontalOverflowWidth,
      0,
    );
  }

  /// Gets a [Paint] for the tooltip drawing.
  Paint get paint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  TooltipStyle copyWith({
    Color? color,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsets? padding,
    double? spacing,
    double? radius,
    double? triangleWidth,
    double? triangleHeight,
    Color? shadowColor,
    double? shadowElevation,
    double? bottomMargin,
  }) =>
      TooltipStyle(
        color: color ?? this.color,
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        padding: padding ?? this.padding,
        spacing: spacing ?? this.spacing,
        radius: radius ?? this.radius,
        triangleWidth: triangleWidth ?? this.triangleWidth,
        triangleHeight: triangleHeight ?? this.triangleHeight,
        shadowColor: shadowColor ?? this.shadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
        bottomMargin: bottomMargin ?? this.bottomMargin,
      );

  @override
  int get hashCode =>
      color.hashCode ^
      titleStyle.hashCode ^
      subtitleStyle.hashCode ^
      padding.hashCode ^
      spacing.hashCode ^
      radius.hashCode ^
      triangleWidth.hashCode ^
      triangleHeight.hashCode ^
      shadowColor.hashCode ^
      shadowElevation.hashCode ^
      bottomMargin.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TooltipStyle &&
      color == other.color &&
      titleStyle == other.titleStyle &&
      subtitleStyle == other.subtitleStyle &&
      padding == other.padding &&
      spacing == other.spacing &&
      radius == other.radius &&
      triangleWidth == other.triangleWidth &&
      triangleHeight == other.triangleHeight &&
      shadowColor == other.shadowColor &&
      shadowElevation == other.shadowElevation &&
      bottomMargin == other.bottomMargin;
}

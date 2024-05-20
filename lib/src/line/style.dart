// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' show ImageFilter;

import 'package:flutter/painting.dart';
import 'package:mdcharts/src/_internal.dart';

/// Contains various customization options for the [LineChart].
class LineChartStyle extends GridAxisStyle {
  /// Constructs an instance of [LineChartStyle].
  const LineChartStyle({
    super.gridStyle = const GridStyle(),
    super.axisStyle = const AxisStyle(),
    this.lineStyle = const LineChartLineStyle(),
    this.limitStyle = const LineChartLimitStyle(),
    this.pointStyle = const LineChartPointStyle(),
    this.tooltipStyle = const LineChartTooltipStyle(),
  });

  /// Style of the line.
  ///
  /// It contains customization for the line itself, color or gradient of the
  /// filled part of the chart and final point altitude line.
  final LineChartLineStyle lineStyle;

  /// Style of the limit label and label dashed line.
  final LineChartLimitStyle limitStyle;

  /// Style of the point.
  ///
  /// It contains customizaiton for the drop line and point itself.
  final LineChartPointStyle pointStyle;

  /// Style of the tooltip.
  final LineChartTooltipStyle tooltipStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  @override
  LineChartStyle copyWith({
    GridStyle? gridStyle,
    AxisStyle? axisStyle,
    LineChartLineStyle? lineStyle,
    LineChartLimitStyle? limitStyle,
    LineChartPointStyle? pointStyle,
    LineChartTooltipStyle? tooltipStyle,
  }) =>
      LineChartStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
        lineStyle: lineStyle ?? this.lineStyle,
        limitStyle: limitStyle ?? this.limitStyle,
        pointStyle: pointStyle ?? this.pointStyle,
        tooltipStyle: tooltipStyle ?? this.tooltipStyle,
      );

  @override
  int get hashCode =>
      gridStyle.hashCode ^
      axisStyle.hashCode ^
      lineStyle.hashCode ^
      limitStyle.hashCode ^
      pointStyle.hashCode ^
      tooltipStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      lineStyle == other.lineStyle &&
      limitStyle == other.limitStyle &&
      pointStyle == other.pointStyle &&
      tooltipStyle == other.tooltipStyle;
}

/// Contains various customization options for the line of the chart itself.
class LineChartLineStyle {
  /// Constructs an instance of [LineChartLineStyle].
  ///
  /// If it is needed to remove the fill gradient - set [fillGradient]
  /// explicitly to `null`.
  const LineChartLineStyle({
    this.color = const Color(0xFFFFFFFF),
    this.colorInactive = const Color(0x4DFFFFFF),
    this.stroke = 3,
    this.shadowColor = const Color(0x33000000),
    this.shadowStroke = 4,
    this.shadowOffset = const Offset(0, 2),
    this.shadowBlurRadius = 4,
    this.fillGradient = defaultGradient,
    this.fillColor,
    this.altitudeLineStroke = 1,
    this.altitudeLineColor = const Color(0x33FFFFFF),
  });

  static const defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x4DFFFFFF),
      Color(0x33FFFFFF),
      Color(0x1AFFFFFF),
      Color(0x01FFFFFF),
    ],
    stops: [0, 0.1675, 0.5381, 1],
  );

  /// Color of the chart line.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color color;

  /// Color of the chart line.
  ///
  /// Defaults to `0x4DFFFFFF`.
  final Color colorInactive;

  /// Stroke of the chart line.
  ///
  /// Defaults to `3`.
  final double stroke;

  /// Color of the shadow beneath the chart line.
  ///
  /// Defaults to `0x33000000`.
  final Color shadowColor;

  /// Stroke of the shadow beneath the chart line.
  ///
  /// Defaults to `4`.
  final double shadowStroke;

  /// Offset of the shadow beneath the chart line.
  ///
  /// Defaults to `Offset(0, 2)`.
  final Offset shadowOffset;

  /// Blur radius of the shadow beneath the chart line.
  ///
  /// Defaults to `4`.
  final double shadowBlurRadius;

  /// Fill gradient of the chart between X axis and chart line.
  ///
  /// Defaults to [defaultGradient].
  final Gradient? fillGradient;

  /// Fill color of the chart between X axis and chart line.
  ///
  /// Defaults to `null`.
  final Color? fillColor;

  /// Stroke of the altitude line.
  ///
  /// Defaults to `1`.
  final double altitudeLineStroke;

  /// Color of the altitude line.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color altitudeLineColor;

  /// Gets whether chart between the line and the X axis is needed to be
  /// filled or not.
  bool get filled => fillGradient != null || fillColor != null;

  /// Gets a [Paint] for the line drawing.
  Paint get linePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stroke
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  /// Gets a [Paint] for the inactive line drawing.
  Paint get lineInactivePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stroke
    ..strokeJoin = StrokeJoin.round
    ..color = colorInactive;

  /// Gets a [Paint] for the drawing of the shadow beneath the line.
  Paint get shadowPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = shadowStroke
    ..color = shadowColor
    ..imageFilter = ImageFilter.blur(
      sigmaX: shadowBlurRadius,
      sigmaY: shadowBlurRadius,
    );

  /// Gets a [Paint] for the altitude line drawing.
  Paint get altitudeLinePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = altitudeLineStroke
    ..color = altitudeLineColor;

  /// Gets a [Paint] for the drawing the fill of the chart between the line
  /// and the X axis.
  Paint getFillPaint([Rect? bounds]) {
    assert(filled);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.fill;

    if (fillColor != null) {
      paint.color = fillColor!;
    }
    if (fillGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if fillGradient not null',
      );

      paint.shader = fillGradient!.createShader(bounds!);
    }

    return paint;
  }

  @override
  int get hashCode =>
      color.hashCode ^
      colorInactive.hashCode ^
      stroke.hashCode ^
      shadowColor.hashCode ^
      shadowStroke.hashCode ^
      shadowOffset.hashCode ^
      shadowBlurRadius.hashCode ^
      fillGradient.hashCode ^
      fillColor.hashCode ^
      altitudeLineStroke.hashCode ^
      altitudeLineColor.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartLineStyle &&
      color == other.color &&
      colorInactive == other.colorInactive &&
      stroke == other.stroke &&
      shadowColor == other.shadowColor &&
      shadowStroke == other.shadowStroke &&
      shadowOffset == other.shadowOffset &&
      shadowBlurRadius == other.shadowBlurRadius &&
      fillGradient == other.fillGradient &&
      fillColor == other.fillColor &&
      altitudeLineStroke == other.altitudeLineStroke &&
      altitudeLineColor == other.altitudeLineColor;
}

/// Contains various customization options for limit line and label.
class LineChartLimitStyle {
  /// Constructs an instance of [LineChartLimitStyle].
  const LineChartLimitStyle({
    this.labelStyle = defaultStyle,
    this.labelOveruseStyle = defaultOveruseStyle,
    this.labelTextPadding = defaultTextPadding,
    this.labelColor = const Color(0xFFFFFFFF),
    this.dashColor = const Color(0x80FFFFFF),
    this.stroke = 1,
    this.dashSize = 2,
    this.gapSize = 2,
  });

  static const defaultStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFF000000),
  );
  static const defaultOveruseStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFFED2A24),
  );
  static const defaultTextPadding = EdgeInsets.fromLTRB(11, 3, 14, 3);

  /// [TextStyle] of a label.
  ///
  /// Defaults to [defaultStyle].
  final TextStyle labelStyle;

  /// [TextStyle] of a label if limit was overused.
  ///
  /// Defaults to [defaultOveruseStyle].
  final TextStyle labelOveruseStyle;

  /// Padding of a label.
  ///
  /// Defaults to [defaultTextPadding].
  final EdgeInsets labelTextPadding;

  /// Background color of a label.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color labelColor;

  /// Color of a dashed line.
  ///
  /// Defaults to `0x80FFFFFF`.
  final Color dashColor;

  /// Stroke of a dash line.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Size of dashes.
  ///
  /// Defaults to `2`.
  final double dashSize;

  /// Gap between dashes.
  ///
  /// Defaults to `2`.
  final double gapSize;

  /// Gets a [Paint] for the limit line drawing.
  Paint get linePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = stroke
    ..color = dashColor;

  /// Gets a [Paint] for the limit label drawing.
  Paint get labelPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = labelColor;

  @override
  int get hashCode =>
      labelStyle.hashCode ^
      labelOveruseStyle.hashCode ^
      labelTextPadding.hashCode ^
      labelColor.hashCode ^
      dashColor.hashCode ^
      stroke.hashCode ^
      dashSize.hashCode ^
      gapSize.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartLimitStyle &&
      labelStyle == other.labelStyle &&
      labelOveruseStyle == other.labelOveruseStyle &&
      labelTextPadding == other.labelTextPadding &&
      labelColor == other.labelColor &&
      dashColor == other.dashColor &&
      stroke == other.stroke &&
      dashSize == other.dashSize &&
      gapSize == other.gapSize;
}

/// Contains various customization options for the point (last available or
/// currently selected by user).
class LineChartPointStyle {
  /// Constructs an instance of [LineChartPointStyle].
  const LineChartPointStyle({
    this.innerColor = const Color(0xFF000000),
    this.innerSize = 7,
    this.outerColor = const Color(0xFFFFFFFF),
    this.outerSize = 17,
    this.shadowColor = const Color(0x33000000),
    this.shadowOffset = const Offset(0, 2),
    this.shadowBlurRadius = 4,
    this.dropLineColor = const Color(0xFFFFFFFF),
    this.dropLineStroke = 1,
    this.dropLineDashSize = 2,
    this.dropLineGapSize = 2,
  });

  /// Color of the inner circle.
  ///
  /// Defaults to `0xFF000000`.
  final Color innerColor;

  /// Size (diameter) of the inner circle.
  ///
  /// Defaults to `7`.
  final double innerSize;

  /// Color of the outer circle.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color outerColor;

  /// Size (diameter) of the outer circle.
  ///
  /// Defaults to `17`.
  final double outerSize;

  /// Shadow color.
  ///
  /// Defaults to `0x33000000`.
  final Color shadowColor;

  /// Offset of the shadow beneath the outer circle.
  ///
  /// Defaults to `Offset(0, 2)`.
  final Offset shadowOffset;

  /// Blur radius of the shadow.
  ///
  /// Defaults to `4`.
  final double shadowBlurRadius;

  /// Color of the drop line.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color dropLineColor;

  /// Stroke of the drop line.
  ///
  /// Defaults to `1`.
  final double dropLineStroke;

  /// Dash size of the drop line.
  ///
  /// Defaults to `2`.
  final double dropLineDashSize;

  /// Gap size of the drop line.
  ///
  /// Defaults to `2`.
  final double dropLineGapSize;

  /// Gets a [Paint] for the drawing of the inner circle of the point.
  Paint get innerPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = innerColor;

  /// Gets a [Paint] for the drawing of the outer circle of the point.
  Paint get outerPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = outerColor;

  /// Gets a [Paint] for the drawing of the outer circle shadow of the point.
  Paint get shadowPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = shadowColor
    ..imageFilter = ImageFilter.blur(
      sigmaX: shadowBlurRadius,
      sigmaY: shadowBlurRadius,
      tileMode: TileMode.decal,
    );

  /// Gets a [Paint] for the drop line drawing.
  Paint get dropLinePaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = dropLineStroke
    ..color = dropLineColor;

  @override
  int get hashCode =>
      innerColor.hashCode ^
      innerSize.hashCode ^
      outerColor.hashCode ^
      outerSize.hashCode ^
      shadowColor.hashCode ^
      shadowOffset.hashCode ^
      shadowBlurRadius.hashCode ^
      dropLineColor.hashCode ^
      dropLineDashSize.hashCode ^
      dropLineGapSize.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartPointStyle &&
      innerColor == other.innerColor &&
      innerSize == other.innerSize &&
      outerColor == other.outerColor &&
      outerSize == other.outerSize &&
      shadowColor == other.shadowColor &&
      shadowOffset == other.shadowOffset &&
      shadowBlurRadius == other.shadowBlurRadius &&
      dropLineColor == other.dropLineColor &&
      dropLineDashSize == other.dropLineDashSize &&
      dropLineGapSize == other.dropLineGapSize;
}

/// Contains various customization options for the tooltip.
class LineChartTooltipStyle {
  /// Constructs an instance of [LineChartTooltipStyle].
  const LineChartTooltipStyle({
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
  Paint get tooltipPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  LineChartTooltipStyle copyWith({
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
      LineChartTooltipStyle(
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
      other is LineChartTooltipStyle &&
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

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui' show ImageFilter;

import 'package:flutter/painting.dart';

import '../utils.dart';

/// Contains various customization options for the [LineChart].
class LineChartStyle {
  /// Constructs an instance of [LineChartStyle].
  const LineChartStyle({
    this.gridStyle = const LineChartGridStyle(),
    this.axisStyle = const LineChartAxisStyle(),
    this.lineStyle = const LineChartLineStyle(),
    this.limitStyle = const LineChartLimitStyle(),
    this.pointStyle = const LineChartPointStyle(),
  });

  /// Style of the grid lines.
  final LineChartGridStyle gridStyle;

  /// Style of the axis lines.
  final LineChartAxisStyle axisStyle;

  /// Style of the line.
  ///
  /// It contains customization for the line itself, color or gradient of the
  /// filled part of the chart and final point altitude line.
  final LineChartLineStyle lineStyle;

  /// Style of the limit label and label dashed line.
  final LineChartLimitStyle limitStyle;

  /// Style of the point.
  ///
  /// It contains customizaiton for the point itself, drop line, tooltip and
  /// bottom margin.
  final LineChartPointStyle pointStyle;

  @override
  int get hashCode =>
      gridStyle.hashCode ^
      axisStyle.hashCode ^
      lineStyle.hashCode ^
      limitStyle.hashCode ^
      pointStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      lineStyle == other.lineStyle &&
      limitStyle == other.limitStyle &&
      pointStyle == other.pointStyle;
}

/// Contains various customization options for the grid lines of the chart.
class LineChartGridStyle {
  /// Constructs an instance of [LineChartGridStyle].
  const LineChartGridStyle({
    this.color = const Color(0x33FFFFFF),
  });

  /// Color of the grid lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Gets a [Paint] for the grid drawing.
  Paint get paint => Paint()..color = color;

  @override
  int get hashCode => color.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartGridStyle && color == other.color;
}

/// Contains various customization options for the axis of the chart.
class LineChartAxisStyle {
  /// Constructs an instance of [LineChartAxisStyle].
  const LineChartAxisStyle({
    this.stroke = 1,
    this.color = const Color(0x33FFFFFF),
    this.labelStyle = defaultLabelStyle,
    this.labelSpacing = 16,
    this.labelTopPadding = 8,
  });

  static const defaultLabelStyle = TextStyle(
    height: 16 / 11,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  /// Stroke of the axis lines.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Color of the axis lines.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Axis label style.
  ///
  /// Defaults to [defaultLabelStyle].
  final TextStyle labelStyle;

  /// Spacing between labels.
  ///
  /// Defaults to `16`.
  final double labelSpacing;

  /// Top padding of the axis label.
  ///
  /// Defaults to `8`.
  final double labelTopPadding;

  /// Gets height of the label.
  double get labelHeight {
    final labelHeight = MDTextPainter(TextSpan(
      text: '',
      style: labelStyle,
    )).size.height;

    return labelHeight;
  }

  /// Gets a [Paint] for the axis drawing.
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..color = color;

  @override
  int get hashCode =>
      stroke.hashCode ^
      color.hashCode ^
      labelStyle.hashCode ^
      labelSpacing.hashCode ^
      labelTopPadding.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartAxisStyle &&
      stroke == other.stroke &&
      color == other.color &&
      labelStyle == other.labelStyle &&
      labelSpacing == other.labelSpacing &&
      labelTopPadding == other.labelTopPadding;
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
    this.blurRadius = 4,
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
  final double blurRadius;

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
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stroke
    ..color = color;

  /// Gets a [Paint] for the inactive line drawing.
  Paint get lineInactivePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = stroke
    ..color = colorInactive;

  /// Gets a [Paint] for the drawing of the shadow beneath the line.
  Paint get shadowPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = shadowStroke
    ..color = shadowColor
    ..imageFilter = ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius);

  /// Gets a [Paint] for the altitude line drawing.
  Paint get altitudeLinePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = altitudeLineStroke
    ..color = altitudeLineColor;

  /// Gets a [Paint] for the drawing the fill of the chart between the line
  /// and the X axis.
  Paint getFillPaint([Rect? bounds]) {
    assert(filled);

    final gradientPaint = Paint()..style = PaintingStyle.fill;

    if (fillColor != null) {
      gradientPaint.color = fillColor!;
    }
    if (fillGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if fillGradient not null',
      );

      gradientPaint.shader = fillGradient!.createShader(bounds!);
    }

    return gradientPaint;
  }

  @override
  int get hashCode =>
      color.hashCode ^
      colorInactive.hashCode ^
      stroke.hashCode ^
      shadowColor.hashCode ^
      shadowStroke.hashCode ^
      shadowOffset.hashCode ^
      blurRadius.hashCode ^
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
      blurRadius == other.blurRadius &&
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
    this.dashStroke = 1,
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
  final double dashStroke;

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
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = dashStroke
    ..color = dashColor;

  /// Gets a [Paint] for the limit label drawing.
  Paint get labelPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = labelColor;

  @override
  int get hashCode =>
      labelStyle.hashCode ^
      labelOveruseStyle.hashCode ^
      labelTextPadding.hashCode ^
      labelColor.hashCode ^
      dashColor.hashCode ^
      dashStroke.hashCode ^
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
      dashStroke == other.dashStroke &&
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
    this.dropLineDashSize = 2,
    this.dropLineGapSize = 2,
    this.tooltipColor = const Color(0xFFFFFFFF),
    this.tooltipTitleStyle = defaultTooltipTitleStyle,
    this.tooltipSubtitleStyle = defaultTooltipSubtitleStyle,
    this.tooltipPadding = defaultTooltipPadding,
    this.tooltipSpacing = 2,
    this.tooltipRadius = 8,
    this.tooltipTriangleWidth = 12,
    this.tooltipTriangleHeight = 5,
    this.tooltipShadowColor = const Color(0xFF000000),
    this.tooltipShadowElevation = 4,
    this.tooltopBottomMargin = 6,
  });

  static const defaultTooltipTitleStyle = TextStyle(
    height: 1,
    fontSize: 10,
    color: Color(0xCC000000),
  );
  static const defaultTooltipSubtitleStyle = TextStyle(
    height: 16 / 12,
    fontSize: 12,
    color: Color(0xFF000000),
  );
  static const defaultTooltipPadding = EdgeInsets.fromLTRB(12, 4, 12, 4);

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

  /// Dash size of the drop line.
  ///
  /// Defaults to `2`.
  final double dropLineDashSize;

  /// Gap size of the drop line.
  ///
  /// Defaults to `2`.
  final double dropLineGapSize;

  /// Color of the tooltip.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color tooltipColor;

  /// Title style of the tooltip.
  ///
  /// Defaults to [defaultTooltipTitleStyle].
  final TextStyle tooltipTitleStyle;

  /// Subtitle style of the tooltip.
  ///
  /// Defaults to [defaultTooltipSubtitleStyle].
  final TextStyle tooltipSubtitleStyle;

  /// Padding around title and subtitle of the tooltip.
  ///
  /// Defaults to [defaultTooltipPadding].
  final EdgeInsets tooltipPadding;

  /// Spacing between title and subtitle of the tooltip.
  ///
  /// Defaults to `2`.
  final double tooltipSpacing;

  /// Circular radius of the tooltip.
  ///
  /// Defaults to `8`.
  final double tooltipRadius;

  /// Width of the tooltip triangle.
  ///
  /// Defaults to `12`.
  final double tooltipTriangleWidth;

  /// Height of the tooltip triangle.
  ///
  /// Defaults to `5`.
  final double tooltipTriangleHeight;

  /// Shadow color of the tooltip.
  ///
  /// Defaults to `0xFF000000`.
  final Color tooltipShadowColor;

  /// Elevation of the tooltip.
  ///
  /// Defaults to `4`.
  final double tooltipShadowElevation;

  /// Bottom margin of the tooltip.
  ///
  /// Defaults to `6`.
  final double tooltopBottomMargin;

  /// Gets size of the tooltip based on following:
  /// - [tooltopBottomMargin];
  /// - [tooltipPadding.vertical];
  /// - [tooltipSpacing];
  /// - [tooltipTitleStyle];
  /// - [tooltipSubtitleStyle].
  double get tooltipHeight {
    final titleHeight = MDTextPainter(TextSpan(
      text: '',
      style: tooltipTitleStyle,
    )).size.height;
    final subtitleHeight = MDTextPainter(TextSpan(
      text: '',
      style: tooltipSubtitleStyle,
    )).size.height;

    return tooltopBottomMargin +
        tooltipPadding.vertical +
        tooltipSpacing +
        titleHeight +
        subtitleHeight;
  }

  /// Gets horizontal overflow width of the tooltip based on following:
  /// - [tooltipRadius];
  /// - half size of [tooltipTriangleWidth].
  double get tooltipHorizontalOverflowWidth {
    return tooltipRadius + tooltipTriangleWidth / 2;
  }

  /// Gets a [Paint] for the drawing of the inner circle of the point.
  Paint get innerPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = innerColor;

  /// Gets a [Paint] for the drawing of the outer circle of the point.
  Paint get outerPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = outerColor;

  /// Gets a [Paint] for the drawing of the outer circle shadow of the point.
  Paint get shadowPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = shadowColor
    ..imageFilter = ImageFilter.blur(
      sigmaX: shadowBlurRadius,
      sigmaY: shadowBlurRadius,
      tileMode: TileMode.decal,
    );

  /// Gets a [Paint] for the drop line drawing.
  Paint get dropLinePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = dropLineDashSize
    ..color = dropLineColor;

  /// Gets a [Paint] for the tooltip drawing.
  Paint get tooltipPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = tooltipColor;

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
      dropLineGapSize.hashCode ^
      tooltipColor.hashCode ^
      tooltipTitleStyle.hashCode ^
      tooltipSubtitleStyle.hashCode ^
      tooltipPadding.hashCode ^
      tooltipSpacing.hashCode ^
      tooltipRadius.hashCode ^
      tooltipTriangleWidth.hashCode ^
      tooltipTriangleHeight.hashCode ^
      tooltipShadowColor.hashCode ^
      tooltipShadowElevation.hashCode ^
      tooltopBottomMargin.hashCode;

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
      dropLineGapSize == other.dropLineGapSize &&
      tooltipColor == other.tooltipColor &&
      tooltipTitleStyle == other.tooltipTitleStyle &&
      tooltipSubtitleStyle == other.tooltipSubtitleStyle &&
      tooltipPadding == other.tooltipPadding &&
      tooltipSpacing == other.tooltipSpacing &&
      tooltipRadius == other.tooltipRadius &&
      tooltipTriangleWidth == other.tooltipTriangleWidth &&
      tooltipTriangleHeight == other.tooltipTriangleHeight &&
      tooltipShadowColor == other.tooltipShadowColor &&
      tooltipShadowElevation == other.tooltipShadowElevation &&
      tooltopBottomMargin == other.tooltopBottomMargin;
}

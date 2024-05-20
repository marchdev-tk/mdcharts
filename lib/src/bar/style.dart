// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../common.dart';

/// Axis division borders.
enum BarBorder {
  /// No border.
  ///
  /// Default option.
  none,

  /// Left border.
  left,

  /// Top border.
  top,

  /// Right border.
  right,

  /// Bottom border.
  bottom,

  /// [left] and [right] borders.
  horizontal,

  /// [top] and [bottom] borders.
  vertical,

  /// All borders.
  all,
}

/// Contains various customization options for the [BarChart].
class BarChartStyle {
  /// Constructs an instance of [BarChartStyle].
  const BarChartStyle({
    this.gridStyle = const BarChartGridStyle(),
    this.axisStyle = const BarChartAxisStyle(),
    this.barStyle = const BarChartBarStyle(),
    this.tooltipStyle = const BarChartTooltipStyle(),
  });

  /// Style of the grid lines.
  final BarChartGridStyle gridStyle;

  /// Style of the axis lines.
  final BarChartAxisStyle axisStyle;

  /// Style of the bar.
  final BarChartBarStyle barStyle;

  /// Style of the tooltip.
  final BarChartTooltipStyle tooltipStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartStyle copyWith({
    BarChartGridStyle? gridStyle,
    BarChartAxisStyle? axisStyle,
    BarChartBarStyle? barStyle,
    BarChartTooltipStyle? tooltipStyle,
  }) =>
      BarChartStyle(
        gridStyle: gridStyle ?? this.gridStyle,
        axisStyle: axisStyle ?? this.axisStyle,
        barStyle: barStyle ?? this.barStyle,
        tooltipStyle: tooltipStyle ?? this.tooltipStyle,
      );

  @override
  int get hashCode =>
      gridStyle.hashCode ^
      axisStyle.hashCode ^
      barStyle.hashCode ^
      tooltipStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartStyle &&
      gridStyle == other.gridStyle &&
      axisStyle == other.axisStyle &&
      barStyle == other.barStyle &&
      tooltipStyle == other.tooltipStyle;
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
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
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
    final selectedLabelHeight = MDTextPainter(TextSpan(
      text: '',
      style: xAxisSelectedLabelStyle,
    )).size.height;

    final maxHeight = math.max(labelHeight, selectedLabelHeight);

    return maxHeight + xAxisLabelPadding.vertical;
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
    this.selectedColors,
    this.borderColors,
    this.selectedBorderColors,
    this.border = BarBorder.none,
    this.borderStroke = 0,
    this.zeroBarHeight = 2,
    this.topRadius = 6,
    this.zeroBarTopRadius = 2,
    this.shadowColor,
    this.selectedShadowColor,
    this.shadowElevation = 0,
  });

  /// Width of the bar.
  ///
  /// Defautls to `32`.
  final double width;

  /// List of bar colors.
  ///
  /// **Please note**, that list of colors must contain either 1 color or
  /// quantity that is equal to bar quantity in an item.
  ///
  /// If only 1 color is provided and bar quantity is greater than 1 - every
  /// subsequent bar will be using base color with opacity.
  ///
  /// Defaults to `[Color(0xFFFFFFFF)]`.
  final List<Color> colors;

  /// List of selected bar colors.
  ///
  /// If provided, this colors will be used to paint selected bars, otherwise
  /// [colors] will be used instead.
  ///
  /// **Please note**, that list of colors must contain either 1 color or
  /// quantity that is equal to bar quantity in an item.
  ///
  /// If only 1 color is provided and bar quantity is greater than 1 - every
  /// subsequent bar will be using base color with opacity.
  ///
  /// Defaults to `null`.
  final List<Color>? selectedColors;

  /// List of bar border colors.
  ///
  /// If provided, this colors will be used to paint border over the bars.
  ///
  /// **Please note**, that list of colors must contain either 1 color or
  /// quantity that is equal to bar quantity in an item.
  ///
  /// If only 1 color is provided and bar quantity is greater than 1 - every
  /// subsequent bar will be using base color with opacity.
  ///
  /// **Also note**, that this setting will be ignored if neither
  /// [borderColors] nor [selectedBorderColors] nor [borderStroke] is given.
  ///
  /// Defaults to `null`.
  final List<Color>? borderColors;

  /// List of selected bar border colors.
  ///
  /// If provided, this colors will be used to paint border over the selected
  /// bars.
  ///
  /// **Please note**, that list of colors must contain either 1 color or
  /// quantity that is equal to bar quantity in an item.
  ///
  /// If only 1 color is provided and bar quantity is greater than 1 - every
  /// subsequent bar will be using base color with opacity.
  ///
  /// **Also note**, that this setting will be ignored if neither
  /// [borderColors] nor [selectedBorderColors] nor [borderStroke] is given.
  ///
  /// Defaults to `null`.
  final List<Color>? selectedBorderColors;

  /// Bars borders that should be painted.
  ///
  /// **Please note**, that this setting will be ignored if neither
  /// [borderColors] nor [selectedBorderColors] nor [borderStroke] is given.
  ///
  /// Defaults to [BarBorder.none].
  final BarBorder border;

  /// Stroke of the border.
  ///
  /// **Please note**, that this setting will be ignored if neither
  /// [borderColors] nor [selectedBorderColors] nor [borderStroke] is given.
  ///
  /// Defaults to [0].
  final double borderStroke;

  /// Height of the zero bar.
  ///
  /// It is used to show zero values as a lightly visible bars. But note that
  /// if this value is `"large enough"` it may break charts realism.
  ///
  /// Defaults to `2`.
  final double zeroBarHeight;

  /// Radius of the top part of the bar.
  ///
  /// Defaults to `6`.
  final double topRadius;

  /// Radius of the top part of the zero bar.
  ///
  /// Defaults to `2`.
  final double zeroBarTopRadius;

  /// Color of the shadow.
  ///
  /// **Please note**, that shadow will not be painted in case of absence
  /// of [shadowColor] or [selectedShadowColor] and zero [shadowElevation].
  ///
  /// Defaults to `null`.
  final Color? shadowColor;

  /// Color of the selected bars shadow.
  ///
  /// **Please note**, that shadow will not be painted in case of absence
  /// of [shadowColor] or [selectedShadowColor] and zero [shadowElevation].
  ///
  /// Defaults to `null`.
  final Color? selectedShadowColor;

  /// Elevation of the bar shadow.
  ///
  /// **Please note**, that shadow will not be painted in case of absence
  /// of [shadowColor] or [selectedShadowColor] and zero [shadowElevation].
  ///
  /// Defaults to `0`.
  final double shadowElevation;

  /// Whether zero bars are needed to be shown or not.
  bool get showZeroBars => zeroBarHeight > 0;

  /// Whether bar shadow could to be painted or not.
  bool get canPaintShadow =>
      (shadowColor != null || selectedShadowColor != null) &&
      shadowElevation > 0;

  /// Whether bar border could to be painted or not.
  bool get canPaintBorder =>
      (borderColors != null || selectedBorderColors != null) &&
      borderStroke > 0 &&
      border != BarBorder.none;

  /// Gets a [Paint] for the bar drawing.
  Paint get barPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill;

  /// Gets a [Paint] for the bar border drawing.
  Paint get barBorderPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = borderStroke;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartBarStyle copyWith({
    bool allowNullSelectedColors = false,
    bool allowNullBorderColors = false,
    bool allowNullSelectedBorderColors = false,
    bool allowNullShadowColor = false,
    bool allowNullSelectedShadowColor = false,
    double? width,
    List<Color>? colors,
    List<Color>? selectedColors,
    List<Color>? borderColors,
    List<Color>? selectedBorderColors,
    BarBorder? border,
    double? borderStroke,
    double? zeroBarHeight,
    double? topRadius,
    double? zeroBarTopRadius,
    Color? shadowColor,
    Color? selectedShadowColor,
    double? shadowElevation,
  }) =>
      BarChartBarStyle(
        width: width ?? this.width,
        colors: colors ?? this.colors,
        selectedColors: allowNullSelectedColors
            ? selectedColors
            : selectedColors ?? this.selectedColors,
        borderColors: allowNullBorderColors
            ? borderColors
            : borderColors ?? this.borderColors,
        selectedBorderColors: allowNullSelectedBorderColors
            ? selectedBorderColors
            : selectedBorderColors ?? this.selectedBorderColors,
        border: border ?? this.border,
        borderStroke: borderStroke ?? this.borderStroke,
        zeroBarHeight: zeroBarHeight ?? this.zeroBarHeight,
        topRadius: topRadius ?? this.topRadius,
        zeroBarTopRadius: zeroBarTopRadius ?? this.zeroBarTopRadius,
        shadowColor: allowNullShadowColor
            ? shadowColor
            : shadowColor ?? this.shadowColor,
        selectedShadowColor: allowNullSelectedShadowColor
            ? selectedShadowColor
            : selectedShadowColor ?? this.selectedShadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
      );

  @override
  int get hashCode =>
      width.hashCode ^
      colors.hashCode ^
      selectedColors.hashCode ^
      borderColors.hashCode ^
      selectedBorderColors.hashCode ^
      border.hashCode ^
      borderStroke.hashCode ^
      zeroBarHeight.hashCode ^
      topRadius.hashCode ^
      zeroBarTopRadius.hashCode ^
      shadowColor.hashCode ^
      selectedShadowColor.hashCode ^
      shadowElevation.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartBarStyle &&
      width == other.width &&
      listEquals(colors, other.colors) &&
      listEquals(selectedColors, other.selectedColors) &&
      listEquals(borderColors, other.borderColors) &&
      listEquals(selectedBorderColors, other.selectedBorderColors) &&
      border == other.border &&
      borderStroke == other.borderStroke &&
      zeroBarHeight == other.zeroBarHeight &&
      topRadius == other.topRadius &&
      zeroBarTopRadius == other.zeroBarTopRadius &&
      shadowColor == other.shadowColor &&
      selectedShadowColor == other.selectedShadowColor &&
      shadowElevation == other.shadowElevation;
}

/// Contains various customization options for the tooltip.
class BarChartTooltipStyle {
  /// Constructs an instance of [BarChartTooltipStyle].
  const BarChartTooltipStyle({
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

  /// Gets a [Paint] for the tooltip drawing.
  Paint get tooltipPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = color;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartTooltipStyle copyWith({
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
      BarChartTooltipStyle(
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
      other is BarChartTooltipStyle &&
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

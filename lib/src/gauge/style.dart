// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

/// Contains various customization options for the [GaugeChart].
class GaugeChartStyle {
  /// Constructs an instance of [GaugeChartStyle].
  const GaugeChartStyle({
    this.backgroundStyle = const GaugeChartBackgroundStyle(),
    this.sectionStyle = const GaugeChartSectionStyle(),
  });

  /// Style of the gauge background.
  final GaugeChartBackgroundStyle backgroundStyle;

  /// Style of the section.
  final GaugeChartSectionStyle sectionStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartStyle copyWith({
    GaugeChartBackgroundStyle? backgroundStyle,
    GaugeChartSectionStyle? sectionStyle,
  }) =>
      GaugeChartStyle(
        backgroundStyle: backgroundStyle ?? this.backgroundStyle,
        sectionStyle: sectionStyle ?? this.sectionStyle,
      );

  @override
  int get hashCode => backgroundStyle.hashCode ^ sectionStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartStyle &&
      backgroundStyle == other.backgroundStyle &&
      sectionStyle == other.sectionStyle;
}

/// Contains various customization options for the background of the chart.
class GaugeChartBackgroundStyle {
  /// Constructs an instance of [GaugeChartBackgroundStyle].
  const GaugeChartBackgroundStyle({
    this.color = const Color(0x33FFFFFF),
    this.shadowColor = const Color(0x40000000),
    this.shadowElevation = 4,
    this.borderColor,
    this.borderGradient,
    this.borderStroke = 1,
  });

  /// Color of the gauge background.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Color of the gauge shadow.
  ///
  /// Defaults to `0x40000000`.
  final Color shadowColor;

  /// Elevation of the gauge shadow.
  ///
  /// Defaults to `4`.
  final double shadowElevation;

  /// Border color of the gauge background.
  ///
  /// Defaults to `null`.
  final Color? borderColor;

  /// Border gradient of the gauge background.
  ///
  /// Defaults to `null`.
  final Gradient? borderGradient;

  /// Border stroke (width) of the gauge background.
  ///
  /// Defaults to `1`.
  final double borderStroke;

  /// Gets whether border can be drawn or not.
  bool get borderFilled =>
      borderGradient != null || borderColor != null || borderStroke <= 0;

  /// Gets a [Paint] for the gauge background.
  Paint get backgroundPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 1)
    ..style = PaintingStyle.fill
    ..color = color;

  /// Gets a [Paint] for the border drawing.
  Paint getBorderPaint([Rect? bounds]) {
    assert(borderFilled);
    assert(borderGradient == null && borderColor != null ||
        borderGradient != null && borderColor == null);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = borderStroke;

    if (borderColor != null) {
      paint.color = borderColor!;
    }
    if (borderGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if fillGradient not null',
      );

      paint.shader = borderGradient!.createShader(bounds!);
    }

    return paint;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartBackgroundStyle copyWith({
    bool allowNullBorderColor = false,
    bool allowNullBorderGradient = false,
    Color? color,
    Color? shadowColor,
    double? shadowElevation,
    Color? borderColor,
    Gradient? borderGradient,
    double? borderStroke,
  }) =>
      GaugeChartBackgroundStyle(
        color: color ?? this.color,
        shadowColor: shadowColor ?? this.shadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
        borderColor: allowNullBorderColor
            ? borderColor
            : borderColor ?? this.borderColor,
        borderGradient: allowNullBorderGradient
            ? borderGradient
            : borderGradient ?? this.borderGradient,
        borderStroke: borderStroke ?? this.borderStroke,
      );

  @override
  int get hashCode =>
      color.hashCode ^
      shadowColor.hashCode ^
      shadowElevation.hashCode ^
      borderColor.hashCode ^
      borderGradient.hashCode ^
      borderStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartBackgroundStyle &&
      color == other.color &&
      shadowColor == other.shadowColor &&
      shadowElevation == other.shadowElevation &&
      borderColor == other.borderColor &&
      borderGradient == other.borderGradient &&
      borderStroke == other.borderStroke;
}

/// Contains various customization options for the section of the chart.
class GaugeChartSectionStyle {
  /// Constructs an instance of [GaugeChartSectionStyle].
  const GaugeChartSectionStyle({
    this.colors = const [Color(0x80FFFFFF)],
    this.selectedColor = const Color(0xFFFFFFFF),
    this.selectedBorderColor = const Color(0xFFAAAAAA),
    this.selectedBorderStroke = 4,
  });

  /// Colors of the gauge sections.
  ///
  /// Defaults to `[0x80FFFFFF]`.
  final List<Color> colors;

  /// Color of the selected gauge section.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color selectedColor;

  /// Color of the selected gauge section border.
  ///
  /// Defaults to `0xFFAAAAAA`.
  final Color selectedBorderColor;

  /// Stroke of the selected gauge section border.
  ///
  /// Defaults to `4`.
  final double selectedBorderStroke;

  /// Gets a [Paint] for the gauge section.
  Paint get sectionPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill;

  /// Gets a [Paint] for the selected gauge section.
  Paint get selectedSectionPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = selectedColor;

  /// Gets a [Paint] for the selected gauge section border.
  Paint get selectedSectionBorderPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = selectedBorderColor;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartSectionStyle copyWith({
    List<Color>? colors,
    Color? selectedColor,
    Color? selectedBorderColor,
    double? selectedBorderStroke,
  }) =>
      GaugeChartSectionStyle(
        colors: colors ?? this.colors,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
        selectedBorderStroke: selectedBorderStroke ?? this.selectedBorderStroke,
      );

  @override
  int get hashCode =>
      colors.hashCode ^
      selectedColor.hashCode ^
      selectedBorderColor.hashCode ^
      selectedBorderStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartSectionStyle &&
      colors == other.colors &&
      selectedColor == other.selectedColor &&
      selectedBorderColor == other.selectedBorderColor &&
      selectedBorderStroke == other.selectedBorderStroke;
}

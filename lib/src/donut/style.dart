// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

/// Contains various customization options for the [DonutChart].
class DonutChartStyle {
  /// Constructs an instance of [DonutChartStyle].
  const DonutChartStyle({
    this.backgroundStyle = const DonutChartBackgroundStyle(),
    this.sectionStyle = const DonutChartSectionStyle(),
  });

  /// Style of the donut background.
  final DonutChartBackgroundStyle backgroundStyle;

  /// Style of the section.
  final DonutChartSectionStyle sectionStyle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DonutChartStyle copyWith({
    DonutChartBackgroundStyle? backgroundStyle,
    DonutChartSectionStyle? sectionStyle,
  }) =>
      DonutChartStyle(
        backgroundStyle: backgroundStyle ?? this.backgroundStyle,
        sectionStyle: sectionStyle ?? this.sectionStyle,
      );

  @override
  int get hashCode => backgroundStyle.hashCode ^ sectionStyle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DonutChartStyle &&
      backgroundStyle == other.backgroundStyle &&
      sectionStyle == other.sectionStyle;
}

/// Contains various customization options for the background of the chart.
class DonutChartBackgroundStyle {
  /// Constructs an instance of [DonutChartBackgroundStyle].
  const DonutChartBackgroundStyle({
    this.color = const Color(0x33FFFFFF),
    this.shadowColor = const Color(0x40000000),
    this.shadowElevation = 4,
    this.innerBorderColor,
    this.innerBorderGradient,
    this.innerBorderStroke = 1,
    this.outerBorderColor,
    this.outerBorderGradient,
    this.outerBorderStroke = 1,
  });

  /// Color of the donut background.
  ///
  /// Defaults to `0x33FFFFFF`.
  final Color color;

  /// Color of the donut shadow.
  ///
  /// Defaults to `0x40000000`.
  final Color shadowColor;

  /// Elevation of the donut shadow.
  ///
  /// Defaults to `4`.
  final double shadowElevation;

  /// Inner border color of the donut section.
  ///
  /// Defaults to `null`.
  final Color? innerBorderColor;

  /// Inner border gradient of the donut section.
  ///
  /// Defaults to `null`.
  final Gradient? innerBorderGradient;

  /// Inner border stroke (width) of the donut section.
  ///
  /// Defaults to `1`.
  final double innerBorderStroke;

  /// Outer border color of the donut section.
  ///
  /// Defaults to `null`.
  final Color? outerBorderColor;

  /// Outer border gradient of the donut section.
  ///
  /// Defaults to `null`.
  final Gradient? outerBorderGradient;

  /// Outer border stroke (width) of the donut section.
  ///
  /// Defaults to `1`.
  final double outerBorderStroke;

  bool get hasInnerBorder =>
      (innerBorderColor != null || innerBorderGradient != null) &&
      innerBorderStroke > 0;

  bool get hasOuterBorder =>
      (outerBorderColor != null || outerBorderGradient != null) &&
      outerBorderStroke > 0;

  /// Gets a [Paint] for the donut background.
  Paint get backgroundPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 1)
    ..style = PaintingStyle.fill
    ..color = color;

  /// Gets a [Paint] for the inner border drawing.
  Paint getInnerBorderPaint([Rect? bounds]) {
    assert(hasInnerBorder);
    assert(innerBorderGradient == null && innerBorderColor != null ||
        innerBorderGradient != null && innerBorderColor == null);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square
      ..strokeWidth = innerBorderStroke;

    if (innerBorderColor != null) {
      paint.color = innerBorderColor!;
    }
    if (innerBorderGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if innerBorderGradient not null',
      );

      paint.shader = innerBorderGradient!.createShader(bounds!);
    }

    return paint;
  }

  /// Gets a [Paint] for the outer border drawing.
  Paint getOuterBorderPaint([Rect? bounds]) {
    assert(hasOuterBorder);
    assert(outerBorderGradient == null && outerBorderColor != null ||
        outerBorderGradient != null && outerBorderColor == null);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square
      ..strokeWidth = outerBorderStroke;

    if (outerBorderColor != null) {
      paint.color = outerBorderColor!;
    }
    if (outerBorderGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if outerBorderGradient not null',
      );

      paint.shader = outerBorderGradient!.createShader(bounds!);
    }

    return paint;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DonutChartBackgroundStyle copyWith({
    Color? color,
    Color? shadowColor,
    double? shadowElevation,
    Color? innerBorderColor,
    Gradient? innerBorderGradient,
    double? innerBorderStroke,
    Color? outerBorderColor,
    Gradient? outerBorderGradient,
    double? outerBorderStroke,
  }) =>
      DonutChartBackgroundStyle(
        color: color ?? this.color,
        shadowColor: shadowColor ?? this.shadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
        innerBorderColor: innerBorderColor ?? this.innerBorderColor,
        innerBorderGradient: innerBorderGradient ?? this.innerBorderGradient,
        innerBorderStroke: innerBorderStroke ?? this.innerBorderStroke,
        outerBorderColor: outerBorderColor ?? this.outerBorderColor,
        outerBorderGradient: outerBorderGradient ?? this.outerBorderGradient,
        outerBorderStroke: outerBorderStroke ?? this.outerBorderStroke,
      );

  @override
  int get hashCode =>
      color.hashCode ^
      shadowColor.hashCode ^
      shadowElevation.hashCode ^
      innerBorderColor.hashCode ^
      innerBorderGradient.hashCode ^
      innerBorderStroke.hashCode ^
      outerBorderColor.hashCode ^
      outerBorderGradient.hashCode ^
      outerBorderStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DonutChartBackgroundStyle &&
      color == other.color &&
      shadowColor == other.shadowColor &&
      shadowElevation == other.shadowElevation &&
      innerBorderColor == other.innerBorderColor &&
      innerBorderGradient == other.innerBorderGradient &&
      innerBorderStroke == other.innerBorderStroke &&
      outerBorderColor == other.outerBorderColor &&
      outerBorderGradient == other.outerBorderGradient &&
      outerBorderStroke == other.outerBorderStroke;
}

/// Contains various customization options for the section of the chart.
class DonutChartSectionStyle {
  /// Constructs an instance of [DonutChartSectionStyle].
  const DonutChartSectionStyle({
    this.colors = const [Color(0x80FFFFFF)],
    this.selectedColor = const Color(0xFFFFFFFF),
    this.selectedInnerBorderColor,
    this.selectedInnerBorderGradient,
    this.selectedInnerBorderStroke = 1,
    this.selectedOuterBorderColor,
    this.selectedOuterBorderGradient,
    this.selectedOuterBorderStroke = 1,
  });

  /// Colors of the donut sections.
  ///
  /// Defaults to `[0x80FFFFFF]`.
  final List<Color> colors;

  /// Color of the selected donut section.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color selectedColor;

  /// Inner border color of the selected donut section.
  ///
  /// Defaults to `null`.
  final Color? selectedInnerBorderColor;

  /// Inner border gradient of the selected donut section.
  ///
  /// Defaults to `null`.
  final Gradient? selectedInnerBorderGradient;

  /// Inner border stroke (width) of the selected donut section.
  ///
  /// Defaults to `1`.
  final double selectedInnerBorderStroke;

  /// Outer border color of the selected donut section.
  ///
  /// Defaults to `null`.
  final Color? selectedOuterBorderColor;

  /// Outer border gradient of the selected donut section.
  ///
  /// Defaults to `null`.
  final Gradient? selectedOuterBorderGradient;

  /// Outer border stroke (width) of the selected donut section.
  ///
  /// Defaults to `1`.
  final double selectedOuterBorderStroke;

  bool get hasSelectedInnerBorder =>
      (selectedInnerBorderColor != null ||
          selectedInnerBorderGradient != null) &&
      selectedInnerBorderStroke > 0;

  bool get hasSelectedOuterBorder =>
      (selectedOuterBorderColor != null ||
          selectedOuterBorderGradient != null) &&
      selectedOuterBorderStroke > 0;

  /// Gets a [Paint] for the donut section.
  Paint get sectionPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill;

  /// Gets a [Paint] for the selected donut section.
  Paint get selectedSectionPaint => Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.medium
    ..style = PaintingStyle.fill
    ..color = selectedColor;

  /// Gets a [Paint] for the selected inner border drawing.
  Paint getSelectedInnerBorderPaint([Rect? bounds]) {
    assert(hasSelectedInnerBorder);
    assert(selectedInnerBorderGradient == null &&
            selectedInnerBorderColor != null ||
        selectedInnerBorderGradient != null &&
            selectedInnerBorderColor == null);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square
      ..strokeWidth = selectedInnerBorderStroke;

    if (selectedInnerBorderColor != null) {
      paint.color = selectedInnerBorderColor!;
    }
    if (selectedInnerBorderGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if selectedInnerBorderGradient not null',
      );

      paint.shader = selectedInnerBorderGradient!.createShader(bounds!);
    }

    return paint;
  }

  /// Gets a [Paint] for the selected outer border drawing.
  Paint getSelectedOuterBorderPaint([Rect? bounds]) {
    assert(hasSelectedOuterBorder);
    assert(selectedOuterBorderGradient == null &&
            selectedOuterBorderColor != null ||
        selectedOuterBorderGradient != null &&
            selectedOuterBorderColor == null);

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square
      ..strokeWidth = selectedOuterBorderStroke;

    if (selectedOuterBorderColor != null) {
      paint.color = selectedOuterBorderColor!;
    }
    if (selectedOuterBorderGradient != null) {
      assert(
        bounds != null,
        'bounds must not be null if selectedOuterBorderGradient not null',
      );

      paint.shader = selectedOuterBorderGradient!.createShader(bounds!);
    }

    return paint;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DonutChartSectionStyle copyWith({
    List<Color>? colors,
    Color? selectedColor,
    Color? selectedInnerBorderColor,
    Gradient? selectedInnerBorderGradient,
    double? selectedInnerBorderStroke,
    Color? selectedOuterBorderColor,
    Gradient? selectedOuterBorderGradient,
    double? selectedOuterBorderStroke,
  }) =>
      DonutChartSectionStyle(
        colors: colors ?? this.colors,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedInnerBorderColor:
            selectedInnerBorderColor ?? this.selectedInnerBorderColor,
        selectedInnerBorderGradient:
            selectedInnerBorderGradient ?? this.selectedInnerBorderGradient,
        selectedInnerBorderStroke:
            selectedInnerBorderStroke ?? this.selectedInnerBorderStroke,
        selectedOuterBorderColor:
            selectedOuterBorderColor ?? this.selectedOuterBorderColor,
        selectedOuterBorderGradient:
            selectedOuterBorderGradient ?? this.selectedOuterBorderGradient,
        selectedOuterBorderStroke:
            selectedOuterBorderStroke ?? this.selectedOuterBorderStroke,
      );

  @override
  int get hashCode =>
      colors.hashCode ^
      selectedColor.hashCode ^
      selectedInnerBorderColor.hashCode ^
      selectedInnerBorderGradient.hashCode ^
      selectedInnerBorderStroke.hashCode ^
      selectedOuterBorderColor.hashCode ^
      selectedOuterBorderGradient.hashCode ^
      selectedOuterBorderStroke.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DonutChartSectionStyle &&
      colors == other.colors &&
      selectedColor == other.selectedColor &&
      selectedInnerBorderColor == other.selectedInnerBorderColor &&
      selectedInnerBorderGradient == other.selectedInnerBorderGradient &&
      selectedInnerBorderStroke == other.selectedInnerBorderStroke &&
      selectedOuterBorderColor == other.selectedOuterBorderColor &&
      selectedOuterBorderGradient == other.selectedOuterBorderGradient &&
      selectedOuterBorderStroke == other.selectedOuterBorderStroke;
}

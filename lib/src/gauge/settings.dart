// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Set of settings of the [GaugeChart].
class GaugeChartSettings {
  /// Constructs an instance of [GaugeChartSettings].
  const GaugeChartSettings({
    this.colorPattern,
    this.sectionStroke = 30,
    this.gaugeAngle = 180,
  }) : assert(gaugeAngle >= 0 && gaugeAngle <= 360);

  /// Pattern which colors will respect while getting from [colors] field.
  ///
  /// Defaults to `null`.
  final List<int>? colorPattern;

  /// Stroke (width/size) of the gauge section.
  ///
  /// Defaults to `30`.
  final double sectionStroke;

  /// Angle of gauge.
  ///
  /// Defaults to `180`°.
  ///
  /// **Please note**: this value must be in range `[0..360]`, otherwise error
  /// [AssertionError] will be thrown.
  final double gaugeAngle;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartSettings copyWith({
    bool allowNullColorPattern = false,
    List<int>? colorPattern,
    double? sectionStroke,
    double? gaugeAngle,
  }) =>
      GaugeChartSettings(
        colorPattern: allowNullColorPattern
            ? colorPattern
            : colorPattern ?? this.colorPattern,
        sectionStroke: sectionStroke ?? this.sectionStroke,
        gaugeAngle: gaugeAngle ?? this.gaugeAngle,
      );

  @override
  int get hashCode =>
      colorPattern.hashCode ^ sectionStroke.hashCode ^ gaugeAngle.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartSettings &&
      colorPattern == other.colorPattern &&
      sectionStroke == other.sectionStroke &&
      gaugeAngle == other.gaugeAngle;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

/// Set of settings of the [GaugeChart].
class GaugeChartSettings {
  /// Constructs an instance of [GaugeChartSettings].
  const GaugeChartSettings({
    this.colorPattern,
    this.sectionStroke = 30,
    this.selectedSectionStroke = 38,
    this.gaugeAngle = 180,
    this.debugMode = false,
    this.selectionEnabled = true,
    this.behavior = HitTestBehavior.deferToChild,
  }) : assert(gaugeAngle >= 0 && gaugeAngle <= 360);

  /// Pattern which colors will respect while getting from [colors] field.
  ///
  /// Defaults to `null`.
  final List<int>? colorPattern;

  /// Stroke (width/size) of the gauge section.
  ///
  /// Defaults to `30`.
  final double sectionStroke;

  /// Stroke (width/size) of the selected gauge section.
  ///
  /// Defaults to `38`.
  final double selectedSectionStroke;

  /// Angle of gauge.
  ///
  /// Defaults to `180`°.
  ///
  /// **Please note**: this value must be in range `[0..360]`, otherwise error
  /// [AssertionError] will be thrown.
  final double gaugeAngle;

  /// Whether debug mode is enabled or not.
  ///
  /// Defaults to `false`.
  final bool debugMode;

  /// Whether interactive section selection is enabled or not.
  ///
  /// Defaults to `true`.
  final bool selectionEnabled;

  /// How this chart should behave during hit testing.
  ///
  /// This defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior behavior;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartSettings copyWith({
    bool allowNullColorPattern = false,
    List<int>? colorPattern,
    double? sectionStroke,
    double? selectedSectionStroke,
    double? gaugeAngle,
    bool? debugMode,
    bool? selectionEnabled,
    HitTestBehavior? behavior,
  }) =>
      GaugeChartSettings(
        colorPattern: allowNullColorPattern
            ? colorPattern
            : colorPattern ?? this.colorPattern,
        sectionStroke: sectionStroke ?? this.sectionStroke,
        selectedSectionStroke:
            selectedSectionStroke ?? this.selectedSectionStroke,
        gaugeAngle: gaugeAngle ?? this.gaugeAngle,
        debugMode: debugMode ?? this.debugMode,
        selectionEnabled: selectionEnabled ?? this.selectionEnabled,
        behavior: behavior ?? this.behavior,
      );

  @override
  int get hashCode =>
      colorPattern.hashCode ^
      sectionStroke.hashCode ^
      selectedSectionStroke.hashCode ^
      gaugeAngle.hashCode ^
      debugMode.hashCode ^
      selectionEnabled.hashCode ^
      behavior.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartSettings &&
      colorPattern == other.colorPattern &&
      sectionStroke == other.sectionStroke &&
      selectedSectionStroke == other.selectedSectionStroke &&
      gaugeAngle == other.gaugeAngle &&
      debugMode == other.debugMode &&
      selectionEnabled == other.selectionEnabled &&
      behavior == other.behavior;
}

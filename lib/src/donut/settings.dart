// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

/// Set of settings of the [DonutChart].
class DonutChartSettings {
  /// Constructs an instance of [DonutChartSettings].
  const DonutChartSettings({
    this.colorPattern,
    this.sectionStroke = 30,
    this.selectedSectionStroke = 38,
    this.debugMode = false,
    this.selectionEnabled = true,
    this.behavior = HitTestBehavior.deferToChild,
    this.runInitialAnimation = false,
  });

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

  /// Whether to show initial selection animation or not.
  ///
  /// Defaults to `false`.
  final bool runInitialAnimation;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DonutChartSettings copyWith({
    bool allowNullColorPattern = false,
    List<int>? colorPattern,
    double? sectionStroke,
    double? selectedSectionStroke,
    double? gaugeAngle,
    bool? debugMode,
    bool? selectionEnabled,
    HitTestBehavior? behavior,
    bool? runInitialAnimation,
  }) =>
      DonutChartSettings(
        colorPattern: allowNullColorPattern
            ? colorPattern
            : colorPattern ?? this.colorPattern,
        sectionStroke: sectionStroke ?? this.sectionStroke,
        selectedSectionStroke:
            selectedSectionStroke ?? this.selectedSectionStroke,
        debugMode: debugMode ?? this.debugMode,
        selectionEnabled: selectionEnabled ?? this.selectionEnabled,
        behavior: behavior ?? this.behavior,
        runInitialAnimation: runInitialAnimation ?? this.runInitialAnimation,
      );

  @override
  int get hashCode =>
      colorPattern.hashCode ^
      sectionStroke.hashCode ^
      selectedSectionStroke.hashCode ^
      debugMode.hashCode ^
      selectionEnabled.hashCode ^
      behavior.hashCode ^
      runInitialAnimation.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DonutChartSettings &&
      colorPattern == other.colorPattern &&
      sectionStroke == other.sectionStroke &&
      selectedSectionStroke == other.selectedSectionStroke &&
      debugMode == other.debugMode &&
      selectionEnabled == other.selectionEnabled &&
      behavior == other.behavior &&
      runInitialAnimation == other.runInitialAnimation;
}

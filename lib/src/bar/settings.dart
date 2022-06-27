// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../common.dart';

/// Alignment of the bars within chart.
///
/// Note that alignment will be used only if total bar width is less the paint
/// zone (if no scroll is present).
enum BarAlignment {
  /// Bars will be placed at the start (left side) of the chart zone.
  start,

  /// Bars will be placed at the center of the chart zone.
  center,

  /// Bars will be placed at the end (right side) of the chart zone.
  end,
}

/// Set of settings of the [BarChart].
class BarChartSettings {
  /// Constructs an instance of [BarChartSettings].
  const BarChartSettings({
    this.yAxisDivisions = 2,
    this.axisDivisionEdges = AxisDivisionEdges.none,
    this.showAxisX = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.barSpacing = 0,
    this.itemSpacing = 12,
    this.showSelection = true,
    this.duration = const Duration(milliseconds: 400),
    this.alignment = BarAlignment.end,
    this.reverse = false,
  });

  /// Constructs an instance of [BarChartSettings] without grids.
  const BarChartSettings.gridless({
    this.showAxisX = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.barSpacing = 0,
    this.itemSpacing = 12,
    this.showSelection = true,
    this.duration = const Duration(milliseconds: 400),
    this.alignment = BarAlignment.end,
    this.reverse = false,
  })  : yAxisDivisions = 0,
        axisDivisionEdges = AxisDivisionEdges.none;

  /// Divisions of the Y axis or the quantity of the grid lines on Y axis.
  ///
  /// Defaults to `2` for basic constructor.
  ///
  /// **Note**: to prevent from displaying only Y axis - set
  /// [xAxisDivisions] to `0`, so Y axis will not be painted, but X axis will.
  ///
  /// **Note**: to prevent from displaying entire grid set both [xAxisDivisions]
  /// and [yAxisDivisions] to `0` or consider using [BarChartSettings.gridless]
  /// constructor.
  final int yAxisDivisions;

  /// Axis division edges to be painted.
  ///
  /// Defaults to [AxisDivisionEdges.none].
  final AxisDivisionEdges axisDivisionEdges;

  /// Whether to show X axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisX;

  /// Whether to show X axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisXLabels;

  /// Whether to show Y axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisYLabels;

  /// Spacing between bars in one item.
  ///
  /// If positive value is set - bars will be painted with a given indent.
  /// If negative value is set - bars will be painted with overlapping on each
  /// other with a given indent.
  ///
  /// Defaults to `0`.
  final double barSpacing;

  /// Spacing between group of bars.
  ///
  /// Defaults to `12`.
  final double itemSpacing;

  /// Whether to show selection of the items or not.
  ///
  /// Defaults to `true`.
  final bool showSelection;

  /// The length of time animation should last.
  ///
  /// To disable animation - [Duration.zero] could be passed.
  final Duration duration;

  /// Alignment of the bars within chart.
  ///
  /// Defaults to [BarAlignment.end].
  ///
  /// Note that alignment will be used only if total bar width is less the paint
  /// zone (if no scroll is present).
  final BarAlignment alignment;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right, then the scroll
  /// view scrolls from left to right when [reverse] is `false` and from right
  /// to left when [reverse] is `true`.
  ///
  /// Defaults to `false`.
  final bool reverse;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartSettings copyWith({
    int? yAxisDivisions,
    AxisDivisionEdges? axisDivisionEdges,
    bool? showAxisX,
    bool? showAxisXLabels,
    bool? showAxisYLabels,
    double? barSpacing,
    double? itemSpacing,
    bool? showSelection,
    Duration? duration,
    BarAlignment? alignment,
    bool? reverse,
  }) =>
      BarChartSettings(
        yAxisDivisions: yAxisDivisions ?? this.yAxisDivisions,
        axisDivisionEdges: axisDivisionEdges ?? this.axisDivisionEdges,
        showAxisX: showAxisX ?? this.showAxisX,
        showAxisXLabels: showAxisXLabels ?? this.showAxisXLabels,
        showAxisYLabels: showAxisYLabels ?? this.showAxisYLabels,
        barSpacing: barSpacing ?? this.barSpacing,
        itemSpacing: itemSpacing ?? this.itemSpacing,
        showSelection: showSelection ?? this.showSelection,
        duration: duration ?? this.duration,
        alignment: alignment ?? this.alignment,
        reverse: reverse ?? this.reverse,
      );

  @override
  int get hashCode =>
      yAxisDivisions.hashCode ^
      axisDivisionEdges.hashCode ^
      showAxisX.hashCode ^
      showAxisXLabels.hashCode ^
      showAxisYLabels.hashCode ^
      barSpacing.hashCode ^
      itemSpacing.hashCode ^
      showSelection.hashCode ^
      duration.hashCode ^
      alignment.hashCode ^
      reverse.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartSettings &&
      yAxisDivisions == other.yAxisDivisions &&
      axisDivisionEdges == other.axisDivisionEdges &&
      showAxisX == other.showAxisX &&
      showAxisXLabels == other.showAxisXLabels &&
      showAxisYLabels == other.showAxisYLabels &&
      barSpacing == other.barSpacing &&
      itemSpacing == other.itemSpacing &&
      showSelection == other.showSelection &&
      duration == other.duration &&
      alignment == other.alignment &&
      reverse == other.reverse;
}

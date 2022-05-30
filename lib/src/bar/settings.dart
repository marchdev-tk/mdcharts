// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../common.dart';

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
  });

  /// Constructs an instance of [BarChartSettings] without grids.
  const BarChartSettings.gridless({
    this.showAxisX = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.barSpacing = 0,
    this.itemSpacing = 12,
    this.showSelection = true,
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
      showSelection.hashCode;

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
      showSelection == other.showSelection;
}

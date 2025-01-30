// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mdcharts/src/_internal.dart';

/// Set of settings of the [GridAxis].
class GridAxisSettings {
  /// Constructs an instance of [GridAxisSettings].
  const GridAxisSettings({
    this.defaultDivisionInterval = 100,
    this.xAxisDivisions = 3,
    this.yAxisDivisions = 2,
    this.xAxisLabelQuantity,
    this.axisDivisionEdges = AxisDivisionEdges.none,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisY = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showAxisXLabelSelection = false,
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisBaseline = YAxisBaseline.zero,
    this.yAxisLabelSpacing = 0,
    this.showZeroLine = false,
    this.showDropLine = true,
    this.showTooltip = true,
  }) : assert(defaultDivisionInterval > 0);

  /// Constructs an instance of [GridAxisSettings] without grids.
  const GridAxisSettings.gridless({
    this.defaultDivisionInterval = 100,
    this.xAxisLabelQuantity,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisY = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showAxisXLabelSelection = false,
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisBaseline = YAxisBaseline.zero,
    this.yAxisLabelSpacing = 0,
    this.showZeroLine = false,
    this.showDropLine = true,
    this.showTooltip = true,
  })  : assert(defaultDivisionInterval > 0),
        xAxisDivisions = 0,
        yAxisDivisions = 0,
        axisDivisionEdges = AxisDivisionEdges.none;

  /// Default value of the interval between divisions of the Y axis.
  ///
  /// Defaults to `100`.
  ///
  /// **Note**: value must be greater than `0`.
  final double defaultDivisionInterval;

  /// Divisions of the X axis or the quantity of the grid lines on X axis.
  ///
  /// Defaults to `3` for basic constructor.
  ///
  /// **Note**: to prevent from displaying only X axis - set
  /// [xAxisDivisions] to `0`, so X axis will not be painted, but Y axis will.
  ///
  /// **Note**: to prevent from displaying entire grid set both [xAxisDivisions]
  /// and [yAxisDivisions] to `0` or consider using [GridAxisSettings.gridless]
  /// constructor.
  final int xAxisDivisions;

  /// Divisions of the Y axis or the quantity of the grid lines on Y axis.
  ///
  /// Defaults to `2` for basic constructor.
  ///
  /// **Note**: to prevent from displaying only Y axis - set
  /// [xAxisDivisions] to `0`, so Y axis will not be painted, but X axis will.
  ///
  /// **Note**: to prevent from displaying entire grid set both [xAxisDivisions]
  /// and [yAxisDivisions] to `0` or consider using [GridAxisSettings.gridless]
  /// constructor.
  final int yAxisDivisions;

  /// Quantity of the X axis labels to draw.
  ///
  /// Defaults to `null`.
  ///
  /// If X axis label quantity is set - it could be less than or equal to a
  /// specified value, but no less than `2`.
  ///
  /// **Note**: that X axis labels are dynamically displaying beneath X axis
  /// based on width that they occupy and available drawing space.
  final int? xAxisLabelQuantity;

  /// Axis division edges to be painted.
  ///
  /// Defaults to [AxisDivisionEdges.none].
  final AxisDivisionEdges axisDivisionEdges;

  /// Whether to show X axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisX;

  /// Whether to show X axis labels or not if [xAxisLabelQuantity] is set and
  /// label is concealed in normal circumstances.
  ///
  /// Defaults to `false`.
  final bool showAxisXSelectedLabelIfConcealed;

  /// Whether to show Y axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisY;

  /// Whether to show X axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisXLabels;

  /// Whether to show Y axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisYLabels;

  /// Whether to paint with selected style currently selected X axis label or
  /// not.
  ///
  /// Defaults to `false`.
  final bool showAxisXLabelSelection;

  /// Layout type of the Y axis labels.
  ///
  /// Defaults to [YAxisLayout.overlay].
  final YAxisLayout yAxisLayout;

  /// Baseline of the Y axis label values.
  ///
  /// Defaults to [YAxisBaseline.zero].
  final YAxisBaseline yAxisBaseline;

  /// Spacing between the Y axis labels and chart itself.
  ///
  /// **Please note**, that this setting affects spacing only in case of
  /// [yAxisLayout] is set to [YAxisLayout.displace], otherwise it does nothing.
  ///
  /// Defaults to `0`.
  final double yAxisLabelSpacing;

  /// Wether to show zero line or not.
  ///
  /// Defaults to `false`.
  final bool showZeroLine;

  /// Whether to show drop lines beneath the selected item or not.
  ///
  /// Defaults to `true`.
  final bool showDropLine;

  /// Whether to show tooltip over the selected item or not.
  ///
  /// Defaults to `true`.
  final bool showTooltip;

  /// Whether a chart is gridless or not.
  bool get isGridless =>
      xAxisDivisions == 0 &&
      yAxisDivisions == 0 &&
      axisDivisionEdges == AxisDivisionEdges.none;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GridAxisSettings copyWith({
    bool allowNullXAxisLabelQuantity = false,
    double? defaultDivisionInterval,
    int? xAxisDivisions,
    int? yAxisDivisions,
    int? xAxisLabelQuantity,
    AxisDivisionEdges? axisDivisionEdges,
    bool? showAxisX,
    bool? showAxisXSelectedLabelIfConcealed,
    bool? showAxisY,
    bool? showAxisXLabels,
    bool? showAxisYLabels,
    bool? showAxisXLabelSelection,
    YAxisLayout? yAxisLayout,
    YAxisBaseline? yAxisBaseline,
    double? yAxisLabelSpacing,
    bool? showZeroLine,
    bool? showDropLine,
    bool? showTooltip,
  }) =>
      GridAxisSettings(
        defaultDivisionInterval:
            defaultDivisionInterval ?? this.defaultDivisionInterval,
        xAxisDivisions: xAxisDivisions ?? this.xAxisDivisions,
        yAxisDivisions: yAxisDivisions ?? this.yAxisDivisions,
        xAxisLabelQuantity: allowNullXAxisLabelQuantity
            ? xAxisLabelQuantity
            : xAxisLabelQuantity ?? this.xAxisLabelQuantity,
        axisDivisionEdges: axisDivisionEdges ?? this.axisDivisionEdges,
        showAxisX: showAxisX ?? this.showAxisX,
        showAxisXSelectedLabelIfConcealed: showAxisXSelectedLabelIfConcealed ??
            this.showAxisXSelectedLabelIfConcealed,
        showAxisY: showAxisY ?? this.showAxisY,
        showAxisXLabels: showAxisXLabels ?? this.showAxisXLabels,
        showAxisYLabels: showAxisYLabels ?? this.showAxisYLabels,
        showAxisXLabelSelection:
            showAxisXLabelSelection ?? this.showAxisXLabelSelection,
        yAxisLayout: yAxisLayout ?? this.yAxisLayout,
        yAxisBaseline: yAxisBaseline ?? this.yAxisBaseline,
        yAxisLabelSpacing: yAxisLabelSpacing ?? this.yAxisLabelSpacing,
        showZeroLine: showZeroLine ?? this.showZeroLine,
        showDropLine: showDropLine ?? this.showDropLine,
        showTooltip: showTooltip ?? this.showTooltip,
      );

  @override
  int get hashCode =>
      defaultDivisionInterval.hashCode ^
      xAxisDivisions.hashCode ^
      yAxisDivisions.hashCode ^
      xAxisLabelQuantity.hashCode ^
      axisDivisionEdges.hashCode ^
      showAxisX.hashCode ^
      showAxisXSelectedLabelIfConcealed.hashCode ^
      showAxisY.hashCode ^
      showAxisXLabels.hashCode ^
      showAxisYLabels.hashCode ^
      showAxisXLabelSelection.hashCode ^
      yAxisLayout.hashCode ^
      yAxisBaseline.hashCode ^
      yAxisLabelSpacing.hashCode ^
      showZeroLine.hashCode ^
      showDropLine.hashCode ^
      showTooltip.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GridAxisSettings &&
      defaultDivisionInterval == other.defaultDivisionInterval &&
      xAxisDivisions == other.xAxisDivisions &&
      yAxisDivisions == other.yAxisDivisions &&
      xAxisLabelQuantity == other.xAxisLabelQuantity &&
      axisDivisionEdges == other.axisDivisionEdges &&
      showAxisX == other.showAxisX &&
      showAxisXSelectedLabelIfConcealed ==
          other.showAxisXSelectedLabelIfConcealed &&
      showAxisY == other.showAxisY &&
      showAxisXLabels == other.showAxisXLabels &&
      showAxisYLabels == other.showAxisYLabels &&
      showAxisXLabelSelection == other.showAxisXLabelSelection &&
      yAxisLayout == other.yAxisLayout &&
      yAxisBaseline == other.yAxisBaseline &&
      yAxisLabelSpacing == other.yAxisLabelSpacing &&
      showZeroLine == other.showZeroLine &&
      showDropLine == other.showDropLine &&
      showTooltip == other.showTooltip;
}

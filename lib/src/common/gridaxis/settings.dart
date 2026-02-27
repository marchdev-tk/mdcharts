// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
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
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisBaseline = YAxisBaseline.zero,
    this.yAxisLabelSpacing = 0,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisXLabelSelection = false,
    this.showAxisY = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showZeroLine = false,
    this.showAxisXDropLine = true,
    this.showAxisYDropLine = true,
    this.showTooltip = true,
  }) : assert(defaultDivisionInterval > 0);

  /// Constructs an instance of [GridAxisSettings] without grids.
  const GridAxisSettings.gridless({
    this.defaultDivisionInterval = 100,
    this.xAxisLabelQuantity,
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisBaseline = YAxisBaseline.zero,
    this.yAxisLabelSpacing = 0,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisXLabelSelection = false,
    this.showAxisY = true,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showZeroLine = false,
    this.showAxisXDropLine = true,
    this.showAxisYDropLine = true,
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

  /// Whether to show X axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisX;

  /// Whether to show X axis labels or not if [xAxisLabelQuantity] is set and
  /// label is concealed in normal circumstances.
  ///
  /// Defaults to `false`.
  final bool showAxisXSelectedLabelIfConcealed;

  /// Whether to paint with selected style currently selected X axis label or
  /// not.
  ///
  /// Defaults to `false`.
  final bool showAxisXLabelSelection;

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

  /// Wether to show zero line or not.
  ///
  /// Defaults to `false`.
  final bool showZeroLine;

  /// Whether to X axis show drop lines beneath the selected item or not.
  ///
  /// Defaults to `true`.
  final bool showAxisXDropLine;

  /// Whether to show Y axis drop lines beneath the selected item or not.
  ///
  /// Defaults to `true`.
  final bool showAxisYDropLine;

  /// Whether to show tooltip over the selected item or not.
  ///
  /// Defaults to `true`.
  final bool showTooltip;

  /// Whether a chart is has drop line or not.
  bool get showDropLine => showAxisXDropLine || showAxisYDropLine;

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
    YAxisLayout? yAxisLayout,
    YAxisBaseline? yAxisBaseline,
    double? yAxisLabelSpacing,
    bool? showAxisX,
    bool? showAxisXSelectedLabelIfConcealed,
    bool? showAxisXLabelSelection,
    bool? showAxisY,
    bool? showAxisXLabels,
    bool? showAxisYLabels,
    bool? showZeroLine,
    bool? showAxisXDropLine,
    bool? showAxisYDropLine,
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
        yAxisLayout: yAxisLayout ?? this.yAxisLayout,
        yAxisBaseline: yAxisBaseline ?? this.yAxisBaseline,
        yAxisLabelSpacing: yAxisLabelSpacing ?? this.yAxisLabelSpacing,
        showAxisX: showAxisX ?? this.showAxisX,
        showAxisXSelectedLabelIfConcealed: showAxisXSelectedLabelIfConcealed ??
            this.showAxisXSelectedLabelIfConcealed,
        showAxisXLabelSelection:
            showAxisXLabelSelection ?? this.showAxisXLabelSelection,
        showAxisY: showAxisY ?? this.showAxisY,
        showAxisXLabels: showAxisXLabels ?? this.showAxisXLabels,
        showAxisYLabels: showAxisYLabels ?? this.showAxisYLabels,
        showZeroLine: showZeroLine ?? this.showZeroLine,
        showAxisXDropLine: showAxisXDropLine ?? this.showAxisXDropLine,
        showAxisYDropLine: showAxisYDropLine ?? this.showAxisYDropLine,
        showTooltip: showTooltip ?? this.showTooltip,
      );

  @override
  int get hashCode =>
      defaultDivisionInterval.hashCode ^
      xAxisDivisions.hashCode ^
      yAxisDivisions.hashCode ^
      xAxisLabelQuantity.hashCode ^
      axisDivisionEdges.hashCode ^
      yAxisLayout.hashCode ^
      yAxisBaseline.hashCode ^
      yAxisLabelSpacing.hashCode ^
      showAxisX.hashCode ^
      showAxisXSelectedLabelIfConcealed.hashCode ^
      showAxisXLabelSelection.hashCode ^
      showAxisY.hashCode ^
      showAxisXLabels.hashCode ^
      showAxisYLabels.hashCode ^
      showZeroLine.hashCode ^
      showAxisXDropLine.hashCode ^
      showAxisYDropLine.hashCode ^
      showTooltip.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GridAxisSettings &&
      defaultDivisionInterval == other.defaultDivisionInterval &&
      xAxisDivisions == other.xAxisDivisions &&
      yAxisDivisions == other.yAxisDivisions &&
      xAxisLabelQuantity == other.xAxisLabelQuantity &&
      axisDivisionEdges == other.axisDivisionEdges &&
      yAxisLayout == other.yAxisLayout &&
      yAxisBaseline == other.yAxisBaseline &&
      yAxisLabelSpacing == other.yAxisLabelSpacing &&
      showAxisX == other.showAxisX &&
      showAxisXSelectedLabelIfConcealed ==
          other.showAxisXSelectedLabelIfConcealed &&
      showAxisXLabelSelection == other.showAxisXLabelSelection &&
      showAxisY == other.showAxisY &&
      showAxisXLabels == other.showAxisXLabels &&
      showAxisYLabels == other.showAxisYLabels &&
      showZeroLine == other.showZeroLine &&
      showAxisXDropLine == other.showAxisXDropLine &&
      showAxisYDropLine == other.showAxisYDropLine &&
      showTooltip == other.showTooltip;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mdcharts/_internal.dart';

/// Snap position options of limit label.
enum LimitLabelSnapPosition {
  /// Snap to Y axis.
  ///
  /// Default behavior.
  axis,

  /// Snap to charts left boundary.
  chartBoundary,
}

/// Set of settings of the [LineChart].
class LineChartSettings {
  /// Constructs an instance of [LineChartSettings].
  const LineChartSettings({
    this.xAxisDivisions = 3,
    this.yAxisDivisions = 2,
    this.xAxisLabelQuantity,
    this.axisDivisionEdges = AxisDivisionEdges.none,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisY = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showAxisXLabelSelection = false,
    this.showPoint = true,
    this.showTooltip = true,
    this.selectionEnabled = true,
  });

  /// Constructs an instance of [LineChartSettings] without grids.
  const LineChartSettings.gridless({
    this.xAxisLabelQuantity,
    this.showAxisX = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisY = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showAxisXLabels = true,
    this.showAxisYLabels = true,
    this.showAxisXLabelSelection = false,
    this.showPoint = true,
    this.showTooltip = true,
    this.selectionEnabled = true,
  })  : xAxisDivisions = 0,
        yAxisDivisions = 0,
        axisDivisionEdges = AxisDivisionEdges.none;

  /// Divisions of the X axis or the quantity of the grid lines on X axis.
  ///
  /// Defaults to `3` for basic constructor.
  ///
  /// **Note**: to prevent from displaying only X axis - set
  /// [xAxisDivisions] to `0`, so X axis will not be painted, but Y axis will.
  ///
  /// **Note**: to prevent from displaying entire grid set both [xAxisDivisions]
  /// and [yAxisDivisions] to `0` or consider using [LineChartSettings.gridless]
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
  /// and [yAxisDivisions] to `0` or consider using [LineChartSettings.gridless]
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

  /// Whether to fill the space between the line and the X axis with
  /// color or gradient, which depends on provided style.
  ///
  /// Defaults to `true`.
  final bool lineFilling;

  /// Whether to paint the shadow beneath the cart line or not.
  ///
  /// Defaults to `true`.
  final bool lineShadow;

  /// Whether to show the altitude line at the chart's last point of not.
  ///
  /// Defaults to `true`.
  final bool altitudeLine;

  /// Snap position options of limit label.
  ///
  /// Defaults to [LimitLabelSnapPosition.axis].
  final LimitLabelSnapPosition limitLabelSnapPosition;

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

  /// Whether to show current or selected point or not.
  ///
  /// Defaults to `true`.
  final bool showPoint;

  /// Whether to show tooltip over the selected point or not.
  ///
  /// Defaults to `true`.
  final bool showTooltip;

  /// Whether interactive selection is enabled or not.
  ///
  /// Defaults to `true`.
  final bool selectionEnabled;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  LineChartSettings copyWith({
    bool allowNullXAxisLabelQuantity = false,
    int? xAxisDivisions,
    int? yAxisDivisions,
    int? xAxisLabelQuantity,
    AxisDivisionEdges? axisDivisionEdges,
    bool? showAxisX,
    bool? showAxisXSelectedLabelIfConcealed,
    bool? showAxisY,
    bool? lineFilling,
    bool? lineShadow,
    bool? altitudeLine,
    LimitLabelSnapPosition? limitLabelSnapPosition,
    bool? showAxisXLabels,
    bool? showAxisYLabels,
    bool? showAxisXLabelSelection,
    bool? showPoint,
    bool? showTooltip,
    bool? selectionEnabled,
  }) =>
      LineChartSettings(
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
        lineFilling: lineFilling ?? this.lineFilling,
        lineShadow: lineShadow ?? this.lineShadow,
        altitudeLine: altitudeLine ?? this.altitudeLine,
        limitLabelSnapPosition:
            limitLabelSnapPosition ?? this.limitLabelSnapPosition,
        showAxisXLabels: showAxisXLabels ?? this.showAxisXLabels,
        showAxisYLabels: showAxisYLabels ?? this.showAxisYLabels,
        showAxisXLabelSelection:
            showAxisXLabelSelection ?? this.showAxisXLabelSelection,
        showPoint: showPoint ?? this.showPoint,
        showTooltip: showTooltip ?? this.showTooltip,
        selectionEnabled: selectionEnabled ?? this.selectionEnabled,
      );

  @override
  int get hashCode =>
      xAxisDivisions.hashCode ^
      yAxisDivisions.hashCode ^
      xAxisLabelQuantity.hashCode ^
      axisDivisionEdges.hashCode ^
      showAxisX.hashCode ^
      showAxisXSelectedLabelIfConcealed.hashCode ^
      showAxisY.hashCode ^
      lineFilling.hashCode ^
      lineShadow.hashCode ^
      altitudeLine.hashCode ^
      limitLabelSnapPosition.hashCode ^
      showAxisXLabels.hashCode ^
      showAxisYLabels.hashCode ^
      showAxisXLabelSelection.hashCode ^
      showPoint.hashCode ^
      showTooltip.hashCode ^
      selectionEnabled.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartSettings &&
      xAxisDivisions == other.xAxisDivisions &&
      yAxisDivisions == other.yAxisDivisions &&
      xAxisLabelQuantity == other.xAxisLabelQuantity &&
      axisDivisionEdges == other.axisDivisionEdges &&
      showAxisX == other.showAxisX &&
      showAxisXSelectedLabelIfConcealed ==
          other.showAxisXSelectedLabelIfConcealed &&
      showAxisY == other.showAxisY &&
      lineFilling == other.lineFilling &&
      lineShadow == other.lineShadow &&
      altitudeLine == other.altitudeLine &&
      limitLabelSnapPosition == other.limitLabelSnapPosition &&
      showAxisXLabels == other.showAxisXLabels &&
      showAxisYLabels == other.showAxisYLabels &&
      showAxisXLabelSelection == other.showAxisXLabelSelection &&
      showPoint == other.showPoint &&
      showTooltip == other.showTooltip &&
      selectionEnabled == other.selectionEnabled;
}

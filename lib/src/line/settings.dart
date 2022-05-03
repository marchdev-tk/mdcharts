// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Axis division edges.
enum AxisDivisionEdges {
  /// No edges.
  ///
  /// Default option.
  none,

  /// Left edge.
  left,

  /// Top edge.
  top,

  /// Right edge.
  right,

  /// Bottom edge.
  bottom,

  /// [left] and [right] edges.
  horizontal,

  /// [top] and [bottom] edges.
  vertical,

  /// All edges.
  all,
}

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
    this.axisDivisionEdges = AxisDivisionEdges.none,
    this.showAxisX = true,
    this.showAxisY = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showAxisXLabels = true,
  });

  /// Constructs an instance of [LineChartSettings] without grids.
  const LineChartSettings.gridless({
    this.showAxisX = true,
    this.showAxisY = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showAxisXLabels = true,
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

  /// Axis division edges to be painted.
  ///
  /// Defaults to [AxisDivisionEdges.none].
  final AxisDivisionEdges axisDivisionEdges;

  /// Whether to show X axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisX;

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

  @override
  int get hashCode =>
      xAxisDivisions.hashCode ^
      yAxisDivisions.hashCode ^
      axisDivisionEdges.hashCode ^
      showAxisX.hashCode ^
      showAxisY.hashCode ^
      lineFilling.hashCode ^
      lineShadow.hashCode ^
      altitudeLine.hashCode ^
      limitLabelSnapPosition.hashCode ^
      showAxisXLabels.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartSettings &&
      xAxisDivisions == other.xAxisDivisions &&
      yAxisDivisions == other.yAxisDivisions &&
      axisDivisionEdges == other.axisDivisionEdges &&
      showAxisX == other.showAxisX &&
      showAxisY == other.showAxisY &&
      lineFilling == other.lineFilling &&
      lineShadow == other.lineShadow &&
      altitudeLine == other.altitudeLine &&
      limitLabelSnapPosition == other.limitLabelSnapPosition &&
      showAxisXLabels == other.showAxisXLabels;
}

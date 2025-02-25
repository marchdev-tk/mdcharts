// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mdcharts/src/_internal.dart';

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
class LineChartSettings extends GridAxisSettings {
  /// Constructs an instance of [LineChartSettings].
  const LineChartSettings({
    super.defaultDivisionInterval = 100,
    super.xAxisDivisions = 3,
    super.yAxisDivisions = 2,
    super.xAxisLabelQuantity,
    super.axisDivisionEdges = AxisDivisionEdges.none,
    super.showAxisX = true,
    super.showAxisXSelectedLabelIfConcealed = false,
    super.showAxisY = true,
    super.showAxisXLabels = true,
    super.showAxisYLabels = true,
    super.showAxisXLabelSelection = false,
    super.yAxisLayout = YAxisLayout.overlay,
    super.yAxisBaseline = YAxisBaseline.zero,
    super.yAxisLabelSpacing = 0,
    super.showZeroLine = false,
    super.showDropLine = true,
    super.showTooltip = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showPoint = true,
    this.selectionEnabled = true,
    this.startLineFromZero = true,
  }) : super();

  /// Constructs an instance of [LineChartSettings] without grids.
  const LineChartSettings.gridless({
    super.defaultDivisionInterval = 100,
    super.xAxisLabelQuantity,
    super.showAxisX = true,
    super.showAxisXSelectedLabelIfConcealed = false,
    super.showAxisY = true,
    super.showAxisXLabels = true,
    super.showAxisYLabels = true,
    super.showAxisXLabelSelection = false,
    super.yAxisLayout = YAxisLayout.overlay,
    super.yAxisBaseline = YAxisBaseline.zero,
    super.yAxisLabelSpacing = 0,
    super.showZeroLine = false,
    super.showDropLine = true,
    super.showTooltip = true,
    this.lineFilling = true,
    this.lineShadow = true,
    this.altitudeLine = true,
    this.limitLabelSnapPosition = LimitLabelSnapPosition.axis,
    this.showPoint = true,
    this.selectionEnabled = true,
    this.startLineFromZero = true,
  }) : super.gridless();

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

  /// Whether to show current or selected point or not.
  ///
  /// Defaults to `true`.
  final bool showPoint;

  /// Whether interactive selection is enabled or not.
  ///
  /// Defaults to `true`.
  final bool selectionEnabled;

  /// Whether to start the line from zero point or not.
  ///
  /// Defaults to `true`.
  final bool startLineFromZero;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  @override
  LineChartSettings copyWith({
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
    bool? lineFilling,
    bool? lineShadow,
    bool? altitudeLine,
    LimitLabelSnapPosition? limitLabelSnapPosition,
    bool? showPoint,
    bool? selectionEnabled,
    bool? startLineFromZero,
  }) =>
      LineChartSettings(
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
        lineFilling: lineFilling ?? this.lineFilling,
        lineShadow: lineShadow ?? this.lineShadow,
        altitudeLine: altitudeLine ?? this.altitudeLine,
        limitLabelSnapPosition:
            limitLabelSnapPosition ?? this.limitLabelSnapPosition,
        showPoint: showPoint ?? this.showPoint,
        selectionEnabled: selectionEnabled ?? this.selectionEnabled,
        startLineFromZero: startLineFromZero ?? this.startLineFromZero,
      );

  @override
  int get hashCode =>
      super.hashCode ^
      lineFilling.hashCode ^
      lineShadow.hashCode ^
      altitudeLine.hashCode ^
      limitLabelSnapPosition.hashCode ^
      showPoint.hashCode ^
      selectionEnabled.hashCode ^
      startLineFromZero.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartSettings &&
      super == other &&
      lineFilling == other.lineFilling &&
      lineShadow == other.lineShadow &&
      altitudeLine == other.altitudeLine &&
      limitLabelSnapPosition == other.limitLabelSnapPosition &&
      showPoint == other.showPoint &&
      selectionEnabled == other.selectionEnabled &&
      startLineFromZero == other.startLineFromZero;
}

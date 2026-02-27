// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../_internal.dart';

/// Set of settings of the [CandleStickChart].
class CandlestickChartSettings extends GridAxisSettings {
  /// Constructs an instance of [CandlestickChartSettings].
  const CandlestickChartSettings({
    super.defaultDivisionInterval = 100,
    super.xAxisDivisions = 3,
    super.yAxisDivisions = 2,
    super.xAxisLabelQuantity,
    super.axisDivisionEdges = AxisDivisionEdges.none,
    super.yAxisLayout = YAxisLayout.overlay,
    super.yAxisBaseline = YAxisBaseline.zero,
    super.yAxisLabelSpacing = 0,
    super.showAxisX = true,
    super.showAxisXSelectedLabelIfConcealed = false,
    super.showAxisXLabelSelection = false,
    super.showAxisY = true,
    super.showAxisXLabels = true,
    super.showAxisYLabels = true,
    super.showZeroLine = false,
    super.showAxisXDropLine = true,
    super.showAxisYDropLine = true,
    super.showTooltip = true,
    this.selectionEnabled = true,
  }) : super();

  /// Constructs an instance of [CandlestickChartSettings] without grids.
  const CandlestickChartSettings.gridless({
    super.defaultDivisionInterval = 100,
    super.xAxisLabelQuantity,
    super.yAxisLayout = YAxisLayout.overlay,
    super.yAxisBaseline = YAxisBaseline.zero,
    super.yAxisLabelSpacing = 0,
    super.showAxisX = true,
    super.showAxisXSelectedLabelIfConcealed = false,
    super.showAxisXLabelSelection = false,
    super.showAxisY = true,
    super.showAxisXLabels = true,
    super.showAxisYLabels = true,
    super.showZeroLine = false,
    super.showAxisXDropLine = true,
    super.showAxisYDropLine = true,
    super.showTooltip = true,
    this.selectionEnabled = true,
  }) : super.gridless();

  /// Whether interactive selection is enabled or not.
  ///
  /// Defaults to `true`.
  final bool selectionEnabled;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  @override
  CandlestickChartSettings copyWith({
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
    bool? selectionEnabled,
  }) =>
      CandlestickChartSettings(
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
        selectionEnabled: selectionEnabled ?? this.selectionEnabled,
      );

  @override
  int get hashCode => super.hashCode ^ selectionEnabled.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartSettings &&
      super == other &&
      selectionEnabled == other.selectionEnabled;
}

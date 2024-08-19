// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mdcharts/src/_internal.dart';

/// Set of settings of the [CandleStickChart].
class CandlestickChartSettings extends GridAxisSettings {
  /// Constructs an instance of [CandlestickChartSettings].
  const CandlestickChartSettings({
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
    this.selectionEnabled = true,
  }) : super();

  /// Constructs an instance of [CandlestickChartSettings] without grids.
  const CandlestickChartSettings.gridless({
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

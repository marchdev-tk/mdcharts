// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mdcharts/src/_internal.dart';

/// Set of settings of the [CandleStickChart].
class CandlestickChartSettings extends GridAxisSettings {
  /// Constructs an instance of [CandlestickChartSettings].
  const CandlestickChartSettings({
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
    super.showDropLine = true,
    super.showTooltip = true,
    this.selectionEnabled = true,
  });

  /// Constructs an instance of [CandlestickChartSettings] without grids.
  const CandlestickChartSettings.gridless({
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
    super.showDropLine = true,
    super.showTooltip = true,
    this.selectionEnabled = true,
  });

  /// Whether interactive selection is enabled or not.
  ///
  /// Defaults to `true`.
  final bool selectionEnabled;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  @override
  CandlestickChartSettings copyWith({
    bool allowNullXAxisLabelQuantity = false,
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
    bool? showDropLine,
    bool? showTooltip,
    bool? selectionEnabled,
  }) =>
      CandlestickChartSettings(
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
        showDropLine: showDropLine ?? this.showDropLine,
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
      showAxisXLabels.hashCode ^
      showAxisYLabels.hashCode ^
      showAxisXLabelSelection.hashCode ^
      yAxisLayout.hashCode ^
      yAxisLabelSpacing.hashCode ^
      showDropLine.hashCode ^
      showTooltip.hashCode ^
      selectionEnabled.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartSettings &&
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
      yAxisLabelSpacing == other.yAxisLabelSpacing &&
      showDropLine == other.showDropLine &&
      showTooltip == other.showTooltip &&
      selectionEnabled == other.selectionEnabled;
}

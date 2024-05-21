// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:mdcharts/src/_internal.dart';

class CandlestickData {
  const CandlestickData({
    required this.high,
    required this.low,
    required this.bid,
    required this.ask,
  })  : assert(low <= high),
        assert(bid >= low && bid <= high),
        assert(ask >= low && ask <= high);

  const CandlestickData.zero()
      : high = 0,
        low = 0,
        bid = 0,
        ask = 0;

  final double high;
  final double low;
  final double bid;
  final double ask;

  bool get isDescending => ask > bid;
  bool get isAscending => ask <= bid;

  @override
  String toString() => '{high:$high,low:$low,bid:$bid,ask:$ask}';
}

/// Data for the [CandlestickChart].
class CandlestickChartData extends GridAxisData<CandlestickData> {
  /// Constructs an instance of [CandlestickChartData].
  const CandlestickChartData({
    required super.data,
    super.predefinedMaxValue,
    super.maxValueRoundingMap = ChartData.defaultMaxValueRoundingMap,
    super.xAxisLabelBuilder = GridAxisData.defaultXAxisLabelBuilder,
    super.yAxisLabelBuilder = GridAxisData.defaultYAxisLabelBuilder,
    super.titleBuilder = GridAxisData.defaultTitleBuilder,
    super.subtitleBuilder = GridAxisData.defaultSubtitleBuilder,
  });

  @override
  double maxValuePredicate(CandlestickData value) => value.high;
  @override
  double minValuePredicate(CandlestickData value) => value.low;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    Map<DateTime, CandlestickData>? data,
    double? predefinedMaxValue,
    Map<num, num>? maxValueRoundingMap,
    TooltipBuilder? titleBuilder,
    TooltipBuilder? subtitleBuilder,
    RichLabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
  }) =>
      CandlestickChartData(
        data: data ?? this.data,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        maxValueRoundingMap: maxValueRoundingMap ?? this.maxValueRoundingMap,
        titleBuilder: titleBuilder ?? this.titleBuilder,
        subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
      );

  @override
  int get hashCode =>
      data.hashCode ^
      predefinedMaxValue.hashCode ^
      maxValueRoundingMap.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(maxValueRoundingMap, other.maxValueRoundingMap);
}

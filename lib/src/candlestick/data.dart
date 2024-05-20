// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils.dart';

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

  double get max => math.max(high, math.max(bid, ask));
  double get min => math.min(low, math.min(bid, ask));

  bool get isDescending => ask > bid;
  bool get isAscending => ask <= bid;
}

/// Data for the [CandlestickChart].
class CandlestickChartData {
  /// Constructs an instance of [CandlestickChartData].
  const CandlestickChartData({
    required this.data,
    this.predefinedMaxValue,
    this.maxValueRoundingMap = defaultMaxValueRoundingMap,
    this.titleBuilder = defaultTitleBuilder,
    this.subtitleBuilder = defaultSubtitleBuilder,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
  });

  static String defaultTitleBuilder(DateTime key, double value) =>
      '${key.year}-${key.month}-${key.day}';
  static String defaultSubtitleBuilder(DateTime key, double value) =>
      value.toString();
  static TextSpan defaultXAxisLabelBuilder(DateTime key, TextStyle style) =>
      TextSpan(text: '${key.month}-${key.day}', style: style);
  static String defaultYAxisLabelBuilder(double value) => '$value';
  static const Map<num, num> defaultMaxValueRoundingMap = {
    100: 5,
    1000: 10,
    10000: 100,
    100000: 1000,
    1000000: 10000,
  };

  /// Map of the values that corresponds to the dates.
  ///
  /// It is a main source of [CandlestickChart] data.
  final Map<DateTime, CandlestickData> data;

  /// Predefined max value for the chart.
  ///
  /// By default it will be calculated based on the logic of [maxValue].
  final double? predefinedMaxValue;

  /// Rounding map of the [maxValue].
  ///
  /// Logic of rounding is following:
  ///
  /// `key` is compared to [maxValue].
  ///
  /// If [maxValue] is less than `key` - `value` of this `key` is used as a
  /// complement to [maxValue] to find the closest value that will be divided by
  /// quantity of Y axis divisions to "buitify" Y axis labels.
  ///
  /// Otherwise, next `key` is compared to [maxValue]. And so on.
  ///
  /// In case of absence of `key` that might satisfy the rule, described above,
  /// last entry of this map will be used as a fallback.
  ///
  /// Example:
  /// - `yAxisDivisions` = 2 (so 2 division lines results with 3 chunks of chart);
  /// - `maxValue` = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  ///
  /// **Please note**: it is preferred to provide ascending keys for this map,
  /// omitting this simple rule may cause malfunctioning of rounding function.
  /// As a sample of correctly formed map [defaultMaxValueRoundingMap] could be
  /// used.
  final Map<num, num> maxValueRoundingMap;

  /// Text builder for the tooltip title.
  ///
  /// If not set explicitly, [defaultTitleBuilder] will be used.
  final TooltipBuilder<double> titleBuilder;

  /// Text builder for the tooltip subtitle.
  ///
  /// If not set explicitly, [defaultSubtitleBuilder] will be used.
  final TooltipBuilder<double> subtitleBuilder;

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final RichLabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;

  /// Checks whether chart and point could be drawned or not.
  ///
  /// It checks for [data] length to be greater than or equal to 1.
  bool get canDraw => data.isNotEmpty;

  /// Determines max value for chart to draw.
  ///
  /// If [predefinedMaxValue] is set, then it will be used as max value,
  /// omitting [limit] value.
  ///
  /// If [limit] is not set, then max value will be retrieved from [data].
  /// Otherwise it will be one of [limit] or max value from [data], depending
  /// on which one is greater.
  double get maxValue {
    if (!canDraw) {
      return 1;
    }

    return _maxValue;
  }

  double get _maxValue {
    if (predefinedMaxValue != null) {
      return predefinedMaxValue!;
    }

    return data.values.map((v) => v.max).max;
  }

  /// Determines min value for chart to draw.
  double get minValue {
    if (!canDraw) {
      return 0;
    }

    return math.min(data.values.map((v) => v.min).min, .0);
  }

  /// Whether [minValue] is less than `0`.
  bool get hasNegativeMinValue => minValue < 0;

  /// Determines sum of the [maxValue] and absolute value of [minValue].
  double get totalValue => maxValue - minValue;

  /// Gets last division index.
  int get lastDivisionIndex {
    // minus 1 due to to the first point that lies on the Y axis.
    return data.length - 1;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    bool allowNullLimit = false,
    bool allowNullLimitText = false,
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

// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

/// Data for the [BarChart].
class BarChartData {
  /// Constructs an instance of [BarChartData].
  const BarChartData({
    required this.data,
    this.initialSelectedPeriod,
    this.onSelectedPeriodChanged,
    this.predefinedMaxValue,
    this.roundingMap = ChartData.defaultRoundingMap,
    this.titleBuilder = defaultTitleBuilder,
    this.subtitleBuilder = defaultSubtitleBuilder,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
  });

  static String defaultTitleBuilder(DateTime key, List<double> value) =>
      '${key.year}-${key.month}-${key.day}';
  static String defaultSubtitleBuilder(DateTime key, List<double> value) =>
      value.toString();
  static TextSpan defaultXAxisLabelBuilder(DateTime key, TextStyle style) =>
      TextSpan(text: '${key.month}-${key.year}', style: style);
  static String defaultYAxisLabelBuilder(double value) => '$value';

  /// Map of the values that corresponds to the dates.
  ///
  /// It is a main source of [BarChart] data.
  final Map<DateTime, List<double>> data;

  /// Initial selected period of the bar chart.
  ///
  /// Defaults to `null`.
  final DateTime? initialSelectedPeriod;

  /// Callback that notifies if selected period has changed.
  ///
  /// Defaults to `null`.
  final ValueChanged<DateTime>? onSelectedPeriodChanged;

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
  /// As a sample of correctly formed map [ChartData.defaultRoundingMap]
  /// could be used.
  final Map<String, num> roundingMap;

  /// Text builder for the tooltip title.
  ///
  /// If not set explicitly, [defaultTitleBuilder] will be used.
  final TooltipBuilder<List<double>> titleBuilder;

  /// Text builder for the tooltip subtitle.
  ///
  /// If not set explicitly, [defaultSubtitleBuilder] will be used.
  final TooltipBuilder<List<double>> subtitleBuilder;

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final RichLabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;

  /// Selected period of the bar chart.
  ///
  /// If [initialSelectedPeriod] is not set, then last key of the [data] will
  /// be used instead.
  DateTime? get selectedPeriod =>
      initialSelectedPeriod ?? (canDraw ? data.keys.last : null);

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

    final values = [for (var value in data.values) ...value];
    final max = values.max;

    return max;
  }

  /// Gets list of [DateTime] that is used to build X axis labels.
  List<DateTime> get xAxisDates => data.keys.toList();

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    Map<DateTime, List<double>>? data,
    DateTime? initialSelectedPeriod,
    double? predefinedMaxValue,
    Map<String, num>? roundingMap,
    TooltipBuilder<List<double>>? titleBuilder,
    TooltipBuilder<List<double>>? subtitleBuilder,
    RichLabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
  }) =>
      BarChartData(
        data: data ?? this.data,
        initialSelectedPeriod: initialSelectedPeriod,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        roundingMap: roundingMap ?? this.roundingMap,
        titleBuilder: titleBuilder ?? this.titleBuilder,
        subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
      );

  @override
  int get hashCode =>
      data.hashCode ^
      initialSelectedPeriod.hashCode ^
      predefinedMaxValue.hashCode ^
      roundingMap.hashCode ^
      titleBuilder.hashCode ^
      subtitleBuilder.hashCode ^
      xAxisLabelBuilder.hashCode ^
      yAxisLabelBuilder.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartData &&
      mapEquals(data, other.data) &&
      initialSelectedPeriod == other.initialSelectedPeriod &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(roundingMap, other.roundingMap) &&
      titleBuilder == other.titleBuilder &&
      subtitleBuilder == other.subtitleBuilder &&
      xAxisLabelBuilder == other.xAxisLabelBuilder &&
      yAxisLabelBuilder == other.yAxisLabelBuilder;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';

import '../common.dart';

/// Data for the [BarChart].
class BarChartData {
  /// Constructs an instance of [BarChartData].
  const BarChartData({
    required this.data,
    this.initialSelectedPeriod,
    this.predefinedMaxValue,
    this.maxValueRoundingMap = defaultMaxValueRoundingMap,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
  });

  static String defaultXAxisLabelBuilder(DateTime key) =>
      '${key.month}-${key.day}';
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
  /// It is a main source of [BarChart] data.
  final Map<DateTime, List<double>> data;

  // TODO: add docs
  final DateTime? initialSelectedPeriod;

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

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final LabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;

  // TODO: add docs
  DateTime get selectedPeriod => initialSelectedPeriod ?? data.keys.first;

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
    DateTime? selectedPeriod,
    double? predefinedMaxValue,
    Map<num, num>? maxValueRoundingMap,
    LabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
  }) =>
      BarChartData(
        data: data ?? this.data,
        initialSelectedPeriod: selectedPeriod,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        maxValueRoundingMap: maxValueRoundingMap ?? this.maxValueRoundingMap,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
      );

  @override
  int get hashCode =>
      data.hashCode ^
      selectedPeriod.hashCode ^
      predefinedMaxValue.hashCode ^
      maxValueRoundingMap.hashCode ^
      xAxisLabelBuilder.hashCode ^
      yAxisLabelBuilder.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartData &&
      mapEquals(data, other.data) &&
      selectedPeriod == other.selectedPeriod &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(maxValueRoundingMap, other.maxValueRoundingMap) &&
      xAxisLabelBuilder == other.xAxisLabelBuilder &&
      yAxisLabelBuilder == other.yAxisLabelBuilder;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';

/// Generic Chart Data.
abstract class ChartData<T> {
  /// Constructs an instance of [ChartData].
  const ChartData({
    required this.data,
    this.predefinedMaxValue,
    this.maxValueRoundingMap = defaultMaxValueRoundingMap,
  });

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
  final Map<DateTime, T> data;

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

  /// Checks whether chart and point could be drawned or not.
  ///
  /// It checks for [data] length to be greater than or equal to 1.
  bool get canDraw => data.isNotEmpty;

  /// Predicate that must be resolved with max value of the provided data type [T].
  double maxValuePredicate(T value);

  /// {@template ChartData.maxValue}
  /// Determines max value for chart to draw.
  ///
  /// If [predefinedMaxValue] is set, then it will be used as max value.
  /// {@endtemplate}
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

    return data.values.map(maxValuePredicate).max;
  }

  /// Predicate that must be resolved with min value of the provided data type [T].
  double minValuePredicate(T value);

  /// Determines min value for chart to draw.
  double get minValue {
    if (!canDraw) {
      return 0;
    }

    return math.min(data.values.map(minValuePredicate).min, .0);
  }

  /// Whether [minValue] is less than `0`.
  bool get hasNegativeMinValue => minValue < 0;

  /// Determines sum of the [maxValue] and absolute value of [minValue].
  double get totalValue => maxValue - minValue;

  /// Gets divisions of the X axis.
  int get xAxisDivisions {
    if (data.isEmpty) {
      // returning 1 to ensure no "division by 0" would occur.
      return 1;
    }

    if (data.length == 1) {
      return 1;
    }

    // minus 1 due to to the first point that lies on the Y axis.
    return data.length - 1;
  }

  @override
  int get hashCode =>
      data.hashCode ^
      predefinedMaxValue.hashCode ^
      maxValueRoundingMap.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(maxValueRoundingMap, other.maxValueRoundingMap);
}

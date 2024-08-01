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
    this.roundingMap = defaultRoundingMap,
  });

  static const Map<num, num> defaultRoundingMap = {
    1: 0.001,
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

  /// Rounding map of the [maxValue] or/and [minValue].
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
  /// As a sample of correctly formed map [defaultRoundingMap] could be
  /// used.
  final Map<num, num> roundingMap;

  /// Checks whether chart could be drawned or not.
  ///
  /// It checks for [data] length to be greater than or equal to 1.
  bool get canDraw => data.isNotEmpty;

  /// Checks whether every data entry is less than or equal to `0` and any of
  /// it strictly less than `0` or not.
  bool get isNegative =>
      data.entries.every((e) =>
          minValuePredicate(e.value) <= 0 && maxValuePredicate(e.value) <= 0) &&
      data.entries.any((e) =>
          minValuePredicate(e.value) < 0 && maxValuePredicate(e.value) < 0);

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

  /// Determines axis based min value for chart to draw.
  double get minValue {
    if (!canDraw) {
      return 0;
    }

    return data.values.map(minValuePredicate).min;
  }

  /// Determines sum of the [maxValue] and absolute value of [minValue].
  double get totalValue => maxValue - minValue;

  // !                               ! //
  // ! START OF `zero based getters` ! //
  // !                               ! //

  /// Determines zero based min value for chart to draw.
  double get minValueZeroBased => math.min(minValue, .0);

  /// Whether [minValueZeroBased] is less than `0`.
  bool get hasNegativeMinValueZeroBased => minValueZeroBased < 0;

  /// Determines sum of the [maxValue] and absolute value of [minValueZeroBased].
  double get totalValueZeroBased => maxValue - minValueZeroBased;

  // !                               ! //
  // !  END OF `zero based getters`  ! //
  // !                               ! //

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

  /// Gets list of [DateTime] that is used to build X axis labels.
  List<DateTime> get xAxisDates => data.keys.toList();

  @override
  int get hashCode =>
      data.hashCode ^ predefinedMaxValue.hashCode ^ roundingMap.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(roundingMap, other.roundingMap);
}

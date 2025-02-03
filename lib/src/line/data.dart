// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';
import 'package:mdcharts/src/_internal.dart';

/// Type of the line chart.
///
/// If [LineChartGridType.undefined] is set, then:
/// - max values on Y axis will be determined from [LineChartData.data];
/// - dates on X axis will be determined from [LineChartData.data].
///
/// `Note` that [LineChartData.data] must contain at least 2 entries.
///
/// If [LineChartGridType.monthly] is set, then:
/// - max values on Y axis will be determined from [LineChartData.data];
/// - dates on X axis will be determined from [LineChartData.data].
///
/// `Note` that [LineChartData.data] must contain entries with the same month.
enum LineChartGridType {
  /// Means that chart will be built from data from [LineChartData.data].
  undefined,

  /// Means that chart will be built for the whole month even if it lacks
  /// data from [LineChartData.data].
  monthly,
}

/// Data for the [LineChart].
class LineChartData extends GridAxisData<double> {
  /// Constructs an instance of [LineChartData].
  const LineChartData({
    required super.data,
    super.predefinedMaxValue,
    super.roundingMap = ChartData.defaultRoundingMap,
    super.xAxisLabelBuilder = GridAxisData.defaultXAxisLabelBuilder,
    super.yAxisLabelBuilder = GridAxisData.defaultYAxisLabelBuilder,
    super.titleBuilder,
    super.subtitleBuilder,
    this.limit,
    this.limitText,
    this.gridType = LineChartGridType.monthly,
  });

  /// Optional limit, corresponds to the limit line on the chart. It is
  /// designed to be as a notifier of overuse.
  final double? limit;

  /// Optional limit text that will be printed on the limit label if [limit]
  /// is set.
  ///
  /// If this value is omitted - [limit] will be used as a fallback.
  final String? limitText;

  /// Grid type of the line chart.
  ///
  /// More info at [LineChartGridType].
  final LineChartGridType gridType;

  @override
  double maxValuePredicate(double value) => value;
  @override
  double minValuePredicate(double value) => value;

  @override
  bool get isDefault => data.values.every((v) => v == 0);

  /// {@macro ChartData.maxValue}
  /// (Omitting [limit] value)
  ///
  /// If [limit] is not set, then max value will be retrieved from [data].
  /// Otherwise it will be one of [limit] or max value from [data], depending
  /// on which one is greater.
  @override
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

    final max = math.max(maxDataValue, .0);
    if (limit == null || max > limit!) {
      return max;
    }

    return limit!;
  }

  /// Determines whether max value from [data] is greater than limit.
  /// If so - [limit] is overused. Otherwise - no.
  ///
  /// **Note** that [limit] must not be null in order to call this.
  bool get limitOverused {
    assert(limit != null);

    return limit! < data.values.max;
  }

  /// Gets divisions of the X axis.
  @override
  int get xAxisDivisions {
    if (data.isEmpty) {
      // returning 1 to ensure no "division by 0" would occur.
      return 1;
    }

    if (gridType == LineChartGridType.undefined && data.length == 1) {
      return 1;
    }

    int divisions;
    switch (gridType) {
      case LineChartGridType.undefined:
        divisions = data.length;
        break;

      case LineChartGridType.monthly:
        divisions = data.keys.first.endOfMonth.day;
        break;
    }

    // minus 1 due to the first point that lies on the Y axis.
    return divisions - 1;
  }

  /// Gets last division index.
  int get lastDivisionIndex {
    int lastDivision;

    switch (gridType) {
      case LineChartGridType.undefined:
        lastDivision = data.length;
        break;
      case LineChartGridType.monthly:
        lastDivision = data.entries.last.key.day;
        break;
    }

    // minus 1 due to to the first point that lies on the Y axis.
    return lastDivision - 1;
  }

  /// Gets list of [DateTime] that is used to build X axis labels.
  @override
  List<DateTime> get xAxisDates {
    switch (gridType) {
      case LineChartGridType.undefined:
        return data.keys.toList();
      case LineChartGridType.monthly:
        return _monthlyXAxisDates;
    }
  }

  List<DateTime> get _monthlyXAxisDates {
    if (data.isEmpty) {
      return [];
    }

    final dates = <DateTime>[];
    final startOfMonth = data.keys.first.startOfMonth;
    final endOfMonthDay = data.keys.first.endOfMonth.day;
    for (var i = 0; i < endOfMonthDay; i++) {
      final date = DateTime(startOfMonth.year, startOfMonth.month, i + 1);
      dates.add(date);
    }

    return dates;
  }

  /// Gets map that contains all days in the month as keys.
  ///
  /// Values where possible are copied from [data] map. If value wasn't present
  /// at [data] map, its default value retrieved from [_getDefaultValue].
  Map<DateTime, double> get typedData {
    switch (gridType) {
      case LineChartGridType.undefined:
        return data;
      case LineChartGridType.monthly:
        return _monthlyData;
    }
  }

  Map<DateTime, double> get _monthlyData {
    assert(gridType == LineChartGridType.monthly);

    if (data.isEmpty) {
      return data;
    }

    final map = <DateTime, double>{};
    final startOfMonth = data.keys.first.startOfMonth;
    final endOfMonthDay = data.keys.first.endOfMonth.day;
    final lastDate = data.keys.max.date;
    for (var i = 0; i < endOfMonthDay; i++) {
      final date = DateTime(
        startOfMonth.year,
        startOfMonth.month,
        startOfMonth.day + i,
      );

      if (date.isAfter(lastDate)) {
        break;
      }

      final value = data[date] ?? .0;
      map[date] = value;
    }

    return map;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  LineChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    bool allowNullLimit = false,
    bool allowNullLimitText = false,
    Map<DateTime, double>? data,
    double? predefinedMaxValue,
    Map<String, num>? roundingMap,
    double? limit,
    String? limitText,
    TooltipBuilder? titleBuilder,
    TooltipBuilder? subtitleBuilder,
    RichLabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
    LineChartGridType? gridType,
  }) =>
      LineChartData(
        data: data ?? this.data,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        roundingMap: roundingMap ?? this.roundingMap,
        limit: allowNullLimit ? limit : limit ?? this.limit,
        limitText: allowNullLimitText ? limitText : limitText ?? this.limitText,
        titleBuilder: titleBuilder ?? this.titleBuilder,
        subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
        gridType: gridType ?? this.gridType,
      );

  @override
  int get hashCode =>
      data.hashCode ^
      predefinedMaxValue.hashCode ^
      roundingMap.hashCode ^
      limit.hashCode ^
      limitText.hashCode ^
      gridType.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(roundingMap, other.roundingMap) &&
      limit == other.limit &&
      limitText == other.limitText &&
      gridType == other.gridType;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/foundation.dart';

import '../common.dart';
import '../utils.dart';

/// Signature for callbacks that builds tooltip text based on the provided [key]
/// and [value].
typedef TooltipBuilder = String Function(DateTime key, double value);

/// Defines how values of the [LineChartData.data] must be represented.
///
/// Main usage of this type comes in periodical types of [LineChartGridType],
/// e.g. [LineChartGridType.monthly]. Map [LineChartData.data] might not be
/// fulfilled with all required periodical values, so it will be fulfilled with
/// values that will satisfy the selected rule.
///
/// For mode details on rules - see values of this enum.
///
/// **Please note**, if [unidirectional] is set, then [LineChartData.data]
/// will be validated to satisfy the [unidirectional] rule.
///
/// **Also please note**, if [LineChartGridType.undefined] is set, then this
/// value will be omitted.
enum LineChartDataType {
  /// No restrictions on values.
  ///
  /// Default value for fulfillment of gaps in [LineChartData.data] is `0`.
  bidirectional,

  /// All value of the [LineChartData.data] are either ascending or descending.
  ///
  /// Default value for fulfillment of gaps in [LineChartData.data] is
  /// `previous` value. If there is no `previous` value - default value will be
  /// acquired based on [LineChartDataDirection].
  unidirectional,
}

/// Data directionality of line chart.
///
/// **Note**, it works only in conjunction with
/// [LineChartDataType.unidirectional] data type.
enum LineChartDataDirection {
  /// Each subsequent value is greater than or equal to previous.
  ascending,

  /// Each subsequent value is less than or equal to previous.
  descending,
}

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
class LineChartData {
  /// Constructs an instance of [LineChartData].
  const LineChartData({
    required this.data,
    this.predefinedMaxValue,
    this.maxValueRoundingMap = defaultMaxValueRoundingMap,
    this.limit,
    this.limitText,
    this.titleBuilder = defaultTitleBuilder,
    this.subtitleBuilder = defaultSubtitleBuilder,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
    this.gridType = LineChartGridType.monthly,
    this.dataType = LineChartDataType.bidirectional,
  });

  static String defaultTitleBuilder(DateTime key, double value) =>
      '${key.year}-${key.month}-${key.day}';
  static String defaultSubtitleBuilder(DateTime key, double value) =>
      value.toString();
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
  /// It is a main source of [LineChart] data.
  ///
  /// If [LineChartGridType.undefined] is set, then [data] must contain at least 2
  /// entries.
  ///
  /// If [LineChartGridType.monthly] is set, then [data] must contain entries with
  /// the same month.
  final Map<DateTime, double> data;

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

  /// Optional limit, corresponds to the limit line on the chart. It is
  /// designed to be as a notifier of overuse.
  final double? limit;

  /// Optional limit text that will be printed on the limit label if [limit]
  /// is set.
  ///
  /// If this value is omitted - [limit] will be used as a fallback.
  final String? limitText;

  /// Text builder for the tooltip title.
  ///
  /// If not set explicitly, [defaultTitleBuilder] will be used.
  final TooltipBuilder titleBuilder;

  /// Text builder for the tooltip subtitle.
  ///
  /// If not set explicitly, [defaultSubtitleBuilder] will be used.
  final TooltipBuilder subtitleBuilder;

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final LabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;

  /// Grid type of the line chart.
  ///
  /// More info at [LineChartGridType].
  final LineChartGridType gridType;

  /// Data type of the line chart.
  ///
  /// This argument if omitted if [gridType] is set to
  /// [LineChartGridType.undefined].
  ///
  /// More info at [LineChartDataType].
  final LineChartDataType dataType;

  /// Determines direction of the [LineChartDataType.unidirectional] data type.
  ///
  /// If [LineChartDataType.unidirectional] is set, but [data] is
  /// [LineChartDataType.bidirectional] - throws an exception.
  ///
  /// If [LineChartDataType.unidirectional] is set, but all values of [data] are
  /// same - throws an exception. Consider using
  /// [LineChartDataType.bidirectional] data type.
  ///
  /// **Note**: must be used only for [LineChartDataType.unidirectional] data
  /// type, otherwise will throw an exception.
  LineChartDataDirection get dataDirection {
    assert(dataType == LineChartDataType.unidirectional);

    int ascCount = 0;
    int descCount = 0;

    for (var i = 1; i < data.length; i++) {
      final prev = data.entries.elementAt(i - 1).value;
      final curr = data.entries.elementAt(i).value;

      if (curr > prev) {
        ascCount++;
      }
      if (curr < prev) {
        descCount++;
      }

      if (ascCount > 0 && descCount > 0) {
        throw ArgumentError.value(
          dataType,
          'dataType',
          '[dataType] was set to unidirectional but [data] is bidirectional!',
        );
      }
    }

    if (ascCount > 0) {
      return LineChartDataDirection.ascending;
    }
    if (descCount > 0) {
      return LineChartDataDirection.descending;
    }

    // by default assume that chart is ascending
    return LineChartDataDirection.ascending;
  }

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

    final max = math.max(data.values.max, .0);
    if (limit == null || max > limit!) {
      return max;
    }

    return limit!;
  }

  /// Determines min value for chart to draw.
  double get minValue {
    if (!canDraw) {
      return 0;
    }

    return math.min(data.values.min, .0);
  }

  /// Whether [minValue] is less than `0`.
  bool get hasNegativeMinValue => minValue < 0;

  /// Determines sum of the [maxValue] and absolute value of [minValue].
  double get totalValue => maxValue - minValue;

  /// Determines whether max value from [data] is greater than limit.
  /// If so - [limit] is overused. Otherwise - no.
  ///
  /// **Note** that [limit] must not be null in order to call this.
  bool get limitOverused {
    assert(limit != null);

    return limit! < data.values.max;
  }

  /// Gets divisions of the X axis.
  int get xAxisDivisions {
    int divisions;

    if (data.isEmpty) {
      return 1;
    }

    if (gridType == LineChartGridType.undefined && data.length == 1) {
      return 1;
    }

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
    for (var i = 0; i <= endOfMonthDay; i++) {
      final date = startOfMonth.add(Duration(days: i));
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

      final value = data[date] ?? _getDefaultValue(map, date);
      map[date] = value;
    }

    return map;
  }

  double _getDefaultValue(Map<DateTime, double> map, DateTime current) {
    if (dataType == LineChartDataType.bidirectional) {
      return 0;
    }

    if (current.isStartOfMonth) {
      switch (dataDirection) {
        case LineChartDataDirection.ascending:
          return 0;
        case LineChartDataDirection.descending:
          return _maxValue;
      }
    }

    return map[current.previousDay]!;
  }

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  LineChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    bool allowNullLimit = false,
    bool allowNullLimitText = false,
    Map<DateTime, double>? data,
    double? predefinedMaxValue,
    Map<num, num>? maxValueRoundingMap,
    double? limit,
    String? limitText,
    TooltipBuilder? titleBuilder,
    TooltipBuilder? subtitleBuilder,
    LabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
    LineChartGridType? gridType,
    LineChartDataType? dataType,
  }) =>
      LineChartData(
        data: data ?? this.data,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        maxValueRoundingMap: maxValueRoundingMap ?? this.maxValueRoundingMap,
        limit: allowNullLimit ? limit : limit ?? this.limit,
        limitText: allowNullLimitText ? limitText : limitText ?? this.limitText,
        titleBuilder: titleBuilder ?? this.titleBuilder,
        subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
        gridType: gridType ?? this.gridType,
        dataType: dataType ?? this.dataType,
      );

  @override
  int get hashCode =>
      hashMap(data) ^
      predefinedMaxValue.hashCode ^
      hashMap(maxValueRoundingMap) ^
      limit.hashCode ^
      limitText.hashCode ^
      titleBuilder.hashCode ^
      subtitleBuilder.hashCode ^
      xAxisLabelBuilder.hashCode ^
      yAxisLabelBuilder.hashCode ^
      gridType.hashCode ^
      dataType.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LineChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(maxValueRoundingMap, other.maxValueRoundingMap) &&
      limit == other.limit &&
      limitText == other.limitText &&
      titleBuilder == other.titleBuilder &&
      subtitleBuilder == other.subtitleBuilder &&
      xAxisLabelBuilder == other.xAxisLabelBuilder &&
      yAxisLabelBuilder == other.yAxisLabelBuilder &&
      gridType == other.gridType &&
      dataType == other.dataType;
}

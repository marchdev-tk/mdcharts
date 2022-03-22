// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flinq/flinq.dart';

import '../utils.dart';

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
///
/// **Please note** that [data] must contain at least 2 entries.
class LineChartData {
  /// Constructs an instance of [LineChartData].
  const LineChartData({
    required this.data,
    this.limit,
    this.limitText,
    this.maxValueFactor = 0.05,
    this.gridType = LineChartGridType.monthly,
    this.dataType = LineChartDataType.bidirectional,
  })  : assert(
          data.length >= 2,
          '[data] must contain at least 2 entries!',
        ),
        assert(
          maxValueFactor >= 0 && maxValueFactor <= 1,
          '[maxValueFactor] must be in inclusive range between 0 and 1!',
        );

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

  /// Optional limit, corresponds to the limit line on the chart. It is
  /// designed to be as a notifier of overuse.
  final double? limit;

  /// Optional limit text that will be printed on the limit label if [limit]
  /// is set.
  ///
  /// If this value is omitted - [limit] will be used as a fallback.
  final String? limitText;

  /// This factor is a multiplier of [maxValue].
  ///
  /// Values must be in range [0..1].
  ///
  /// Sometimes it is needed to make largest value in chart at the top with
  /// some padding from top border. So this factor could be used to create top
  /// padding.
  final double maxValueFactor;

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

    throw ArgumentError.value(
      data,
      'data',
      '[data] must not be indistinctable!',
    );
  }

  /// Determines max value for chart to draw.
  ///
  /// If [limit] is not set, then max value will be retrieved from [data].
  /// Otherwise it will be one of [limit] or max value from [data], depending
  /// on which one is greater.
  ///
  /// **Note** that resulting max value will be increased by
  /// `1 + [maxValueFactor]`.
  double get maxValue {
    final max = data.values.max;
    if (limit == null || max > limit!) {
      return max * (1 + maxValueFactor);
    }

    return limit! * (1 + maxValueFactor);
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
  int get xAxisDivisions {
    int divisions;

    switch (gridType) {
      case LineChartGridType.undefined:
        divisions = data.length;
        break;

      case LineChartGridType.monthly:
        final endOfMonth = data.keys.first.endOfMonth;
        divisions = endOfMonth.day;
        break;
    }

    // minus 1 due to first point that lies on the Y axis
    return divisions - 1;
  }

  /// Gets map that contains all days in the month as keys.
  ///
  /// Values where possible are copied from [data] map. If value wasn't present
  /// at [data] map it defaults to `0`.
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

    final map = <DateTime, double>{};
    final startOfMonth = data.keys.first.startOfMonth;
    final endOfMonthDay = data.keys.first.endOfMonth.day;
    final lastDate = data.keys.max.date;
    for (var i = 0; i < endOfMonthDay; i++) {
      final date = startOfMonth.add(Duration(days: i));

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
          return maxValue;
      }
    }

    return map[current.previousDay]!;
  }
}

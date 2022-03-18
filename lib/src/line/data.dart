// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../utils.dart';

/// Type of the line chart.
///
/// If [LineChartType.undefined] is set, then:
/// - max values on Y axis will be determined from [LineChartData.data];
/// - dates on X axis will be determined from [LineChartData.data].
///
/// `Note` that [LineChartData.data] must contain at least 2 entries.
///
/// If [LineChartType.monthly] is set, then:
/// - max values on Y axis will be determined from [LineChartData.data];
/// - dates on X axis will be determined from [LineChartData.data].
///
/// `Note` that [LineChartData.data] must contain entries with the same month.
enum LineChartType {
  /// Means that chart will be built from data from [LineChartData.data].
  undefined,

  /// Means that chart will be built for the whole month even if it lacks
  /// data from [LineChartData.data].
  monthly,
}

/// Data for the [LineChart].
///
/// **Please note** that [data] must not be empty.
class LineChartData {
  /// Constructs an instance of [LineChartData].
  const LineChartData({
    required this.data,
    this.limit,
    this.type = LineChartType.monthly,
  }) : assert(data.length > 0);

  /// Map of the values that corresponds to the dates.
  ///
  /// It is a main source of [LineChart] data.
  ///
  /// If [LineChartType.undefined] is set, then [data] must contain at least 2
  /// entries.
  ///
  /// If [LineChartType.monthly] is set, then [data] must contain entries with
  /// the same month.
  final Map<DateTime, double> data;

  /// Optional limit, corresponds to the limit line on the chart. It is
  /// designed to be as a notifier of overuse/overdue.
  final double? limit;

  /// Type of the line chart.
  ///
  /// More info at [LineChartType].
  final LineChartType type;

  /// Gets divisions of the X axis.
  int get xAxisDivisions {
    int divisions;

    switch (type) {
      case LineChartType.undefined:
        assert(data.length < 2);
        divisions = data.length;
        break;

      case LineChartType.monthly:
        final endOfMonth = data.keys.first.endOfMonth;
        divisions = endOfMonth.day;
        break;
    }

    // plus 2 for first and last points of the chart.
    return divisions + 2;
  }
}

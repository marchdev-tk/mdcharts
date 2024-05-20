// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:mdcharts/src/_internal.dart';

/// Data for the [GridAxis].
abstract class GridAxisData<T> extends ChartData<T> {
  /// Constructs an instance of [GridAxisData].
  const GridAxisData({
    required super.data,
    super.predefinedMaxValue,
    super.maxValueRoundingMap = ChartData.defaultMaxValueRoundingMap,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
  });

  static TextSpan defaultXAxisLabelBuilder(DateTime key, TextStyle style) =>
      TextSpan(text: '${key.month}-${key.day}', style: style);
  static String defaultYAxisLabelBuilder(double value) => '$value';

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final RichLabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;
}

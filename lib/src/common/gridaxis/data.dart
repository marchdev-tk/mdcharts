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
    super.roundingMap = ChartData.defaultRoundingMap,
    this.xAxisLabelBuilder = defaultXAxisLabelBuilder,
    this.yAxisLabelBuilder = defaultYAxisLabelBuilder,
    TooltipBuilder<T>? titleBuilder,
    TooltipBuilder<T>? subtitleBuilder,
  })  : titleBuilder = titleBuilder ?? defaultTitleBuilder<T>,
        subtitleBuilder = subtitleBuilder ?? defaultSubtitleBuilder<T>;

  static TextSpan defaultXAxisLabelBuilder(DateTime key, TextStyle style) =>
      TextSpan(text: '${key.month}-${key.day}', style: style);
  static String defaultYAxisLabelBuilder(double value) => '$value';
  static String defaultTitleBuilder<T>(DateTime key, T value) =>
      '${key.year}-${key.month}-${key.day}';
  static String defaultSubtitleBuilder<T>(DateTime key, T value) =>
      value.toString();

  /// Text builder for the X axis label.
  ///
  /// If not set explicitly, [defaultXAxisLabelBuilder] will be used.
  final RichLabelBuilder<DateTime> xAxisLabelBuilder;

  /// Text builder for the Y axis label.
  ///
  /// If not set explicitly, [defaultYAxisLabelBuilder] will be used.
  final LabelBuilder<double> yAxisLabelBuilder;

  /// Text builder for the tooltip title.
  ///
  /// If not set explicitly, [defaultTitleBuilder] will be used.
  final TooltipBuilder<T> titleBuilder;

  /// Text builder for the tooltip subtitle.
  ///
  /// If not set explicitly, [defaultSubtitleBuilder] will be used.
  final TooltipBuilder<T> subtitleBuilder;
}

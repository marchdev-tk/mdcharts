// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Data for the [DonutChart].
class DonutChartData {
  /// Constructs an instance of [DonutChartData].
  const DonutChartData({
    required this.data,
    this.initialSelectedIndex,
    this.onSelectionChanged,
    this.onInscribedInCircleSizeChanged,
  });

  /// List of the section values.
  ///
  /// It is a main source of [DonutChart] data.
  final List<double> data;

  /// Index of the selected section.
  ///
  /// Defaults to `null`.
  final int? initialSelectedIndex;

  /// Callbacks that reports that selected section index has changed.
  final ValueChanged<int>? onSelectionChanged;

  /// Callbacks that reports that size of the square inscribed in circle has
  /// changed.
  final ValueChanged<double>? onInscribedInCircleSizeChanged;

  /// Gets total value of [data].
  double get total =>
      data.fold<double>(0, (prevValue, value) => prevValue + value);

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  DonutChartData copyWith({
    bool allowNullSelectedIndex = false,
    List<double>? data,
    int? initialSelectedIndex,
  }) =>
      DonutChartData(
        data: data ?? this.data,
        initialSelectedIndex: allowNullSelectedIndex
            ? initialSelectedIndex
            : initialSelectedIndex ?? this.initialSelectedIndex,
      );

  @override
  int get hashCode => Object.hashAll(data) ^ initialSelectedIndex.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DonutChartData &&
      listEquals(data, other.data) &&
      initialSelectedIndex == other.initialSelectedIndex;
}

// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:mdcharts/src/_internal.dart';

/// Data for the [GaugeChart].
class GaugeChartData {
  /// Constructs an instance of [GaugeChartData].
  const GaugeChartData({
    required this.data,
    this.selectedIndex,
    this.onSelectionChanged,
  });

  /// List of the section values.
  ///
  /// It is a main source of [GaugeChart] data.
  final List<double> data;

  /// Index of the selected section.
  ///
  /// In order to change currently selected section this value must be changed.
  ///
  /// Defaults to `null`.
  final int? selectedIndex;

  /// Callbacks that reports that selected section index has changed.
  ///
  /// If this predicate return `true` - animation will be triggered,
  /// otherwise - animation won't be triggered.
  final IndexedPredicate? onSelectionChanged;

  /// Gets total value of [data].
  double get total =>
      data.fold<double>(0, (prevValue, value) => prevValue + value);

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  GaugeChartData copyWith({
    bool allowNullSelectedIndex = false,
    List<double>? data,
    int? selectedIndex,
    IndexedPredicate? onSelectionChanged,
  }) =>
      GaugeChartData(
        data: data ?? this.data,
        selectedIndex: allowNullSelectedIndex
            ? selectedIndex
            : selectedIndex ?? this.selectedIndex,
        onSelectionChanged: onSelectionChanged ?? this.onSelectionChanged,
      );

  @override
  int get hashCode =>
      Object.hashAll(data) ^
      selectedIndex.hashCode ^
      onSelectionChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      other is GaugeChartData &&
      listEquals(data, other.data) &&
      selectedIndex == other.selectedIndex &&
      onSelectionChanged == other.onSelectionChanged;
}

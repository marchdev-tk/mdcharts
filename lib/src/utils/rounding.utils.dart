// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'decimal.utils.dart';

/// Rounding method that ceils [initalValue] so, it could be divided by
/// [yAxisDivisions] with "beautiful" integer chunks.
///
/// Example 1:
/// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
/// - maxValue = 83 (from data).
///
/// So, based on these values maxValue will be rounded to `90`.
///
/// Example 2:
/// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
/// - maxValue = -83 (from data).
///
/// So, based on these values maxValue will be rounded to `-75`.
double getCeilRoundedValue(
  Map<num, num> roundingMap,
  double initalValue,
  int yAxisDivisions,
) {
  if (initalValue == 0) {
    return roundingMap.entries.first.value.toDouble();
  }

  if (initalValue < 0) {
    final roundedValue = getFloorRoundedValue(
      roundingMap,
      initalValue.abs(),
      yAxisDivisions,
    );
    return -roundedValue;
  }

  final yDivisions = yAxisDivisions + 1;
  final complement = roundingMap.entries
      .firstWhere(
        (entry) => initalValue < entry.key,
        orElse: () => roundingMap.entries.last,
      )
      .value;

  if (initalValue < 1) {
    var rounded = initalValue;
    var multiplier = 1.0;

    while (mult(complement, multiplier).remainder(1) != 0) {
      rounded = mult(rounded, 10);
      multiplier = mult(multiplier, 10);
    }

    rounded = rounded.ceilToDouble();

    while (rounded % yDivisions != 0) {
      rounded = add(rounded, mult(complement, multiplier));
    }

    return div(rounded, multiplier);
  }

  var rounded = sub(add(initalValue, complement), initalValue % complement);

  while (rounded % yDivisions != 0) {
    rounded = add(rounded, complement);
  }

  return rounded;
}

/// Rounding method that floors [initalValue] so, it could be divided by
/// [yAxisDivisions] with "beautiful" integer chunks.
///
/// Example:
/// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
/// - minValue = 83 (from data).
///
/// So, based on these values maxValue will be rounded to `75`.
///
/// Example 2:
/// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
/// - maxValue = -83 (from data).
///
/// So, based on these values maxValue will be rounded to `-90`.
double getFloorRoundedValue(
  Map<num, num> roundingMap,
  double initalValue,
  int yAxisDivisions,
) {
  if (initalValue == 0) {
    return 0;
  }

  if (initalValue < 0) {
    final roundedValue = getCeilRoundedValue(
      roundingMap,
      initalValue.abs(),
      yAxisDivisions,
    );
    return -roundedValue;
  }

  final yDivisions = yAxisDivisions + 1;
  final complement = roundingMap.entries
      .firstWhere(
        (entry) => initalValue < entry.key,
        orElse: () => roundingMap.entries.last,
      )
      .value;

  if (initalValue < 1) {
    var rounded = initalValue;
    var multiplier = 1.0;

    while (mult(complement, multiplier).remainder(1) != 0) {
      rounded = mult(rounded, 10);
      multiplier = mult(multiplier, 10);
    }

    rounded = rounded.ceilToDouble();

    while (rounded % yDivisions != 0) {
      rounded = sub(rounded, mult(complement, multiplier));
    }

    return div(rounded, multiplier);
  }

  var rounded = sub(initalValue, initalValue % complement);

  while (rounded % yDivisions != 0) {
    rounded = sub(rounded, complement);
  }

  return rounded;
}

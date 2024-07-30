// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'decimal.utils.dart';

// TODO: reconsider rounding map for min values
// ! (test on positive data, with YAxisBasis.value, minValue must be less than 10)

/// Rounding method that rounds [initalMaxValue] so, it could be divided by
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
double getRoundedMaxValue(
  Map<num, num> roundingMap,
  double initalMaxValue,
  int yAxisDivisions,
) {
  if (initalMaxValue < 0) {
    final roundedValue = getRoundedMinValue(
      roundingMap,
      initalMaxValue.abs(),
      yAxisDivisions,
    );
    return -roundedValue;
  }

  final yDivisions = yAxisDivisions + 1;
  final complement = roundingMap.entries
      .firstWhere(
        (entry) => initalMaxValue < entry.key,
        orElse: () => roundingMap.entries.last,
      )
      .value;

  if (initalMaxValue < 1) {
    var rounded = initalMaxValue;
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

  var rounded =
      sub(add(initalMaxValue, complement), initalMaxValue % complement);

  while (rounded % yDivisions != 0) {
    rounded = add(rounded, complement);
  }

  return rounded;
}

/// Rounding method that rounds [initalMinValue] so, it could be divided by
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
double getRoundedMinValue(
  Map<num, num> roundingMap,
  double initalMinValue,
  int yAxisDivisions,
) {
  if (initalMinValue < 0) {
    final roundedValue = getRoundedMaxValue(
      roundingMap,
      initalMinValue.abs(),
      yAxisDivisions,
    );
    return -roundedValue;
  }

  final yDivisions = yAxisDivisions + 1;
  final complement = roundingMap.entries
      .firstWhere(
        (entry) => initalMinValue < entry.key,
        orElse: () => roundingMap.entries.last,
      )
      .value;

  if (initalMinValue < 1) {
    var rounded = initalMinValue;
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

  var rounded = sub(initalMinValue, initalMinValue % complement);

  while (rounded % yDivisions != 0) {
    rounded = sub(rounded, complement);
  }

  return rounded;
}

// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'decimal.utils.dart';

/// Gets rounding complement based on [roundingMap] for [initalValue].
double getRoundingComplement(
  Map<String, num> roundingMap,
  double initalValue,
) {
  final value = initalValue.abs();

  final complement = roundingMap.entries
      .firstWhere(
        (entry) => value < double.parse(entry.key),
        orElse: () => roundingMap.entries.last,
      )
      .value;

  return complement.toDouble();
}

/// Rounding method that ceils [initalValue] using provided [roundingComplement].
double ceilRoundValue(
  double roundingComplement,
  double initalValue,
) {
  if (initalValue == 0) {
    return roundingComplement;
  }

  if (initalValue < 0) {
    final roundedValue = floorRoundValue(
      roundingComplement,
      initalValue.abs(),
    );
    return -roundedValue;
  }

  final complement = roundingComplement;

  if (complement < 1) {
    var rounded = initalValue;
    var multiplier = 1.0;

    while (mult(complement, multiplier).remainder(1) != 0) {
      rounded = mult(rounded, 10);
      multiplier = mult(multiplier, 10);
    }

    rounded = rounded.ceilToDouble();

    while (rounded % 1 != 0) {
      rounded = add(rounded, mult(complement, multiplier));
    }

    return div(rounded, multiplier);
  }

  var rounded = sub(add(initalValue, complement), initalValue % complement);

  while (rounded % 1 != 0) {
    rounded = add(rounded, complement);
  }

  return rounded;
}

/// Rounding method that floors [initalValue] using provided [roundingComplement].
double floorRoundValue(
  double roundingComplement,
  double initalValue,
) {
  if (initalValue == 0) {
    return 0;
  }

  if (initalValue < 0) {
    final roundedValue = ceilRoundValue(
      roundingComplement,
      initalValue.abs(),
    );
    return -roundedValue;
  }

  final complement = roundingComplement;

  if (complement < 1) {
    var rounded = initalValue;
    var multiplier = 1.0;

    while (mult(complement, multiplier).remainder(1) != 0) {
      rounded = mult(rounded, 10);
      multiplier = mult(multiplier, 10);
    }

    rounded = rounded.floorToDouble();

    while (rounded % 1 != 0) {
      rounded = sub(rounded, mult(complement, multiplier));
    }

    return div(rounded, multiplier);
  }

  var rounded = sub(initalValue, initalValue % complement);

  while (rounded % 1 != 0) {
    rounded = sub(rounded, complement);
  }

  return rounded;
}

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
@Deprecated('Use conjunction of getRoundingComplement and ceilRoundValue')
double getCeilRoundedValue(
  Map<String, num> roundingMap,
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
  final complement = getRoundingComplement(roundingMap, initalValue);

  if (initalValue.abs() < 1) {
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
@Deprecated('Use conjunction of getRoundingComplement and floorRoundValue')
double getFloorRoundedValue(
  Map<String, num> roundingMap,
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
  final complement = getRoundingComplement(roundingMap, initalValue);

  if (initalValue.abs() < 1) {
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

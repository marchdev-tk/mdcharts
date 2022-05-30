// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Rounding method that rounds [initalMaxValue] so, it could be divided by
/// [yAxisDivisions] with "beautiful" integer chunks.
///
/// Example:
/// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
/// - maxValue = 83 (from data).
///
/// So, based on these values maxValue will be rounded to `90`.
double getRoundedMaxValue(
  Map<num, num> roundingMap,
  double initalMaxValue,
  int yAxisDivisions,
) {
  final yDivisions = yAxisDivisions == 0 ? 1 : yAxisDivisions + 1;
  final complement = roundingMap.entries
      .firstWhere(
        (entry) => initalMaxValue < entry.key,
        orElse: () => roundingMap.entries.last,
      )
      .value;
  var rounded = initalMaxValue + complement - initalMaxValue % complement;

  while (rounded % yDivisions != 0) {
    rounded += complement;
  }

  return rounded;
}

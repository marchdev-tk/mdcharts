// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// On which Y axis label values gradation should be based on.
enum YAxisBaseline {
  /// Y axis label values will be divided and calculated with zero basis,
  /// so zero will always be on the grid.
  ///
  /// This is default option.
  zero,

  /// Y axis label values will be divided and calculated based on min-max values
  /// from the chart data.
  axis,
}

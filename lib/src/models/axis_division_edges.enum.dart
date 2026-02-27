// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Axis division edges.
enum AxisDivisionEdges {
  /// No edges.
  ///
  /// Default option.
  none,

  /// Left edge.
  left,

  /// Top edge.
  top,

  /// Right edge.
  right,

  /// Bottom edge.
  bottom,

  /// [left] and [right] edges.
  horizontal,

  /// [top] and [bottom] edges.
  vertical,

  /// All edges.
  all,
}

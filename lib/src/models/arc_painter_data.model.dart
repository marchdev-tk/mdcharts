// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

/// Holder object of the start/end angles of the path alongside with path data
/// itself that is mostly required for hit testing.
class ArcPainterData {
  /// Constructs an instance of [ArcPainterData].
  const ArcPainterData(
    this.startAngle,
    this.endAngle,
    this.path,
  );

  /// Start andgle of the path.
  final double startAngle;

  /// End andgle of the path.
  final double endAngle;

  /// Path.
  final Path path;
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

/// Contains various customization options for the [LineChart].
class LineChartStyle {
  /// Constructs an instance of [LineChartStyle].
  const LineChartStyle({
    this.limitStyle = const LineChartLimitStyle(),
  });

  final LineChartLimitStyle limitStyle;
}

/// Contains various customization options for the [LineChart], specifically
/// for limit line and label.
class LineChartLimitStyle {
  /// Constructs an instance of [LineChartLimitStyle].
  const LineChartLimitStyle({
    this.labelStyle = defaultStyle,
    this.labelOveruseStyle = defaultOveruseStyle,
    this.labelTextPadding = const EdgeInsets.fromLTRB(11, 3, 14, 3),
    this.labelColor = const Color(0xFFFFFFFF),
    this.dashColor = const Color(0x80FFFFFF),
    this.dashStroke = 1,
    this.dashSize = 2,
    this.gapSize = 2,
  });

  static const defaultStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFF000000),
  );
  static const defaultOveruseStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFFED2A24),
  );

  /// TODO
  final TextStyle labelStyle;

  /// TODO
  final TextStyle labelOveruseStyle;

  /// TODO
  final EdgeInsets labelTextPadding;

  /// TODO
  final Color labelColor;

  /// TODO
  final Color dashColor;

  /// TODO
  final double dashStroke;

  /// TODO
  final double dashSize;

  /// TODO
  final double gapSize;
}

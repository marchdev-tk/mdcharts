// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// TODO
class LineChart extends StatelessWidget {
  /// Constructs an instance of [LineChart].
  const LineChart({
    Key? key,
    required this.data,
    this.style = const LineChartStyle(),
    this.settings = const LineChartSettings(),
  }) : super(key: key);

  /// TODO
  final LineChartData data;

  /// TODO
  final LineChartStyle style;

  /// TODO
  final LineChartSettings settings;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        data,
        style,
        settings,
      ),
      foregroundPainter: null,
      size: Size.infinite,
    );
  }
}

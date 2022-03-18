// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'data.dart';
import 'painter.dart';
import 'style.dart';

class LineChart extends StatelessWidget {
  const LineChart({
    Key? key,
    required this.data,
    this.style = const LineChartStyle(),
  }) : super(key: key);

  final LineChartData data;
  final LineChartStyle style;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        data,
        style,
      ),
      foregroundPainter: null,
      size: Size.infinite,
    );
  }
}

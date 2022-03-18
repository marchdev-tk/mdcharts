// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'data.dart';
import 'style.dart';

class LineChartPainter extends CustomPainter {
  const LineChartPainter(
    this.data,
    this.style,
  );

  final LineChartData data;
  final LineChartStyle style;

  void paintGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.grey;

    final xDivisions = data.xAxisDivisions;
    final widthFraction = size.width / xDivisions;
    for (var i = 1; i <= xDivisions; i++) {
      canvas.drawLine(
        Offset(widthFraction * i, 0),
        Offset(widthFraction * i, size.height),
        gridPaint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

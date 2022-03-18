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

  double getWidthFraction(Size size) {
    final xDivisions = data.xAxisDivisions;
    final widthFraction = size.width / xDivisions;

    return widthFraction;
  }

  double getHeightFraction(Size size) {
    final yDivisions = data.yAxisDivisions;
    final heightFraction = size.height / yDivisions;

    return heightFraction;
  }

  double normalize(double value) {
    final max = data.maxValue;
    return value / (max * 1.05);
  }

  void paintGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.white60;

    final xDivisions = data.xAxisDivisions;
    final widthFraction = size.width / xDivisions;
    for (var i = 1; i < xDivisions; i++) {
      canvas.drawLine(
        Offset(widthFraction * i, 0),
        Offset(widthFraction * i, size.height),
        gridPaint,
      );
    }

    final yDivisions = data.yAxisDivisions;
    final heightFraction = size.height / yDivisions;
    for (var i = 1; i < yDivisions; i++) {
      canvas.drawLine(
        Offset(0, heightFraction * i),
        Offset(size.width, heightFraction * i),
        gridPaint,
      );
    }
  }

  void paintChartLine(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final map = data.typedData;

    final widthFraction = getWidthFraction(size);
    final path = Path();

    final isDescending = data.dataType == LineChartDataType.unidirectional &&
        data.dataDirection == LineChartDataDirection.descending;

    if (!isDescending) {
      path.moveTo(0, size.height);
    }

    for (var i = 0; i < map.length; i++) {
      final value = map.entries.elementAt(i).value;
      final normalizedValue = normalize(value);

      final x = widthFraction * (i + 1);
      final y = size.height - size.height * normalizedValue;

      path.lineTo(x, y);
      if (i == map.length - 1) {
        path.moveTo(x, y);
      }
    }

    canvas.drawPath(path, pathPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintChartLine(canvas, size);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

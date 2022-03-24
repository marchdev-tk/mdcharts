// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:cross_platform/cross_platform.dart';

import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Line chart.
class LineChart extends StatefulWidget {
  /// Constructs an instance of [LineChart].
  const LineChart({
    Key? key,
    required this.data,
    this.style = const LineChartStyle(),
    this.settings = const LineChartSettings(),
  }) : super(key: key);

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  double? xPosition;

  void _clearXPosition([dynamic details]) {
    setState(() => xPosition = null);
  }

  void _setXPosition(dynamic details) {
    setState(() => xPosition = details.localPosition.dx);
  }

  @override
  Widget build(BuildContext context) {
    final customPaint = CustomPaint(
      painter: LineChartPainter(
        widget.data,
        widget.style,
        widget.settings,
        xPosition,
      ),
      size: Size.infinite,
    );

    if (Platform.isMobile) {
      return GestureDetector(
        onHorizontalDragCancel: _clearXPosition,
        onHorizontalDragEnd: _clearXPosition,
        onHorizontalDragUpdate: _setXPosition,
        child: customPaint,
      );
    } else {
      return MouseRegion(
        onExit: _clearXPosition,
        onHover: _setXPosition,
        child: customPaint,
      );
    }
  }
}

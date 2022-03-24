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
    this.padding,
  }) : super(key: key);

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Padding around the chart.
  ///
  /// If no set, will be used default one:
  /// - left/right/bottom: `0`;
  /// - top: dynamic value that depends on the style of the tooltip, more info
  /// at [LineChartPointStyle.tooltipHeight].
  final EdgeInsets? padding;

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
    Widget child = CustomPaint(
      painter: LineChartPainter(
        widget.data,
        widget.style,
        widget.settings,
        xPosition,
      ),
      size: Size.infinite,
    );

    if (Platform.isMobile) {
      child = GestureDetector(
        onHorizontalDragCancel: _clearXPosition,
        onHorizontalDragEnd: _clearXPosition,
        onHorizontalDragUpdate: _setXPosition,
        child: child,
      );
    } else {
      child = MouseRegion(
        onExit: _clearXPosition,
        onHover: _setXPosition,
        child: child,
      );
    }

    return Padding(
      padding: widget.padding ??
          EdgeInsets.only(top: widget.style.pointStyle.tooltipHeight),
      child: child,
    );
  }
}

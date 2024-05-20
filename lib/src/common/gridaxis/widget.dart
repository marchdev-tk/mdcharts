// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'cache.dart';
import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Charts Grid and Axis.
class GridAxis extends StatefulWidget {
  /// Constructs an instance of [GridAxis].
  const GridAxis({
    super.key,
    required this.data,
    this.style = const GridAxisStyle(),
    this.settings = const GridAxisSettings(),
    this.padding,
    required this.yAxisLabelWidth,
  });

  /// Set of required (and optional) data to construct the candlestick chart.
  final GridAxisData data;

  /// Provides various customizations for the candlestick chart.
  final GridAxisStyle style;

  /// Provides various settings for the candlestick chart.
  final GridAxisSettings settings;

  /// Padding around the chart.
  final EdgeInsets? padding;

  /// Y axis label width change notifier.
  final Sink<double> yAxisLabelWidth;

  @override
  State<GridAxis> createState() => _GridAxisState();
}

class _GridAxisState extends State<GridAxis> {
  final cache = GridAxisCacheHolder();

  @override
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: GridAxisPainter(
        cache,
        widget.data,
        widget.style,
        widget.settings,
        widget.yAxisLabelWidth.add,
      ),
      size: Size.infinite,
    );

    if (widget.settings.showAxisXLabels) {
      grid = Column(
        children: [
          Expanded(child: grid),
          SizedBox(height: widget.style.axisStyle.xAxisLabelTopMargin),
          SizedBox(height: widget.style.axisStyle.labelHeight),
        ],
      );
    }

    if (widget.padding != null) {
      grid = Padding(
        padding: widget.padding!,
        child: grid,
      );
    }

    return RepaintBoundary(child: grid);
  }
}

// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../../_internal.dart';

/// Charts Grid and Axis.
class GridAxis extends StatelessWidget {
  /// Constructs an instance of [GridAxis].
  const GridAxis({
    super.key,
    required this.cache,
    required this.data,
    this.style = const GridAxisStyle(),
    this.settings = const GridAxisSettings(),
    this.padding,
    required this.yAxisLabelWidth,
  });

  /// Cache holder of the GridAxis data that requries heavy computing.
  final GridAxisCacheHolder cache;

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
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: GridAxisPainter(
        cache,
        data,
        style,
        settings,
        yAxisLabelWidth.add,
      ),
      size: Size.infinite,
    );

    if (settings.showAxisXLabels) {
      grid = Column(
        children: [
          Expanded(child: grid),
          SizedBox(height: style.axisStyle.xAxisLabelTopMargin),
          SizedBox(height: style.axisStyle.labelHeight),
        ],
      );
    }

    if (padding != null) {
      grid = Padding(
        padding: padding!,
        child: grid,
      );
    }

    return RepaintBoundary(child: grid);
  }
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Gauge chart.
class GaugeChart extends StatefulWidget {
  /// Constructs an instance of [GaugeChart].
  const GaugeChart({
    Key? key,
    required this.data,
    this.style = const GaugeChartStyle(),
    this.settings = const GaugeChartSettings(),
  }) : super(key: key);

  /// Set of required (and optional) data to construct the line chart.
  final GaugeChartData data;

  /// Provides various customizations for the line chart.
  final GaugeChartStyle style;

  /// Provides various settings for the line chart.
  final GaugeChartSettings settings;

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GaugeChartPainter(
        widget.data,
        widget.style,
        widget.settings,
        1,
      ),
      size: Size.infinite,
    );
  }
}

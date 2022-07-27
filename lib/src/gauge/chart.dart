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

class _GaugeChartState extends State<GaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  GaugeChartData? oldData;

  GaugeChartData getAdjustedOldData() {
    var old = oldData ??
        widget.data.copyWith(data: List.filled(widget.data.data.length, 0));

    if (old.data.length >= widget.data.data.length) {
      old = old.copyWith(data: old.data.sublist(0, widget.data.data.length));
    }
    if (old.data.length <= widget.data.data.length) {
      for (var i = 0; i < widget.data.data.length - old.data.length; i++) {
        old.data.add(0);
      }
    }

    return old;
  }

  void startAnimation() {
    _valueController.forward(from: 0);
  }

  @override
  void initState() {
    _valueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
    startAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GaugeChart oldWidget) {
    oldData = oldWidget.data;
    startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final oldData = getAdjustedOldData();

    return AnimatedBuilder(
      animation: _valueAnimation,
      builder: (context, _) {
        return CustomPaint(
          painter: GaugeChartPainter(
            widget.data,
            widget.style,
            widget.settings,
            oldData,
            _valueAnimation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

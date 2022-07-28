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

  late GaugeChartData data;
  GaugeChartData? oldData;

  void adjustDatas() {
    var old = oldData ?? data.copyWith(data: List.filled(data.data.length, 0));

    if (old.data.length >= data.data.length) {
      data = data.copyWith(
        data: [
          ...data.data,
          ...List.filled(old.data.length - data.data.length, 0),
        ],
      );
    }
    if (old.data.length <= data.data.length) {
      final oldDataLength = old.data.length;
      for (var i = 0; i < data.data.length - oldDataLength; i++) {
        old = old.copyWith(data: [...old.data, 0]);
      }
    }

    oldData = old;
  }

  void startAnimation() {
    if (data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
  }

  @override
  void initState() {
    data = widget.data;

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
    data = widget.data;
    oldData = oldWidget.data;
    startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    adjustDatas();

    return AnimatedBuilder(
      animation: _valueAnimation,
      builder: (context, _) {
        return CustomPaint(
          painter: GaugeChartPainter(
            data,
            widget.style,
            widget.settings,
            oldData!,
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

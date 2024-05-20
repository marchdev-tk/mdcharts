// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cross_platform/cross_platform.dart';
import 'package:flutter/widgets.dart';
import 'package:mdcharts/_internal.dart';

import 'cache.dart';
import 'painter.dart';

/// Line chart.
class LineChart extends StatefulWidget {
  /// Constructs an instance of [LineChart].
  const LineChart({
    super.key,
    required this.data,
    this.style = const LineChartStyle(),
    this.settings = const LineChartSettings(),
    this.padding,
  });

  /// Set of required (and optional) data to construct the line chart.
  final LineChartData data;

  /// Provides various customizations for the line chart.
  final LineChartStyle style;

  /// Provides various settings for the line chart.
  final LineChartSettings settings;

  /// Padding around the chart.
  ///
  /// If not set, will be used [LineChartPointStyle.defaultChartPadding].
  final EdgeInsets? padding;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late LineChartData data;
  LineChartData? oldData;
  int? oldDataHashCode;

  double? xPosition;

  void _adjustOldData() {
    oldData ??= data.copyWith(
      data: Map.fromEntries(
        data.data.entries.map((e) => MapEntry(e.key, 0)),
      ),
    );
  }

  void _clearXPosition([dynamic details]) {
    setState(() => xPosition = null);
  }

  void _setXPosition(dynamic details) {
    setState(() => xPosition = details.localPosition.dx);
  }

  void _startAnimation() {
    if (data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
  }

  @override
  void initState() {
    data = widget.data;
    _adjustOldData();
    oldDataHashCode = oldData.hashCode;
    cache.add(data.hashCode, oldDataHashCode);

    _valueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
    _startAnimation();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LineChart oldWidget) {
    data = widget.data;
    if (data != oldWidget.data) {
      oldData = oldWidget.data;
    }
    oldDataHashCode = oldData.hashCode;
    _adjustOldData();
    if (data != oldData) {
      cache.add(data.hashCode, oldDataHashCode);
    }
    _startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget chart = AnimatedBuilder(
      animation: _valueAnimation,
      builder: (context, _) {
        return CustomPaint(
          painter: LineChartPainter(
            widget.data,
            widget.style,
            widget.settings,
            oldDataHashCode!,
            widget.padding,
            xPosition,
            _valueAnimation.value,
          ),
          size: Size.infinite,
        );
      },
    );

    if (widget.settings.selectionEnabled) {
      if (Platform.isMobile) {
        chart = GestureDetector(
          onHorizontalDragCancel: _clearXPosition,
          onHorizontalDragEnd: _clearXPosition,
          onHorizontalDragStart: _setXPosition,
          onHorizontalDragUpdate: _setXPosition,
          child: chart,
        );
      } else {
        chart = MouseRegion(
          onExit: _clearXPosition,
          onHover: _setXPosition,
          child: chart,
        );
      }
    }

    final xAxisLabels = CustomPaint(
      painter: LineChartXAxisLabelPainter(
        widget.data,
        widget.style,
        widget.settings,
        xPosition,
      ),
      size: Size.fromHeight(widget.style.axisStyle.labelHeight),
    );

    Widget child;
    if (widget.settings.showAxisXLabels) {
      child = Column(
        children: [
          Expanded(child: chart),
          SizedBox(height: widget.style.axisStyle.xAxisLabelTopMargin),
          xAxisLabels,
        ],
      );
    } else {
      child = chart;
    }

    return RepaintBoundary(
      child: Padding(
        padding: widget.padding ?? widget.style.pointStyle.defaultChartPadding,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

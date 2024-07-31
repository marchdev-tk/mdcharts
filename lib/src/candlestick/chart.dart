// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:cross_platform/cross_platform.dart';
import 'package:flutter/widgets.dart';
import 'package:mdcharts/src/_internal.dart';
import 'package:rxdart/rxdart.dart';

import 'painter.dart';

/// Candlestick chart.
class CandlestickChart extends StatefulWidget {
  /// Constructs an instance of [CandlestickChart].
  const CandlestickChart({
    super.key,
    required this.data,
    this.style = const CandlestickChartStyle(),
    this.settings = const CandlestickChartSettings(),
    this.padding,
  });

  /// Set of required (and optional) data to construct the candlestick chart.
  final CandlestickChartData data;

  /// Provides various customizations for the candlestick chart.
  final CandlestickChartStyle style;

  /// Provides various settings for the candlestick chart.
  final CandlestickChartSettings settings;

  /// Padding around the chart.
  ///
  /// If not set, will be used [TooltipStyle.defaultChartPadding].
  final EdgeInsets? padding;

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart>
    with SingleTickerProviderStateMixin {
  final _cache = GridAxisCacheHolder();
  final _yAxisLabelWidth = BehaviorSubject<double>.seeded(0);

  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late CandlestickChartData data;
  CandlestickChartData? oldData;
  int? oldDataHashCode;

  Offset? position;

  void _adjustOldData() {
    oldData ??= data.copyWith(
      data: Map.fromEntries(
        data.data.entries.map(
          (e) => MapEntry(
            e.key,
            const CandlestickData.zero(),
          ),
        ),
      ),
    );
  }

  void _clearPosition([dynamic details]) {
    setState(() => position = null);
  }

  void _setPosition(dynamic details) {
    setState(() => position = details.localPosition);
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
    _cache.add(data.hashCode, oldDataHashCode);

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
  void didUpdateWidget(covariant CandlestickChart oldWidget) {
    data = widget.data;
    if (data != oldWidget.data) {
      oldData = oldWidget.data;
    }
    oldDataHashCode = oldData.hashCode;
    _adjustOldData();
    if (data != oldData) {
      _cache.add(data.hashCode, oldDataHashCode);
    }
    _startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildChart(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;

    return StreamBuilder<double>(
      stream: _yAxisLabelWidth.distinct(),
      initialData: _yAxisLabelWidth.value,
      builder: (context, snapshot) {
        var spacing = .0;
        var displaceInset = .0;
        var maxWidthAdjusted = maxWidth;
        if (widget.settings.yAxisLayout == YAxisLayout.displace) {
          spacing = widget.settings.yAxisLabelSpacing;
          displaceInset = snapshot.requireData + spacing;
          maxWidthAdjusted = maxWidth - displaceInset;
        }

        Widget chart = AnimatedBuilder(
          animation: _valueAnimation,
          builder: (context, _) {
            return CustomPaint(
              painter: CandlestickChartPainter(
                _cache,
                widget.data,
                widget.style,
                widget.settings,
                oldData!,
                oldDataHashCode!,
                position,
                _valueAnimation.value,
              ),
              size: Size(
                math.max(0, maxWidthAdjusted),
                double.infinity,
              ),
            );
          },
        );

        if (widget.settings.selectionEnabled) {
          if (Platform.isMobile) {
            chart = GestureDetector(
              onPanCancel: _clearPosition,
              onPanEnd: _clearPosition,
              onPanStart: _setPosition,
              onPanUpdate: _setPosition,
              child: chart,
            );
          } else {
            chart = MouseRegion(
              onExit: _clearPosition,
              onHover: _setPosition,
              child: chart,
            );
          }
        }

        final xAxisLabels = CustomPaint(
          painter: XAxisLabelPainter(
            widget.data,
            widget.style,
            widget.settings,
            position?.dx,
          ),
          size: Size(
            math.max(0, maxWidthAdjusted),
            widget.style.axisStyle.labelHeight,
          ),
        );

        Widget child;
        if (widget.settings.showAxisXLabels) {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: chart),
              SizedBox(height: widget.style.axisStyle.xAxisLabelTopMargin),
              xAxisLabels,
            ],
          );
        } else {
          child = chart;
        }

        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding:
            widget.padding ?? widget.style.tooltipStyle.defaultChartPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final chart = Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: GridAxis(
                    cache: _cache,
                    data: data,
                    style: widget.style,
                    settings: widget.settings,
                    yAxisLabelWidth: _yAxisLabelWidth,
                  ),
                ),
                Positioned.fill(
                  child: _buildChart(constraints),
                ),
              ],
            );

            return chart;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cache.clear();
    _yAxisLabelWidth.close();
    _valueController.dispose();
    super.dispose();
  }
}

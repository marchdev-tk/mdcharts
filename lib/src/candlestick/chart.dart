// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:cross_platform/cross_platform.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../common.dart';
import 'cache.dart';
import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

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
  /// If not set, will be used default one:
  /// - left/right/bottom: `0`;
  /// - top: dynamic value that depends on the style of the tooltip, more info
  /// at [LineChartPointStyle.tooltipHeight].
  final EdgeInsets? padding;

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart>
    with SingleTickerProviderStateMixin {
  final _yAxisLabelWidth = BehaviorSubject<double>.seeded(0);

  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late CandlestickChartData data;
  CandlestickChartData? oldData;
  int? oldDataHashCode;

  double? xPosition;

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
  void didUpdateWidget(covariant CandlestickChart oldWidget) {
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

  Widget _buildChart(double maxWidth) {
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
                widget.data,
                widget.style,
                widget.settings,
                oldData!,
                oldDataHashCode!,
                widget.padding,
                xPosition,
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
          painter: CandlestickChartXAxisLabelPainter(
            widget.data,
            widget.style,
            widget.settings,
            xPosition,
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

  Widget _buildContent(BoxConstraints constraints) {
    final maxContentWidth = constraints.maxWidth -
        (widget.padding?.horizontal ??
            widget.style.candleStickStyle.candleStroke);

    return Padding(
      padding: widget.padding ??
          EdgeInsets.fromLTRB(
            widget.style.candleStickStyle.candleStroke / 2,
            0,
            widget.style.candleStickStyle.candleStroke / 2,
            0,
          ),
      //  ??
      //     EdgeInsets.fromLTRB(
      //       widget.style.pointStyle.tooltipHorizontalOverflowWidth,
      //       widget.style.pointStyle.tooltipHeight,
      //       widget.style.pointStyle.tooltipHorizontalOverflowWidth,
      //       0,
      //     ),
      child: _buildChart(maxContentWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chart = Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _Grid(
                  data: data,
                  style: widget.style,
                  settings: widget.settings,
                  padding: widget.padding,
                  yAxisLabelWidth: _yAxisLabelWidth,
                ),
              ),
              Positioned.fill(
                child: _buildContent(constraints),
              ),
            ],
          );

          return chart;
        },
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.data,
    required this.style,
    required this.settings,
    required this.padding,
    required this.yAxisLabelWidth,
  });

  final CandlestickChartData data;
  final CandlestickChartStyle style;
  final CandlestickChartSettings settings;
  final EdgeInsetsGeometry? padding;
  final BehaviorSubject<double> yAxisLabelWidth;

  @override
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: CandlestickChartGridPainter(
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

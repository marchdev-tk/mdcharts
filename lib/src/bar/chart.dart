// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Bar chart.
class BarChart extends StatefulWidget {
  /// Constructs an instance of [BarChart].
  const BarChart({
    Key? key,
    required this.data,
    this.style = const BarChartStyle(),
    this.settings = const BarChartSettings(),
    this.padding,
  }) : super(key: key);

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the bar chart.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Padding of the bar chart.
  ///
  /// If chart will not be visible entirely, padding will be added as
  /// a scroll padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late StreamController<DateTime> _selectedPeriod;
  StreamSubscription<DateTime>? _sub;

  double _getItemWidth() {
    final canDraw = widget.data.canDraw;
    final barItemQuantity = canDraw ? widget.data.data.values.first.length : 0;
    final barWidth = widget.style.barStyle.width;
    final barSpacing = widget.settings.barSpacing;

    final itemWidth =
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    return itemWidth;
  }

  double _getChartWidth(double maxWidth) {
    final itemLength = widget.data.data.length;
    final itemSpacing = widget.settings.itemSpacing;

    final itemWidth = _getItemWidth();
    final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;

    return math.max(maxWidth, totalWidth);
  }

  @override
  void initState() {
    _selectedPeriod = StreamController<DateTime>.broadcast();
    if (widget.data.selectedPeriod != null) {
      _selectedPeriod.add(widget.data.selectedPeriod!);
    }
    if (widget.data.onSelectedPeriodChanged != null) {
      _sub = _selectedPeriod.stream.listen(widget.data.onSelectedPeriodChanged);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    _sub?.cancel();
    if (widget.data.selectedPeriod != null) {
      _selectedPeriod.add(widget.data.selectedPeriod!);
    }
    if (widget.data.onSelectedPeriodChanged != null) {
      _sub = _selectedPeriod.stream.listen(widget.data.onSelectedPeriodChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: BarChartGridPainter(
        widget.data,
        widget.style,
        widget.settings,
      ),
      size: Size.infinite,
    );

    if (widget.settings.showAxisXLabels) {
      grid = Column(
        children: [
          Expanded(child: grid),
          SizedBox(height: widget.style.axisStyle.xAxisLabelTopMargin),
          SizedBox(
            height: _XAxisLabel.getEstimatedHeight(
              widget.style.axisStyle,
              widget.style.axisStyle.xAxisLabelStyle,
            ),
          ),
        ],
      );
    }

    if (widget.padding != null) {
      grid = Padding(
        padding: widget.padding!,
        child: grid,
      );
    }

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = _getChartWidth(
          constraints.maxWidth - (widget.padding?.horizontal ?? 0),
        );

        final chart = CustomPaint(
          painter: BarChartPainter(
            widget.data,
            widget.style,
            widget.settings,
          ),
          size: Size.fromWidth(maxWidth),
        );

        Widget child;
        if (widget.settings.showAxisXLabels) {
          final maxItemWidth = _getItemWidth();
          final xAxisLabels = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.data.data.isEmpty)
                SizedBox(
                  height: _XAxisLabel.getEstimatedHeight(
                    widget.style.axisStyle,
                    widget.style.axisStyle.xAxisLabelStyle,
                  ),
                ),
              for (var i = 0; i < widget.data.data.length; i++) ...[
                _XAxisLabel(
                  settings: widget.settings,
                  style: widget.style.axisStyle,
                  data: widget.data,
                  index: i,
                  maxWidth: maxItemWidth,
                  selectedPeriod: _selectedPeriod,
                ),
                if (i != widget.data.data.length - 1)
                  SizedBox(width: widget.settings.itemSpacing),
              ],
            ],
          );

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

        return SingleChildScrollView(
          reverse: true,
          scrollDirection: Axis.horizontal,
          padding: widget.padding,
          child: child,
        );
      },
    );

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        grid,
        content,
      ],
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _selectedPeriod.close();
    super.dispose();
  }
}

class _XAxisLabel extends StatelessWidget {
  const _XAxisLabel({
    Key? key,
    required this.settings,
    required this.style,
    required this.data,
    required this.index,
    required this.maxWidth,
    required this.selectedPeriod,
  }) : super(key: key);

  final BarChartSettings settings;
  final BarChartAxisStyle style;
  final BarChartData data;
  final int index;
  final double maxWidth;
  final StreamController<DateTime> selectedPeriod;

  static double getEstimatedHeight(
    BarChartAxisStyle style,
    TextStyle textStyle,
  ) {
    // TODO: it is needed to calculate the max size more precisely.
    // this implementation is not correct in some cases, but still
    // relatively fine.
    final maxHeight = style.xAxisLabelPadding.vertical +
        (textStyle.height ?? 1) * (textStyle.fontSize ?? 14);

    return maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    final currentDate =
        data.data.entries.elementAt(data.data.length - 1 - index).key;

    if (!settings.showSelection) {
      return Container(
        key: ValueKey(currentDate.toIso8601String()),
        width: maxWidth,
        padding: style.xAxisLabelPadding,
        child: Text.rich(
          data.xAxisLabelBuilder(currentDate, style.xAxisLabelStyle),
          style: style.xAxisLabelStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onTap: () => selectedPeriod.add(currentDate),
      child: StreamBuilder<DateTime>(
        stream: selectedPeriod.stream,
        initialData: data.selectedPeriod,
        builder: (context, selectedPeriod) {
          final isSelected = currentDate == selectedPeriod.requireData;
          final currentStyle = isSelected
              ? style.xAxisSelectedLabelStyle
              : style.xAxisLabelStyle;
          final currentDecoration = isSelected
              ? BoxDecoration(
                  borderRadius: style.xAxisSelectedLabelBorderRadius,
                  color: style.xAxisSelectedLabelBackgroundColor,
                )
              : null;
          final maxHeight = getEstimatedHeight(style, currentStyle);

          return SizedOverflowBox(
            size: Size(maxWidth, maxHeight),
            child: Container(
              padding: style.xAxisLabelPadding,
              decoration: currentDecoration,
              child: Text.rich(
                data.xAxisLabelBuilder(currentDate, currentStyle),
                style: currentStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
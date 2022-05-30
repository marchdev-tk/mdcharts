// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Bar chart.
class BarChart extends StatelessWidget {
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

  double _getItemWidth() {
    final barItemQuantity = data.data.values.first.length;
    final barWidth = style.barStyle.width;
    final barSpacing = settings.barSpacing;

    final itemWidth =
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    return itemWidth;
  }

  double _getChartWidth(double maxWidth) {
    final itemLength = data.data.length;
    final itemSpacing = settings.itemSpacing;

    final itemWidth = _getItemWidth();
    final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;

    return math.max(maxWidth, totalWidth);
  }

  @override
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: BarChartGridPainter(
        data,
        style,
        settings,
      ),
      size: Size.infinite,
    );

    if (padding != null) {
      grid = Padding(
        padding: padding!,
        child: grid,
      );
    }

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final chart = CustomPaint(
          painter: BarChartPainter(
            data,
            style,
            settings,
          ),
          size: Size.fromWidth(_getChartWidth(constraints.maxWidth)),
        );

        final labels = Row(
          children: [
            for (var i = 0; i < data.data.length; i++) ...[
              _XAxisLabel(
                style: style.axisStyle,
                label: data.xAxisLabelBuilder(
                  data.data.entries.elementAt(data.data.length - 1 - i).key,
                ),
              ),
              if (i != data.data.length) SizedBox(width: settings.itemSpacing),
            ],
          ],
        );

        return SingleChildScrollView(
          reverse: true,
          scrollDirection: Axis.horizontal,
          padding: padding,
          child: Column(
            children: [
              chart,
              SizedBox(height: style.axisStyle.xAxisLabelTopMargin),
              labels,
            ],
          ),
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
}

class _XAxisLabel extends StatelessWidget {
  const _XAxisLabel({
    Key? key,
    required this.style,
    required this.label,
  }) : super(key: key);

  final BarChartAxisStyle style;
  final String label;

  @override
  Widget build(BuildContext context) {
    // TODO
    return Container();
  }
}

/*
TODO:
 
 ! add x axis labels
 !
 ! add x axis label selection
 ! add docs
*/

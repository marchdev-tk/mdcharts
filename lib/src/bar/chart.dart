// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../common.dart';
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

class _BarChartState extends State<BarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late BehaviorSubject<DateTime> _selectedPeriod;
  late BehaviorSubject<double> _yAxisLabelWidth;
  StreamSubscription<DateTime>? _sub;
  BarChartData? _oldData;

  CrossAxisAlignment _convertAlignment(BarAlignment alignment) {
    switch (alignment) {
      case BarAlignment.start:
        return CrossAxisAlignment.start;
      case BarAlignment.center:
        return CrossAxisAlignment.center;
      case BarAlignment.end:
        return CrossAxisAlignment.end;
    }
  }

  double _getItemWidth([double? predefinedBarWidth]) {
    final canDraw = widget.data.canDraw;
    final barItemQuantity = canDraw ? widget.data.data.values.first.length : 0;
    final barWidth = predefinedBarWidth ?? widget.style.barStyle.width;
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

    if (widget.settings.fit == BarFit.contain) {
      return totalWidth;
    }

    return math.max(maxWidth, totalWidth);
  }

  void _handleTapUp(TapUpDetails details, double maxWidth) {
    final itemSpacing = widget.settings.itemSpacing;
    final itemWidth = _getItemWidth();
    final maxChartWidth = _getChartWidth(0);
    final maxScreenWidth = _getChartWidth(maxWidth);

    DateTime key;

    switch (widget.settings.alignment) {
      case BarAlignment.start:
        key = _getKeyStart(
            details, itemSpacing, itemWidth, maxChartWidth, maxScreenWidth);
        break;
      case BarAlignment.center:
        key = _getKeyCenter(
            details, itemSpacing, itemWidth, maxChartWidth, maxScreenWidth);
        break;
      case BarAlignment.end:
        key = _getKeyEnd(
            details, itemSpacing, itemWidth, maxChartWidth, maxScreenWidth);
        break;
    }

    _selectedPeriod.add(key);
    widget.data.onSelectedPeriodChanged?.call(key);
  }

  DateTime _getKeyStart(
    TapUpDetails details,
    double itemSpacing,
    double itemWidth,
    double maxChartWidth,
    double maxScreenWidth,
  ) {
    final widthBias = maxScreenWidth - maxChartWidth;
    final x = details.localPosition.dx;
    final invertedX = maxChartWidth + widthBias - x;
    final edgeItemWidth = itemWidth + itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = widget.data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = widget.data.data.keys.first;
    }

    // other items
    else {
      var index = (x - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // plus 1 due to exclusion of the first item
      key = widget.data.data.keys.elementAt(index + 1);
    }

    return key;
  }

  DateTime _getKeyCenter(
    TapUpDetails details,
    double itemSpacing,
    double itemWidth,
    double maxChartWidth,
    double maxScreenWidth,
  ) {
    final widthBias = (maxScreenWidth - maxChartWidth) / 2;
    final x = details.localPosition.dx - widthBias;
    final invertedX = maxChartWidth - x;
    final edgeItemWidth = itemWidth + itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = widget.data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = widget.data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = widget.data.data.length - 1;
      var index = (invertedX - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // minus 1 due to exclusion of the last item
      key = widget.data.data.keys.elementAt(lastIndex - index - 1);
    }

    return key;
  }

  DateTime _getKeyEnd(
    TapUpDetails details,
    double itemSpacing,
    double itemWidth,
    double maxChartWidth,
    double maxScreenWidth,
  ) {
    final widthBias = maxScreenWidth - maxChartWidth;
    final x = details.localPosition.dx - widthBias;
    final invertedX = maxChartWidth - x;
    final edgeItemWidth = itemWidth + itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = widget.data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = widget.data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = widget.data.data.length - 1;
      var index = (invertedX - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // minus 1 due to exclusion of the last item
      key = widget.data.data.keys.elementAt(lastIndex - index - 1);
    }

    return key;
  }

  void _initSelectedPeriod() {
    if (widget.data.selectedPeriod != null) {
      _selectedPeriod.add(widget.data.selectedPeriod!);
    }
    if (widget.data.onSelectedPeriodChanged != null) {
      _sub = _selectedPeriod.stream.listen(widget.data.onSelectedPeriodChanged);
    }
  }

  void _initAnimation() {
    _valueController = AnimationController(
      vsync: this,
      duration: widget.settings.duration,
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
  }

  TickerFuture _startAnimation() => _valueController.forward(from: 0);

  TickerFuture _revertAnimation() => _valueController.reverse(from: 1);

  @override
  void initState() {
    _selectedPeriod = BehaviorSubject<DateTime>();
    _yAxisLabelWidth = BehaviorSubject<double>.seeded(0);
    _initSelectedPeriod();
    _initAnimation();
    _startAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    _sub?.cancel();
    _initSelectedPeriod();

    if (!mapEquals(oldWidget.data.data, widget.data.data)) {
      _oldData = widget.data.copyWith(data: oldWidget.data.data);
      _revertAnimation().whenCompleteOrCancel(() {
        _oldData = null;
        _startAnimation();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  Widget _buildChart(double maxWidth) {
    return StreamBuilder<double>(
      stream: _yAxisLabelWidth.distinct(),
      initialData: _yAxisLabelWidth.value,
      builder: (context, snapshot) {
        final spacing = widget.settings.yAxisLayout == YAxisLayout.displace
            ? widget.settings.yAxisLabelSpacing
            : .0;
        final displaceInset = widget.settings.fit == BarFit.none
            ? snapshot.requireData + spacing
            : .0;

        return GestureDetector(
          onTapUp: (details) => _handleTapUp(details, maxWidth),
          child: ValueListenableBuilder<double>(
            valueListenable: _valueAnimation,
            builder: (context, valueCoef, child) {
              return CustomPaint(
                key: ValueKey(valueCoef),
                painter: BarChartPainter(
                  _oldData ?? widget.data,
                  widget.style,
                  widget.settings,
                  _selectedPeriod,
                  valueCoef,
                ),
                size: Size.fromWidth(maxWidth - displaceInset),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    final maxVisibleContentWidth =
        constraints.maxWidth - (widget.padding?.horizontal ?? 0);
    var maxWidth = _getChartWidth(maxVisibleContentWidth);

    Widget content;
    if (widget.settings.showAxisXLabels) {
      var itemSpacing = widget.settings.itemSpacing;
      var maxItemWidth = _getItemWidth();

      void recalculateSizes() {
        if (widget.settings.fit == BarFit.contain) {
          double _getChartWidth(double itemWidth, double itemSpacing) =>
              widget.data.data.length * (itemSpacing + itemWidth) - itemSpacing;

          maxWidth = _getChartWidth(maxItemWidth, itemSpacing);
          var barWidth = widget.style.barStyle.width;
          final decreaseCoef = itemSpacing / barWidth;

          final displaceInset =
              widget.settings.yAxisLayout == YAxisLayout.displace
                  ? _yAxisLabelWidth.value + widget.settings.yAxisLabelSpacing
                  : .0;

          while (maxWidth > maxVisibleContentWidth - displaceInset) {
            barWidth -= 1;
            itemSpacing -= decreaseCoef;
            maxItemWidth = _getItemWidth(barWidth);
            maxWidth = _getChartWidth(maxItemWidth, itemSpacing);
          }
        }
      }

      recalculateSizes();

      final xAxisLabels = StreamBuilder<double>(
        stream: _yAxisLabelWidth.distinct(),
        initialData: _yAxisLabelWidth.value,
        builder: (context, snapshot) {
          recalculateSizes();

          return Row(
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
                  SizedBox(width: itemSpacing),
              ],
            ],
          );
        },
      );

      content = Column(
        crossAxisAlignment: _convertAlignment(widget.settings.alignment),
        children: [
          Expanded(child: _buildChart(maxWidth)),
          xAxisLabels,
        ],
      );
    } else {
      content = _buildChart(maxWidth);
    }

    switch (widget.settings.fit) {
      case BarFit.contain:
        content = Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: content,
        );
        break;

      case BarFit.none:
      default:
        content = ScrollConfiguration(
          behavior: AdaptiveScrollBehavior(),
          child: SingleChildScrollView(
            reverse: widget.settings.reverse,
            scrollDirection: Axis.horizontal,
            padding: widget.padding,
            child: content,
          ),
        );
        break;
    }

    return StreamBuilder<double>(
      stream: _yAxisLabelWidth.distinct(),
      initialData: _yAxisLabelWidth.value,
      builder: (context, snapshot) {
        final spacing = widget.settings.yAxisLayout == YAxisLayout.displace
            ? widget.settings.yAxisLabelSpacing
            : .0;
        final extraEmptySpace = math.max(maxVisibleContentWidth - maxWidth, .0);
        final displaceInset = snapshot.requireData + spacing;

        EdgeInsets padding;
        switch (widget.settings.alignment) {
          case BarAlignment.start:
            final inset = math.max(extraEmptySpace - displaceInset, .0);
            padding = EdgeInsets.only(left: displaceInset, right: inset);
            break;
          case BarAlignment.center:
            final inset = math.max(extraEmptySpace - displaceInset, .0);
            padding = EdgeInsets.only(
              left: displaceInset + inset / 2,
              right: inset / 2,
            );
            break;
          case BarAlignment.end:
            final inset = math.max(extraEmptySpace, displaceInset);
            padding = EdgeInsets.only(left: inset);
            break;
        }

        return Padding(
          padding: padding,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: _Grid(
                data: widget.data,
                settings: widget.settings,
                style: widget.style,
                padding: widget.padding,
                yAxisLabelWidth: _yAxisLabelWidth,
              ),
            ),
            _buildContent(constraints),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _selectedPeriod.close();
    _yAxisLabelWidth.close();
    _valueController.dispose();
    super.dispose();
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key? key,
    required this.data,
    required this.style,
    required this.settings,
    required this.padding,
    required this.yAxisLabelWidth,
  }) : super(key: key);

  final BarChartData data;
  final BarChartStyle style;
  final BarChartSettings settings;
  final EdgeInsetsGeometry? padding;
  final BehaviorSubject<double> yAxisLabelWidth;

  @override
  Widget build(BuildContext context) {
    Widget grid = CustomPaint(
      painter: BarChartGridPainter(
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
          SizedBox(
            height: _XAxisLabel.getEstimatedHeight(
              style.axisStyle,
              style.axisStyle.xAxisLabelStyle,
            ),
          ),
        ],
      );
    }

    if (padding != null) {
      grid = Padding(
        padding: padding!,
        child: grid,
      );
    }

    return grid;
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
    final currentDate = data.data.entries.elementAt(index).key;

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

          return Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(top: style.xAxisLabelTopMargin),
            child: SizedOverflowBox(
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
            ),
          );
        },
      ),
    );
  }
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

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
    super.key,
    required this.data,
    this.style = const BarChartStyle(),
    this.settings = const BarChartSettings(),
    this.padding,
  });

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
  final _selectedPeriod = BehaviorSubject<DateTime>();
  final _yAxisLabelWidth = BehaviorSubject<double>.seeded(0);
  StreamSubscription<DateTime>? _selectedPeriodSub;

  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late BarChartData _data;
  late BarChartStyle _style;
  late BarChartSettings _settings;

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
    final canDraw = _data.canDraw;
    final barItemQuantity = canDraw ? _data.data.values.first.length : 0;
    final barWidth = predefinedBarWidth ?? _style.barStyle.width;
    final barSpacing = _settings.barSpacing;

    final itemWidth =
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    return itemWidth;
  }

  double _getChartWidth(double maxWidth) {
    final itemLength = _data.data.length;
    final itemSpacing = _settings.itemSpacing;

    final itemWidth = _getItemWidth();
    final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;

    if (_settings.fit == BarFit.contain) {
      return totalWidth;
    }

    return math.max(maxWidth, totalWidth);
  }

  void _handleTapUp(TapUpDetails details, double maxWidth) {
    var itemSpacing = _settings.itemSpacing;
    var itemWidth = _getItemWidth();
    var maxChartWidth = _getChartWidth(0);
    var maxScreenWidth = _getChartWidth(maxWidth);

    DateTime key;

    if (_settings.fit == BarFit.contain) {
      double getChartWidth(double itemWidth, double itemSpacing) =>
          _data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      maxChartWidth = getChartWidth(itemWidth, itemSpacing);
      var barWidth = _style.barStyle.width;
      final decreaseCoef = itemSpacing / barWidth;

      maxScreenWidth = math.min(maxWidth, maxScreenWidth);

      while (maxChartWidth > maxScreenWidth) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = _getItemWidth(barWidth);
        maxChartWidth = getChartWidth(itemWidth, itemSpacing);
      }
    }

    switch (_settings.alignment) {
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
    _data.onSelectedPeriodChanged?.call(key);
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
      key = _data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = _data.data.keys.first;
    }

    // other items
    else {
      var index = (x - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // plus 1 due to exclusion of the first item
      key = _data.data.keys.elementAt(index + 1);
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
      key = _data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = _data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = _data.data.length - 1;
      var index = (invertedX - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // minus 1 due to exclusion of the last item
      key = _data.data.keys.elementAt(lastIndex - index - 1);
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
      key = _data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = _data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = _data.data.length - 1;
      var index = (invertedX - edgeItemWidth) ~/ (itemWidth + itemSpacing);
      // minus 1 due to exclusion of the last item
      key = _data.data.keys.elementAt(lastIndex - index - 1);
    }

    return key;
  }

  void _initSelectedPeriod() {
    if (_data.selectedPeriod != null) {
      _selectedPeriod.add(_data.selectedPeriod!);
    }
    _selectedPeriodSub?.cancel();
    if (_data.onSelectedPeriodChanged != null) {
      _selectedPeriodSub = _selectedPeriod.stream
          .distinct()
          .listen(_data.onSelectedPeriodChanged);
    }
  }

  void _initAnimation() {
    _valueController = AnimationController(
      vsync: this,
      duration: _settings.duration,
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
    _data = widget.data;
    _style = widget.style;
    _settings = widget.settings;
    _initSelectedPeriod();
    _initAnimation();
    _startAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    final changed = widget.data != oldWidget.data ||
        widget.style != oldWidget.style ||
        widget.settings != oldWidget.settings;

    if (changed) {
      _data = oldWidget.data;
      _style = oldWidget.style;
      _settings = oldWidget.settings;

      _revertAnimation().whenCompleteOrCancel(() {
        _data = widget.data;
        _style = widget.style;
        _settings = widget.settings;
        _initSelectedPeriod();
        setState(() {});
        _startAnimation();
      });
    } else {
      _data = widget.data;
      _style = widget.style;
      _settings = widget.settings;
      _initSelectedPeriod();
    }

    super.didUpdateWidget(oldWidget);
  }

  Widget _buildChart(double maxWidth) {
    return GestureDetector(
      onTapUp: (details) => _handleTapUp(details, maxWidth),
      child: AnimatedBuilder(
        animation: _valueAnimation,
        builder: (context, _) {
          return CustomPaint(
            key: ValueKey(_valueAnimation.value),
            painter: BarChartPainter(
              _data,
              _style,
              _settings,
              _selectedPeriod,
              _valueAnimation.value,
            ),
            child: StreamBuilder<double>(
              stream: _yAxisLabelWidth.distinct(),
              initialData: _yAxisLabelWidth.value,
              builder: (context, snapshot) {
                final spacing = _settings.yAxisLayout == YAxisLayout.displace
                    ? _settings.yAxisLabelSpacing
                    : .0;
                final displaceInset = _settings.fit == BarFit.none
                    ? snapshot.requireData + spacing
                    : .0;

                return SizedBox(
                  width: math.max(0, maxWidth - displaceInset),
                  height: double.infinity,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildXAxisLabels(double maxWidth, double maxVisibleContentWidth) {
    var itemSpacing = _settings.itemSpacing;
    var maxItemWidth = _getItemWidth();

    void recalculateSizes() {
      if (_settings.fit == BarFit.contain) {
        double getChartWidth(double itemWidth, double itemSpacing) =>
            _data.data.length * (itemSpacing + itemWidth) - itemSpacing;

        maxWidth = getChartWidth(maxItemWidth, itemSpacing);
        var barWidth = _style.barStyle.width;
        final decreaseCoef = itemSpacing / barWidth;

        final displaceInset = _settings.yAxisLayout == YAxisLayout.displace
            ? _yAxisLabelWidth.value + _settings.yAxisLabelSpacing
            : .0;

        while (maxWidth > maxVisibleContentWidth - displaceInset) {
          barWidth -= 1;
          itemSpacing -= decreaseCoef;
          maxItemWidth = _getItemWidth(barWidth);
          maxWidth = getChartWidth(maxItemWidth, itemSpacing);
        }
      }
    }

    recalculateSizes();

    return StreamBuilder<double>(
      stream: _yAxisLabelWidth.distinct(),
      initialData: _yAxisLabelWidth.value,
      builder: (context, snapshot) {
        recalculateSizes();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_data.data.isEmpty)
              SizedBox(
                height: _XAxisLabel.getEstimatedHeight(
                  _style.axisStyle,
                  _style.axisStyle.xAxisLabelStyle,
                ),
              ),
            for (var i = 0; i < _data.data.length; i++) ...[
              _XAxisLabel(
                settings: _settings,
                style: _style.axisStyle,
                data: _data,
                index: i,
                maxWidth: maxItemWidth,
                selectedPeriod: _selectedPeriod,
              ),
              if (i != _data.data.length - 1) SizedBox(width: itemSpacing),
            ],
          ],
        );
      },
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    final maxVisibleContentWidth =
        constraints.maxWidth - (widget.padding?.horizontal ?? 0);
    var maxWidth = _getChartWidth(maxVisibleContentWidth);

    Widget content;
    if (_settings.showAxisXLabels) {
      content = Column(
        crossAxisAlignment: _convertAlignment(_settings.alignment),
        children: [
          Expanded(child: _buildChart(maxWidth)),
          _buildXAxisLabels(maxWidth, maxVisibleContentWidth),
        ],
      );
    } else {
      content = _buildChart(maxWidth);
    }

    switch (_settings.fit) {
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
            reverse: _settings.reverse,
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
        final spacing = _settings.yAxisLayout == YAxisLayout.displace
            ? _settings.yAxisLabelSpacing
            : .0;
        final extraEmptySpace = math.max(maxVisibleContentWidth - maxWidth, .0);
        final displaceInset = snapshot.requireData + spacing;

        EdgeInsets padding;
        switch (_settings.alignment) {
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
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: _Grid(
                  data: _data,
                  style: _style,
                  settings: _settings,
                  padding: widget.padding,
                  yAxisLabelWidth: _yAxisLabelWidth,
                ),
              ),
              _buildContent(constraints),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _selectedPeriodSub?.cancel();
    _selectedPeriod.close();
    _yAxisLabelWidth.close();
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
    required this.settings,
    required this.style,
    required this.data,
    required this.index,
    required this.maxWidth,
    required this.selectedPeriod,
  });

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
      final maxHeight = getEstimatedHeight(style, style.xAxisLabelStyle);

      return SizedOverflowBox(
        size: Size(maxWidth, maxHeight),
        child: Container(
          key: ValueKey(currentDate.toIso8601String()),
          padding: style.xAxisLabelPadding,
          child: Text.rich(
            data.xAxisLabelBuilder(currentDate, style.xAxisLabelStyle),
            style: style.xAxisLabelStyle,
            textAlign: TextAlign.center,
          ),
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

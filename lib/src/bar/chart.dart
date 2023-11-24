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
import 'utils.dart';

// TODO fix BarFit.none issue with state updating
// TODO fix YAxisLayout.displace related issue for BarFit.contain and no bar compression (incorrect item hitTesting)
// TODO fix YAxisLayout.displace related issue for BarFit.none (extra scroll)

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
  TickerFuture _startAnimation() => _valueController.forward(from: 0);
  TickerFuture _revertAnimation() => _valueController.reverse(from: 1);

  late BarChartData _data;
  late BarChartStyle _style;
  late BarChartSettings _settings;

  bool _dragInProgress = false;

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

  double _getChartWidth(double maxWidth) {
    return BarChartUtils().getChartWidth(maxWidth, _data, _settings, _style);
  }

  void _handleTapUp(TapUpDetails details, double maxWidth) {
    if (_settings.interaction != InteractionType.selection) {
      return;
    }

    final metrics = BarChartUtils().getBarMetrics(
      maxWidth,
      _data,
      _settings,
      _style,
    );

    final key = BarChartUtils().getKey(
      details.localPosition.dx,
      metrics,
      _data,
      _settings,
    );

    _selectedPeriod.add(key);
    _data.onSelectedPeriodChanged?.call(key);
    setState(() {});
  }

  void _handleDragEnd([dynamic details]) {
    if (_settings.interaction != InteractionType.overview) {
      return;
    }

    _initSelectedPeriod();
    _dragInProgress = false;
    setState(() {});
  }

  void _handleDragUpdate(dynamic details, double maxWidth) {
    if (_settings.interaction != InteractionType.overview) {
      return;
    }

    final metrics = BarChartUtils().getBarMetrics(
      maxWidth,
      _data,
      _settings,
      _style,
    );

    final key = BarChartUtils().getKey(
      details.localPosition.dx,
      metrics,
      _data,
      _settings,
    );

    _selectedPeriod.add(key);
    _data.onSelectedPeriodChanged?.call(key);
    _dragInProgress = true;
    setState(() {});
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
    return StreamBuilder<double>(
      stream: _yAxisLabelWidth.distinct(),
      initialData: _yAxisLabelWidth.value,
      builder: (context, snapshot) {
        var spacing = .0;
        var displaceInset = .0;
        var maxWidthAdjusted = maxWidth;
        if (_settings.yAxisLayout == YAxisLayout.displace &&
            _settings.fit == BarFit.contain) {
          spacing = _settings.yAxisLabelSpacing;
          displaceInset = snapshot.requireData + spacing;
          maxWidthAdjusted = maxWidth - displaceInset;
        }

        final chart = AnimatedBuilder(
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
                _dragInProgress,
              ),
              child: SizedBox(
                width: math.max(0, maxWidthAdjusted),
                height: double.infinity,
              ),
            );
          },
        );

        final xAxisLabels = CustomPaint(
          painter: BarChartXAxisLabelPainter(
            _data,
            _style,
            _settings,
            _selectedPeriod,
          ),
          size: Size(
            math.max(0, maxWidthAdjusted),
            widget.style.axisStyle.labelHeight,
          ),
        );

        Widget content;
        if (_settings.showAxisXLabels) {
          content = Column(
            crossAxisAlignment: _convertAlignment(_settings.alignment),
            children: [
              Expanded(child: chart),
              Container(
                height: widget.style.axisStyle.xAxisLabelTopMargin,
                color: Colors.transparent,
              ),
              xAxisLabels,
            ],
          );
        } else {
          content = chart;
        }

        return GestureDetector(
          onTapUp: (details) => _handleTapUp(details, maxWidthAdjusted),
          onHorizontalDragCancel: _handleDragEnd,
          onHorizontalDragEnd: _handleDragEnd,
          onHorizontalDragStart: (details) =>
              _handleDragUpdate(details, maxWidthAdjusted),
          onHorizontalDragUpdate: (details) =>
              _handleDragUpdate(details, maxWidthAdjusted),
          child: content,
        );
      },
    );
  }

  Widget _buildContentBarFitAdjuster({required Widget child}) {
    switch (_settings.fit) {
      case BarFit.contain:
        return Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: child,
        );

      case BarFit.none:
      default:
        return ScrollConfiguration(
          behavior: AdaptiveScrollBehavior(),
          child: SingleChildScrollView(
            reverse: _settings.reverse,
            scrollDirection: Axis.horizontal,
            padding: widget.padding,
            child: child,
          ),
        );
    }
  }

  Widget _buildContentBarAlignmentAdjuster({
    required double maxWidth,
    required double maxVisibleContentWidth,
    required Widget child,
  }) {
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
          child: child,
        );
      },
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    final maxVisibleContentWidth =
        constraints.maxWidth - (widget.padding?.horizontal ?? 0);
    var maxWidth = _getChartWidth(maxVisibleContentWidth);

    return _buildContentBarFitAdjuster(
      child: _buildContentBarAlignmentAdjuster(
        maxWidth: maxWidth,
        maxVisibleContentWidth: maxVisibleContentWidth,
        child: _buildChart(maxWidth),
      ),
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
              Positioned.fill(
                child: _buildContent(constraints),
              ),
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
          SizedBox(height: style.axisStyle.labelHeight),
          // SizedBox(
          //   height: _XAxisLabel.getEstimatedHeight(
          //     style.axisStyle,
          //     style.axisStyle.xAxisLabelStyle,
          //   ),
          // ),
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

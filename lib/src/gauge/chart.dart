// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'cache.dart';
import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Gauge chart.
class GaugeChart extends StatefulWidget {
  /// Constructs an instance of [GaugeChart].
  const GaugeChart({
    super.key,
    required this.data,
    this.style = const GaugeChartStyle(),
    this.settings = const GaugeChartSettings(),
  });

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
  late int dataHashCode;
  int? _selectedIndex;

  bool _tapHandlingInProgress = false;

  void startAnimation() {
    if (data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
  }

  void _handleTapUp(Offset position) {
    if (!widget.settings.selectionEnabled || _tapHandlingInProgress) {
      return;
    }

    try {
      _tapHandlingInProgress = true;
      final pathHolders = cache.getPathHolders(data.hashCode) ?? [];

      if (pathHolders.isEmpty) {
        return;
      }

      for (var i = 0; i < data.data.length; i++) {
        final contains = pathHolders[i].path.contains(position);

        if (contains && _selectedIndex != i) {
          _selectedIndex = i;
          final needAnimation =
              widget.data.onSelectionChanged?.call(i) ?? false;
          if (needAnimation) {
            startAnimation();
          }
        }
      }
    } finally {
      _tapHandlingInProgress = false;
    }
  }

  @override
  void initState() {
    data = widget.data;
    dataHashCode = data.hashCode;
    cache.add(dataHashCode, oldData.hashCode);

    _selectedIndex = data.selectedIndex;

    _valueController = AnimationController(
      value: widget.settings.runInitialAnimation ? 0 : 1,
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
    if (widget.settings.runInitialAnimation) {
      startAnimation();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant GaugeChart oldWidget) {
    data = widget.data;
    dataHashCode = data.hashCode;
    if (data != oldWidget.data) {
      oldData = oldWidget.data;
    }
    final oldDataHashCode = oldData?.hashCode;

    if (oldData.hashCode != oldDataHashCode) {
      cache.add(oldData.hashCode, oldDataHashCode);
      cache.add(dataHashCode, oldData.hashCode);
    } else {
      cache.add(dataHashCode, oldData.hashCode);
    }

    if (data != oldWidget.data) {
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTapUp: (details) => _handleTapUp(details.localPosition),
        child: AnimatedBuilder(
          animation: _valueAnimation,
          builder: (context, _) {
            return CustomPaint(
              isComplex: true,
              painter: GaugeChartPainter(
                data,
                widget.style,
                widget.settings,
                oldData,
                dataHashCode,
                _valueAnimation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

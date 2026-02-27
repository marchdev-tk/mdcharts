// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:mdcharts/src/_internal.dart';

import 'cache.dart';
import 'painter.dart';

const _animationDuaration = Duration(milliseconds: 600);

@immutable
class DonutChart extends StatefulWidget {
  const DonutChart({
    super.key,
    required this.data,
    this.settings = const DonutChartSettings(),
    this.style = const DonutChartStyle(),
  });

  final DonutChartData data;
  final DonutChartSettings settings;
  final DonutChartStyle style;

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late DonutChartData data;
  DonutChartData? oldData;
  late int dataHashCode;
  int? _selectedIndex;

  bool _tapHandlingInProgress = false;

  Future<void> startAnimation() async {
    if (widget.data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
    await Future.delayed(_animationDuaration);
  }

  Future<void> _handleTapUp(Offset position) async {
    if (!widget.settings.selectionEnabled || _tapHandlingInProgress) {
      return;
    }

    try {
      _tapHandlingInProgress = true;
      final pathHolders = cache.getPathHolders(widget.data.hashCode) ?? [];

      if (pathHolders.isEmpty) {
        return;
      }

      for (var i = 0; i < widget.data.data.length; i++) {
        final contains = pathHolders[i].path.contains(position);

        if (contains && _selectedIndex != i) {
          _selectedIndex = i;
          widget.data.onSelectionChanged?.call(i);
          await startAnimation();
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
      duration: _animationDuaration,
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
  void didUpdateWidget(DonutChart oldWidget) {
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

    _selectedIndex = data.selectedIndex;

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
              painter: DonutPainter(
                widget.data,
                widget.settings,
                widget.style,
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

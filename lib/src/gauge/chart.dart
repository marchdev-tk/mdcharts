// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../common.dart';
import 'cache.dart';
import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

/// Gauge chart.
class GaugeChart extends StatefulWidget {
  /// Constructs an instance of [GaugeChart].
  const GaugeChart({
    Key? key,
    required this.data,
    this.style = const GaugeChartStyle(),
    this.settings = const GaugeChartSettings(),
    this.onSelectionChanged,
  }) : super(key: key);

  /// Set of required (and optional) data to construct the line chart.
  final GaugeChartData data;

  /// Provides various customizations for the line chart.
  final GaugeChartStyle style;

  /// Provides various settings for the line chart.
  final GaugeChartSettings settings;

  /// Callbacks that reports that selected section index has changed.
  ///
  /// If this predicate return `true` - animation will be triggered,
  /// otherwise - animation won't be triggered.
  final IndexedPredicate? onSelectionChanged;

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late GaugeChartData data;
  GaugeChartData? oldData;
  int? dataHashCode;

  void adjustDatas() {
    var old = oldData ?? data.copyWith(data: List.filled(data.data.length, 0));

    if (old.data.length >= data.data.length) {
      data = data.copyWith(
        data: [
          ...data.data,
          ...List.filled(old.data.length - data.data.length, 0),
        ],
      );
    }
    if (old.data.length <= data.data.length) {
      final oldDataLength = old.data.length;
      for (var i = 0; i < data.data.length - oldDataLength; i++) {
        old = old.copyWith(data: [...old.data, 0]);
      }
    }

    oldData = old;
  }

  void startAnimation() {
    if (data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
  }

  void onSelectionChanged(index) {
    final needAnimation = widget.onSelectionChanged?.call(index) ?? false;

    if (needAnimation) {
      startAnimation();
    }
  }

  void hitTest(Offset position) {
    final pathHolders = cache.getPathHolders(data.hashCode) ?? [];

    if (pathHolders.isEmpty) {
      return;
    }

    for (var i = 0; i < data.data.length; i++) {
      final contains = pathHolders[i].path.contains(position);

      if (contains) {
        onSelectionChanged(i);
      }
    }
  }

  @override
  void initState() {
    data = widget.data;
    dataHashCode = data.hashCode;
    adjustDatas();
    cache.add(dataHashCode!, oldData.hashCode);

    _valueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
    startAnimation();

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
    adjustDatas();

    if (oldData.hashCode != oldDataHashCode) {
      cache.add(oldData.hashCode, oldDataHashCode);
      cache.add(dataHashCode!, oldData.hashCode);
    } else {
      cache.add(dataHashCode!, oldData.hashCode);
    }

    startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: widget.settings.selectionEnabled
          ? (details) => hitTest(details.localPosition)
          : null,
      child: AnimatedBuilder(
        animation: _valueAnimation,
        builder: (context, _) {
          return CustomPaint(
            isComplex: true,
            painter: GaugeChartPainter(
              data,
              widget.style,
              widget.settings,
              oldData!,
              dataHashCode!,
              _valueAnimation.value,
            ),
            size: Size.infinite,
          );
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

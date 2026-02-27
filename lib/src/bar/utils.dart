// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import '../_internal.dart';

class BarChartBarMetrics {
  const BarChartBarMetrics({
    required this.itemSpacing,
    required this.itemWidth,
    required this.maxChartWidth,
    required this.maxScreenWidth,
  });

  final double itemSpacing;
  final double itemWidth;
  final double maxChartWidth;
  final double maxScreenWidth;
}

class BarChartUtils {
  const BarChartUtils._();
  factory BarChartUtils() => _instance;
  static const _instance = BarChartUtils._();

  double getItemWidth(
    BarChartData data,
    BarChartSettings settings,
    BarChartStyle style, [
    double? predefinedBarWidth,
  ]) {
    final canDraw = data.canDraw;
    final barItemQuantity = canDraw ? data.data.values.first.length : 0;
    final barWidth = predefinedBarWidth ?? style.barStyle.width;
    final barSpacing = settings.barSpacing;

    final itemWidth =
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    return itemWidth;
  }

  double getChartWidth(
    double maxWidth,
    BarChartData data,
    BarChartSettings settings,
    BarChartStyle style,
  ) {
    final itemLength = data.data.length;
    final itemSpacing = settings.itemSpacing;

    final itemWidth = getItemWidth(data, settings, style);
    final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;

    if (maxWidth == -1) {
      return totalWidth;
    }

    if (settings.fit == BarFit.contain) {
      return math.min(maxWidth, totalWidth);
    }

    return math.max(maxWidth, totalWidth);
  }

  BarChartBarMetrics getMetrics(
    double maxWidth,
    BarChartData data,
    BarChartSettings settings,
    BarChartStyle style,
  ) {
    var itemSpacing = settings.itemSpacing;
    var itemWidth = getItemWidth(data, settings, style);
    var maxChartWidth = getChartWidth(-1, data, settings, style);
    final maxScreenWidth = getChartWidth(maxWidth, data, settings, style);

    if (settings.fit == BarFit.contain) {
      double getChartWidthLocal(double itemWidth, double itemSpacing) =>
          data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      maxChartWidth = getChartWidthLocal(itemWidth, itemSpacing);
      var barWidth = style.barStyle.width;
      final decreaseCoef = itemSpacing / barWidth;

      while (maxChartWidth > maxScreenWidth) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = getItemWidth(data, settings, style, barWidth);
        maxChartWidth = getChartWidthLocal(itemWidth, itemSpacing);
      }
    }

    return BarChartBarMetrics(
      itemSpacing: itemSpacing,
      itemWidth: itemWidth,
      maxChartWidth: maxChartWidth,
      maxScreenWidth: maxScreenWidth,
    );
  }

  DateTime getKey(
    double dx,
    BarChartBarMetrics metrics,
    BarChartData data,
    BarChartSettings settings,
  ) {
    switch (settings.alignment) {
      case BarAlignment.start:
        return _getKeyStart(dx, metrics, data);
      case BarAlignment.center:
        return _getKeyCenter(dx, metrics, data);
      case BarAlignment.end:
        return _getKeyEnd(dx, metrics, data);
    }
  }

  DateTime _getKeyStart(
    double dx,
    BarChartBarMetrics metrics,
    BarChartData data,
  ) {
    final widthBias = metrics.maxScreenWidth - metrics.maxChartWidth;
    final x = dx;
    final invertedX = metrics.maxChartWidth + widthBias - x;
    final edgeItemWidth = metrics.itemWidth + metrics.itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = data.data.keys.first;
    }

    // other items
    else {
      final index =
          (x - edgeItemWidth) ~/ (metrics.itemWidth + metrics.itemSpacing);
      // plus 1 due to exclusion of the first item
      key = data.data.keys.elementAt(index + 1);
    }

    return key;
  }

  DateTime _getKeyCenter(
    double dx,
    BarChartBarMetrics metrics,
    BarChartData data,
  ) {
    final widthBias = (metrics.maxScreenWidth - metrics.maxChartWidth) / 2;
    final x = dx - widthBias;
    final invertedX = metrics.maxChartWidth - x;
    final edgeItemWidth = metrics.itemWidth + metrics.itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = data.data.length - 1;
      final index = (invertedX - edgeItemWidth) ~/
          (metrics.itemWidth + metrics.itemSpacing);
      // minus 1 due to exclusion of the last item
      key = data.data.keys.elementAt(lastIndex - index - 1);
    }

    return key;
  }

  DateTime _getKeyEnd(
    double dx,
    BarChartBarMetrics metrics,
    BarChartData data,
  ) {
    final widthBias = metrics.maxScreenWidth - metrics.maxChartWidth;
    final x = dx - widthBias;
    final invertedX = metrics.maxChartWidth - x;
    final edgeItemWidth = metrics.itemWidth + metrics.itemSpacing / 2;

    DateTime key;

    // last item
    if (invertedX <= edgeItemWidth) {
      key = data.data.keys.last;
    }

    // first item
    else if (x <= edgeItemWidth) {
      key = data.data.keys.first;
    }

    // other items
    else {
      final lastIndex = data.data.length - 1;
      final index = (invertedX - edgeItemWidth) ~/
          (metrics.itemWidth + metrics.itemSpacing);
      // minus 1 due to exclusion of the last item
      key = data.data.keys.elementAt(lastIndex - index - 1);
    }

    return key;
  }
}

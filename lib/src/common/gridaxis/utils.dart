// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:mdcharts/_internal.dart';
import 'package:mdcharts/_internal.dart' as utils show getRoundedMaxValue;

class GridAxisUtils {
  const GridAxisUtils._();
  factory GridAxisUtils() => _instance;
  static const _instance = GridAxisUtils._();

  /// {@template GridAxisUtils.getRoundedDivisionSize}
  /// Rounding method that calculates and rounds Y axis division size.
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  /// {@endtemplate}
  double getRoundedDivisionSize(
    GridAxisCacheHolder cache,
    GridAxisData data,
    GridAxisSettings settings,
  ) {
    final cachedRoundedSize = cache.getRoundedDivisionSize(data.hashCode);
    if (cachedRoundedSize != null) {
      return cachedRoundedSize;
    }

    final yDivisions = settings.yAxisDivisions + 1;
    double divisionSize;

    if (yDivisions == 1) {
      divisionSize = data.totalValue;
    } else if (yDivisions == 2 && data.maxValue == 0) {
      divisionSize = data.minValue.abs() / 2;
    } else if (yDivisions == 2) {
      divisionSize = math.max(data.maxValue, data.minValue.abs());
    } else if (data.minValue == 0 || data.maxValue == 0) {
      divisionSize = data.totalValue / yDivisions;
    } else {
      var size = data.totalValue / yDivisions;
      var maxDivisions = (data.maxValue / size).ceil();
      var minDivisions = (data.minValue.abs() / size).ceil();

      // TODO: find a better way to calculate size of the division.
      while (maxDivisions + minDivisions > yDivisions) {
        size = size + 1;
        maxDivisions = (data.maxValue / size).ceil();
        minDivisions = (data.minValue.abs() / size).ceil();
      }

      divisionSize = size;
    }

    final roundedSize =
        utils.getRoundedMaxValue(data.maxValueRoundingMap, divisionSize, 1);
    cache.saveRoundedDivisionSize(data.hashCode, roundedSize);

    return roundedSize;
  }

  /// {@template GridAxisUtils.getRoundedMinValue}
  /// Rounding method that rounds [data.minValue] to achieve beautified value
  /// so, it could be multiplied by [settings.yAxisDivisions].
  ///
  /// Note that this will be used only if [data.hasNegativeMinValue] is `true`.
  /// {@endtemplate}
  double getRoundedMinValue(
    GridAxisCacheHolder cache,
    GridAxisData data,
    GridAxisSettings settings,
  ) {
    final cachedMinValue = cache.getRoundedMinValue(data.hashCode);
    if (cachedMinValue != null) {
      return cachedMinValue;
    }

    double minValue = 0;
    if (data.hasNegativeMinValue) {
      final size = getRoundedDivisionSize(cache, data, settings);
      final divisions = (data.minValue.abs() / size).ceil();
      minValue = size * divisions;
    }
    cache.saveRoundedMinValue(data.hashCode, minValue);

    return minValue;
  }

  /// {@template GridAxisUtils.getRoundedMaxValue}
  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with beautified integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  /// {@endtemplate}
  double getRoundedMaxValue(
    GridAxisCacheHolder cache,
    GridAxisData data,
    GridAxisSettings settings,
  ) {
    final cachedMaxValue = cache.getRoundedMaxValue(data.hashCode);
    if (cachedMaxValue != null) {
      return cachedMaxValue;
    }

    double maxValue;
    if (data.hasNegativeMinValue) {
      final yDivisions = settings.yAxisDivisions + 1;
      maxValue = getRoundedDivisionSize(cache, data, settings) * yDivisions;
    } else {
      maxValue = utils.getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );
    }
    cache.saveRoundedMaxValue(data.hashCode, maxValue);

    return maxValue;
  }
}

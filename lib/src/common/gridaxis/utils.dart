// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';
import 'package:mdcharts/src/_internal.dart' as utils
    show getRoundedMaxValue, getRoundedMinValue, normalize, normalizeInverted;

class GridAxisUtils {
  const GridAxisUtils._();
  factory GridAxisUtils() => _instance;
  static const _instance = GridAxisUtils._();

  /// Normalization method.
  ///
  /// Converts provided [value] based on [cache], [data] and [settings] into a
  /// percentage proportion with valid values in inclusive range [0..1].
  double normalize(
    double value,
    GridAxisCacheHolder cache,
    GridAxisData data,
    GridAxisSettings settings,
  ) {
    final roundedDivisionSize = getRoundedDivisionSize(cache, data, settings);

    if (data.isNegative) {
      return utils.normalize(
        (value - getRoundedMaxValue(cache, data, settings)).abs(),
        roundedDivisionSize * (settings.yAxisDivisions + 1),
      );
    }

    return utils.normalizeInverted(
      value - getRoundedMinValue(cache, data, settings),
      roundedDivisionSize * (settings.yAxisDivisions + 1),
    );
  }

  /// Normalization method for old data.
  ///
  /// Converts provided [value] based on [oldDataHashCode] alongside with
  /// [cache], [data] and [settings] into a percentage proportion with valid
  /// values in inclusive range [0..1].
  double normalizeOld(
    double oldValue,
    int oldDataHashCode,
    GridAxisCacheHolder cache,
    GridAxisData data,
    GridAxisSettings settings,
  ) {
    final oldRoundedMinValue = cache.getRoundedMinValue(oldDataHashCode) ?? 0;
    final oldRoundedMaxValue = cache.getRoundedMaxValue(oldDataHashCode) ?? 0;
    final oldRoundedDivisionSize =
        cache.getRoundedDivisionSize(oldDataHashCode) ?? 1;

    if (data.isNegative) {
      return utils.normalize(
        (oldValue - oldRoundedMaxValue).abs(),
        oldRoundedDivisionSize * (settings.yAxisDivisions + 1),
      );
    }

    return utils.normalizeInverted(
      oldValue - oldRoundedMinValue,
      oldRoundedDivisionSize * (settings.yAxisDivisions + 1),
    );
  }

  /// Map adjustment method.
  ///
  /// Adjusts or creates [mapToAdjust] based on [sourceMap].
  ///
  /// It is needed for animation smoothness.
  Map<DateTime, T> adjustMap<T>(
    Map<DateTime, T> sourceMap,
    Map<DateTime, T>? mapToAdjust,
    T defaultValue,
  ) {
    Map<DateTime, T> adjustedMap;
    if (mapToAdjust != null) {
      adjustedMap = Map.of(mapToAdjust);
    } else {
      adjustedMap = {
        for (var i = 0; i < sourceMap.length; i++)
          sourceMap.keys.elementAt(i): defaultValue,
      };
    }

    if (adjustedMap.length <= sourceMap.length) {
      adjustedMap = Map.fromEntries([
        ...adjustedMap.entries,
        for (var i = adjustedMap.length; i < sourceMap.length; i++)
          MapEntry(sourceMap.keys.elementAt(i), adjustedMap.values.last),
      ]);
    }

    return adjustedMap;
  }

  /// Retrieves data entry index based on the [selectedXPosition] and [data].
  int? getSelectedIndex(
    Size size,
    double? selectedXPosition,
    GridAxisData data,
  ) {
    if (selectedXPosition == null) {
      return null;
    }

    final widthFraction = size.width / data.xAxisDivisions;

    int index = math.max((selectedXPosition / widthFraction).round(), 0);
    index = math.min(index, data.xAxisDivisions);

    return index;
  }

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

    late double divisionSize;

    if (settings.yAxisBaseline == YAxisBaseline.axis) {
      var size = div(data.totalValueAxisBased, settings.yAxisDivisions);
      divisionSize = size;
    }

    if (settings.yAxisBaseline == YAxisBaseline.zero) {
      // TODO: fix for values less than 1

      final yDivisions = settings.yAxisDivisions + 1;

      if (yDivisions == 1 ||
          data.minValueZeroBased == 0 ||
          data.maxValue == 0) {
        divisionSize = div(data.totalValueZeroBased, yDivisions);
      } else if (yDivisions == 2 && data.hasNegativeMinValueZeroBased) {
        divisionSize = math.max(data.maxValue, data.minValueZeroBased.abs());
      } else {
        var size = div(data.totalValueZeroBased, yDivisions);
        var maxDivisions = (data.maxValue / size).ceil();
        var minDivisions = (data.minValueZeroBased.abs() / size).ceil();

        // TODO: find a better way to calculate size of the division.
        while (maxDivisions + minDivisions > yDivisions) {
          size = size + 1;
          maxDivisions = (data.maxValue / size).ceil();
          minDivisions = (data.minValueZeroBased.abs() / size).ceil();
        }

        divisionSize = size;
      }
    }

    final roundedSize =
        utils.getRoundedMaxValue(data.roundingMap, divisionSize, 0);
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
    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        data.hasNegativeMinValueZeroBased) {
      final size = getRoundedDivisionSize(cache, data, settings);
      final divisions = (data.minValueZeroBased.abs() / size).ceil();
      minValue = -size * divisions;
    }
    if (settings.yAxisBaseline == YAxisBaseline.axis) {
      minValue = utils.getRoundedMinValue(
        data.roundingMap,
        data.minValueAxisBased,
        0,
      );
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
    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        data.hasNegativeMinValueZeroBased) {
      final size = getRoundedDivisionSize(cache, data, settings);
      final divisions = (data.maxValue.abs() / size).ceil();
      maxValue = size * divisions;
    } else {
      maxValue = utils.getRoundedMaxValue(
        data.roundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );
    }
    cache.saveRoundedMaxValue(data.hashCode, maxValue);

    return maxValue;
  }
}

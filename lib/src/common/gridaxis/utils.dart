// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';
import 'package:mdcharts/src/_internal.dart' as utils
    show normalize, normalizeInverted;

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
  Map<DateTime, T> adjustMap<T extends Object>(
    Map<DateTime, T> sourceMap,
    Map<DateTime, T>? mapToAdjust,
    T defaultValue,
  ) {
    final adjustedMap = {
      for (var i = 0; i < sourceMap.length; i++)
        sourceMap.keys.elementAt(i): defaultValue,
    };

    for (var entry in sourceMap.entries) {
      if (mapToAdjust == null || mapToAdjust.isEmpty) {
        adjustedMap[entry.key] = defaultValue;
        continue;
      }

      T value;

      if (entry.key.isBefore(mapToAdjust.keys.first)) {
        value = mapToAdjust.values.firstOrNull ?? defaultValue;
      } else if (entry.key.isAfter(mapToAdjust.keys.last)) {
        value = mapToAdjust.values.lastOrNull ?? defaultValue;
      } else if (mapToAdjust[entry.key] != null) {
        value = mapToAdjust[entry.key]!;
      } else {
        final list = [...mapToAdjust.keys, entry.key]..sort();
        final indexOfEntry = list.indexOf(entry.key);
        final prevValue = mapToAdjust[list[(indexOfEntry - 1)]]!;
        value = prevValue;
      }

      adjustedMap[entry.key] = value;
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
    index =
        math.min(math.min(index, data.xAxisDivisions), data.data.length - 1);

    return index;
  }

  /// {@template GridAxisUtils.getRoundedDivisionSize}
  /// Rounding method that calculates and rounds Y axis division size.
  ///
  /// **Please note**: if [GridAxisSettings.yAxisBaseline] is
  /// [YAxisBaseline.zero] and [GridAxisSettings.yAxisDivisions] is `0`, then
  /// `division size` will be calculated as for [YAxisBaseline.axis].
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

    if (settings.yAxisBaseline == YAxisBaseline.axis ||
        settings.yAxisDivisions == 0) {
      final yDivisions = settings.yAxisDivisions + 1;
      final size = div(data.totalValue, yDivisions);
      divisionSize = size;
    }

    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        settings.yAxisDivisions > 0) {
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

    // TODO: implement new method to calculate all 3 params at the same time
    // ! (divisionSize, minValue, maxValue)
    final complement = getRoundingComplement(data.roundingMap, divisionSize);
    var roundedSize = ceilRoundValue(complement, divisionSize);
    if (settings.yAxisBaseline == YAxisBaseline.axis ||
        settings.yAxisDivisions == 0) {
      final minValue = floorRoundValue(complement, data.minValue);
      if (minValue + roundedSize * 4 < data.maxValue) {
        roundedSize += complement;
      }
    }
    cache.saveRoundedDivisionSize(data.hashCode, roundedSize);

    return roundedSize;
  }

  /// {@template GridAxisUtils.getRoundedMinValue}
  /// Rounding method that rounds [data.minValue] or [data.minValueZeroBased]
  /// (based on the [GridAxisSettings.yAxisBaseline]) to achieve beautified
  /// value so, it could be multiplied by [settings.yAxisDivisions].
  ///
  /// **Please note**: if [GridAxisSettings.yAxisBaseline] is
  /// [YAxisBaseline.zero] and [GridAxisSettings.yAxisDivisions] is `0`, then
  /// `min value` will be calculated as for [YAxisBaseline.axis].
  ///
  /// `Example 1`:
  /// - `Input`:
  ///    - `yAxisDivisions` is `2` (2 division lines results with 3 chunks of
  ///       chart)
  ///    - `maxValue` is `83` (from data)
  /// - `Output`:
  ///    - `75`
  ///
  /// `Example 2`:
  /// - `Input`:
  ///    - `yAxisDivisions` is `2` (2 division lines results with 3 chunks of
  ///      chart)
  ///    - `maxValue` is `-83` (from data)
  /// - `Output`:
  ///    - `-90`
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

    final divisionSize = getRoundedDivisionSize(cache, data, settings);

    double minValue = 0;
    if (settings.yAxisBaseline == YAxisBaseline.axis ||
        settings.yAxisDivisions == 0) {
      final complement = getRoundingComplement(data.roundingMap, divisionSize);
      minValue = floorRoundValue(complement, data.minValue);
    }
    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        data.hasNegativeMinValueZeroBased &&
        settings.yAxisDivisions > 0) {
      final divisions = (data.minValueZeroBased.abs() / divisionSize).ceil();
      minValue = -divisionSize * divisions;
    }
    cache.saveRoundedMinValue(data.hashCode, minValue);

    return minValue;
  }

  /// {@template GridAxisUtils.getRoundedMaxValue}
  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with beautified integer chunks.
  ///
  /// **Please note**: if [GridAxisSettings.yAxisBaseline] is
  /// [YAxisBaseline.zero] and [GridAxisSettings.yAxisDivisions] is `0`, then
  /// `max value` will be calculated as for [YAxisBaseline.axis].
  ///
  /// `Example 1`:
  /// - `Input`:
  ///    - `yAxisDivisions` is `2` (2 division lines results with 3 chunks of
  ///       chart)
  ///    - `maxValue` is `83` (from data)
  /// - `Output`:
  ///    - `90`
  ///
  /// `Example 2`:
  /// - `Input`:
  ///    - `yAxisDivisions` is `2` (2 division lines results with 3 chunks of
  ///      chart)
  ///    - `maxValue` is `-83` (from data)
  /// - `Output`:
  ///    - `-75`
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

    final divisionSize = getRoundedDivisionSize(cache, data, settings);

    double maxValue;
    if (settings.yAxisBaseline == YAxisBaseline.zero &&
        data.hasNegativeMinValueZeroBased &&
        settings.yAxisDivisions > 0) {
      final divisions = (data.maxValue.abs() / divisionSize).ceil();
      maxValue = divisionSize * divisions;
    } else {
      final complement = getRoundingComplement(data.roundingMap, divisionSize);
      maxValue = ceilRoundValue(complement, data.maxValue);
    }
    cache.saveRoundedMaxValue(data.hashCode, maxValue);

    return maxValue;
  }
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:meta/meta.dart';

@internal
LineChartCacheHolder cache = LineChartCacheHolder();

@internal
class LineChartCacheHolder {
  factory LineChartCacheHolder() => _instance;
  LineChartCacheHolder._();
  static final _instance = LineChartCacheHolder._();

  /// Cached value of `data.typedData`.
  ///
  /// It is needed to store this cache due to lots of calculations that
  /// "low-end" devices couldn't complete fast enough (escpecially on mobile
  /// devices).
  final _cachedTypedData = <int, Map<DateTime, double>>{};

  /// Cached value of `roundedDivisionSize`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation.
  final _cachedRoundedDivisionSize = <int, double>{};

  /// Cached value of `roundedMaxValue`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation due to usage of `roundedDivisionSize` value.
  final _cachedRoundedMaxValue = <int, double>{};

  /// Cached value of `roundedMinValue`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation due to usage of `roundedDivisionSize` value.
  final _cachedRoundedMinValue = <int, double>{};

  /// Cached value of `point` offset.
  ///
  /// It is needed to store this cache to simplify animation process.
  final _cachedDefaultPointOffset = <int, Offset>{};

  final _dataHashes = <int, int>{};

  /// Mark as added or updated cache based on provided datas.
  void add(int dataHashCode, int? oldDataHashCode) {
    if (oldDataHashCode != null) {
      final boundedHash = _dataHashes[oldDataHashCode];
      if (boundedHash != -1) {
        _cachedTypedData.remove(boundedHash);
        _cachedRoundedDivisionSize.remove(boundedHash);
        _cachedRoundedMaxValue.remove(boundedHash);
        _cachedRoundedMinValue.remove(boundedHash);
        _cachedDefaultPointOffset.remove(boundedHash);
        _dataHashes.remove(boundedHash);
      }
    }

    _dataHashes[dataHashCode] = oldDataHashCode ?? -1;
  }

  /// Saves `typedData` value.
  void saveTypedData(int dataHashCode, Map<DateTime, double> typedData) {
    _cachedTypedData[dataHashCode] = typedData;
  }

  /// Gets `typedData` from cache.
  Map<DateTime, double>? getTypedData(int dataHashCode) {
    return _cachedTypedData[dataHashCode];
  }

  /// Saves `roundedDivisionSize` value.
  void saveRoundedDivisionSize(int dataHashCode, double roundedDivisionSize) {
    _cachedRoundedDivisionSize[dataHashCode] = roundedDivisionSize;
  }

  /// Gets `typedData` from cache.
  double? getRoundedDivisionSize(int dataHashCode) {
    return _cachedRoundedDivisionSize[dataHashCode];
  }

  /// Saves `roundedMaxValue` value.
  void saveRoundedMaxValue(int dataHashCode, double roundedMaxValue) {
    _cachedRoundedMaxValue[dataHashCode] = roundedMaxValue;
  }

  /// Gets `roundedMaxValue` from cache.
  double? getRoundedMaxValue(int dataHashCode) {
    return _cachedRoundedMaxValue[dataHashCode];
  }

  /// Saves `roundedMinValue` value.
  void saveRoundedMinValue(int dataHashCode, double roundedMinValue) {
    _cachedRoundedMinValue[dataHashCode] = roundedMinValue;
  }

  /// Gets `roundedMinValue` from cache.
  double? getRoundedMinValue(int dataHashCode) {
    return _cachedRoundedMinValue[dataHashCode];
  }

  /// Saves `point` offset value.
  void saveDefaultPointOffset(int dataHashCode, Offset offset) {
    _cachedDefaultPointOffset[dataHashCode] = offset;
  }

  /// Gets `point` offset from cache.
  Offset? getDefaultPointOffset(int dataHashCode) {
    return _cachedDefaultPointOffset[dataHashCode];
  }

  /// Clears all cached data.
  void clear() {
    _cachedTypedData.clear();
    _cachedRoundedDivisionSize.clear();
    _cachedRoundedMaxValue.clear();
    _cachedRoundedMinValue.clear();
    _cachedDefaultPointOffset.clear();
    _dataHashes.clear();
  }
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../generic/cache.dart';

class GridAxisCacheHolder extends MDCacheHolder {
  factory GridAxisCacheHolder() => _instance;
  GridAxisCacheHolder._();
  static final _instance = GridAxisCacheHolder._();

  /// Cached value of `roundedDivisionSize`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation.
  final _cachedRoundedDivisionSize = <int, double>{};

  /// Saves `roundedDivisionSize` value.
  void saveRoundedDivisionSize(int dataHashCode, double roundedDivisionSize) {
    _cachedRoundedDivisionSize[dataHashCode] = roundedDivisionSize;
  }

  /// Gets `typedData` from cache.
  double? getRoundedDivisionSize(int dataHashCode) {
    return _cachedRoundedDivisionSize[dataHashCode];
  }

  /// Cached value of `roundedMaxValue`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation due to usage of `roundedDivisionSize` value.
  final _cachedRoundedMaxValue = <int, double>{};

  /// Saves `roundedMaxValue` value.
  void saveRoundedMaxValue(int dataHashCode, double roundedMaxValue) {
    _cachedRoundedMaxValue[dataHashCode] = roundedMaxValue;
  }

  /// Gets `roundedMaxValue` from cache.
  double? getRoundedMaxValue(int dataHashCode) {
    return _cachedRoundedMaxValue[dataHashCode];
  }

  /// Cached value of `roundedMinValue`.
  ///
  /// It is needed to store this cache due to VERY insufficient way of it's
  /// calculation due to usage of `roundedDivisionSize` value.
  final _cachedRoundedMinValue = <int, double>{};

  /// Saves `roundedMinValue` value.
  void saveRoundedMinValue(int dataHashCode, double roundedMinValue) {
    _cachedRoundedMinValue[dataHashCode] = roundedMinValue;
  }

  /// Gets `roundedMinValue` from cache.
  double? getRoundedMinValue(int dataHashCode) {
    return _cachedRoundedMinValue[dataHashCode];
  }

  @override
  List<Map<int, dynamic>> get datas => [
        _cachedRoundedDivisionSize,
        _cachedRoundedMaxValue,
        _cachedRoundedMinValue,
      ];
}

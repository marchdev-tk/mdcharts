// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:meta/meta.dart';

import '../_internal.dart';

@internal
final class LineChartCacheHolder extends GridAxisCacheHolder {
  /// Cached value of `data.typedData`.
  ///
  /// It is needed to store this cache due to lots of calculations that
  /// "low-end" devices couldn't complete fast enough (escpecially on mobile
  /// devices).
  final _cachedTypedData = <int, Map<DateTime, double>>{};

  /// Saves `typedData` value.
  void saveTypedData(int dataHashCode, Map<DateTime, double> typedData) {
    _cachedTypedData[dataHashCode] = typedData;
  }

  /// Gets `typedData` from cache.
  Map<DateTime, double>? getTypedData(int dataHashCode) {
    return _cachedTypedData[dataHashCode];
  }

  /// Cached value of `point` offset.
  ///
  /// It is needed to store this cache to simplify animation process.
  final _cachedDefaultPointOffset = <int, Offset>{};

  /// Saves `point` offset value.
  void saveDefaultPointOffset(int dataHashCode, Offset offset) {
    _cachedDefaultPointOffset[dataHashCode] = offset;
  }

  /// Gets `point` offset from cache.
  Offset? getDefaultPointOffset(int dataHashCode) {
    return _cachedDefaultPointOffset[dataHashCode];
  }

  @override
  List<Map<int, dynamic>> get datas => [
        ...super.datas,
        _cachedTypedData,
        _cachedDefaultPointOffset,
      ];
}

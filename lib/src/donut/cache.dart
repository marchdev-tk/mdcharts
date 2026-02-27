// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import '../_internal.dart';

@internal
DonutChartCacheHolder cache = DonutChartCacheHolder();

@internal
class DonutChartCacheHolder {
  factory DonutChartCacheHolder() => _instance;
  DonutChartCacheHolder._();
  static final _instance = DonutChartCacheHolder._();

  /// Cached value of `Path Holders`.
  final _cachedPathHolders = <int, List<ArcPainterData>>{};

  final _dataHashes = <int, int>{};

  /// Mark as added or updated cache based on provided datas.
  void add(int dataHashCode, int? oldDataHashCode) {
    if (oldDataHashCode != null) {
      final boundedHash = _dataHashes[oldDataHashCode];
      if (boundedHash != -1) {
        _cachedPathHolders.remove(boundedHash);
        _dataHashes.remove(boundedHash);
      }
    }

    _dataHashes[dataHashCode] = oldDataHashCode ?? -1;
  }

  /// Saves the list of `Path Holders`.
  void savePathHolders(
    int dataHashCode,
    List<ArcPainterData> pathHolders,
  ) {
    _cachedPathHolders[dataHashCode] = pathHolders;
  }

  /// Gets list of `Path Holders` from cache.
  List<ArcPainterData>? getPathHolders(int dataHashCode) {
    return _cachedPathHolders[dataHashCode];
  }

  /// Clears all cached data.
  void clear() {
    _cachedPathHolders.clear();
  }
}

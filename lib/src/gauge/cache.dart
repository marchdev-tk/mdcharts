// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:meta/meta.dart';

@internal
GaugeChartCacheHolder cache = GaugeChartCacheHolder();

@internal
class GaugeChartCacheHolder {
  factory GaugeChartCacheHolder() => _instance;
  GaugeChartCacheHolder._();
  static final _instance = GaugeChartCacheHolder._();

  /// Cached value of `Path Holders`.
  final _cachedPathHolders = <int, List<GaugeChartPathDataHolder>>{};

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
    List<GaugeChartPathDataHolder> pathHolders,
  ) {
    _cachedPathHolders[dataHashCode] = pathHolders;
  }

  /// Gets list of `Path Holders` from cache.
  List<GaugeChartPathDataHolder>? getPathHolders(int dataHashCode) {
    return _cachedPathHolders[dataHashCode];
  }

  /// Clears all cached data.
  void clear() {
    _cachedPathHolders.clear();
  }
}

/// Holder object of the start/end angles of the path alongside with path data
/// itself that is mostly required for hit testing.
class GaugeChartPathDataHolder {
  /// Constructs an instance of [GaugeChartPathDataHolder].
  const GaugeChartPathDataHolder(
    this.startAngle,
    this.endAngle,
    this.path,
  );

  /// Start andgle of the path.
  final double startAngle;

  /// End andgle of the path.
  final double endAngle;

  /// Path.
  final Path path;
}

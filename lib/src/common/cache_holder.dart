// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract base class MDCacheHolder {
  final _dataHashes = <int, int>{};

  List<Map<int, dynamic>> get datas;

  /// Mark as added or updated cache based on provided datas.
  void add(int dataHashCode, int? oldDataHashCode) {
    if (oldDataHashCode != null) {
      final boundedHash = _dataHashes[oldDataHashCode];
      if (boundedHash != -1) {
        for (var data in datas) {
          data.remove(boundedHash);
        }
        _dataHashes.remove(boundedHash);
      }
    }

    _dataHashes[dataHashCode] = oldDataHashCode ?? -1;
  }

  /// Clears all cached data.
  void clear() {
    for (var data in datas) {
      data.clear();
    }
    _dataHashes.clear();
  }
}

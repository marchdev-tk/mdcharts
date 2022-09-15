// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Get hash code of map.
int hashMap<K, V>(Map<K, V> map) {
  return map.entries
      .map((entry) => entry.key.hashCode ^ entry.value.hashCode)
      .fold<int>(1, (prev, value) => prev ^ value);
}

// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Signature for callbacks that builds label text based on the provided [key].
typedef LabelBuilder<T> = String Function(T value);

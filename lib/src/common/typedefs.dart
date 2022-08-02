// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';

/// Signature for callbacks that builds label text based on the provided [key].
typedef LabelBuilder<T> = String Function(T value);

/// Signature for callbacks that builds label rich text based on the provided
/// [key]. Also provides style in case if several styles could be used to build
/// the label.
typedef RichLabelBuilder<T> = TextSpan Function(T value, TextStyle style);

/// Signature for indexed predicate.
typedef IndexedPredicate = bool Function(int index);

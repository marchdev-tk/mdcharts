// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Normalization method.
///
/// Converts provided [value] based on [total] into a percentage
/// proportion with valid values in inclusive range [0..1].
double normalize(double value, double total) {
  final normalizedValue = value / total;
  return normalizedValue.isNaN ? 0 : normalizedValue.clamp(.0, 1.0);
}

/// {@template normalizeInverted}
/// Normalization method.
///
/// Converts provided [value] based on [maxValue] into a percentage
/// proportion with valid values in inclusive range [0..1].
///
/// Returns `1 - result`, where `result` was calculated in the previously
/// metioned step.
/// {@endtemplate}
double normalizeInverted(double value, double maxValue) {
  final normalizedValue = 1 - value / maxValue;
  return normalizedValue.isNaN ? 0 : normalizedValue.clamp(.0, 1.0);
}

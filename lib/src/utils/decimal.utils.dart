// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:decimal/decimal.dart';

double mult(num a, num b) {
  final product = Decimal.parse(a.toString()) * Decimal.parse(b.toString());
  return _adjustPrecision(product.toDouble());
}

double div(num a, num b) {
  final quotient = Decimal.parse(a.toString()) / Decimal.parse(b.toString());
  return _adjustPrecision(quotient.toDouble());
}

double sub(num a, num b) {
  final difference = Decimal.parse(a.toString()) - Decimal.parse(b.toString());
  return _adjustPrecision(difference.toDouble());
}

double add(num a, num b) {
  final sum = Decimal.parse(a.toString()) + Decimal.parse(b.toString());
  return _adjustPrecision(sum.toDouble());
}

double _adjustPrecision(double value) {
  final rounded = value.roundToDouble();

  if ((rounded - value).abs() < 0.0000000000001) {
    return rounded;
  }

  return value;
}

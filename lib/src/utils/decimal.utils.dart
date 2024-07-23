// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:decimal/decimal.dart';

double mult(num a, num b) {
  final product = Decimal.parse(a.toString()) * Decimal.parse(b.toString());
  return product.toDouble();
}

double div(num a, num b) {
  final quotient = Decimal.parse(a.toString()) / Decimal.parse(b.toString());
  return quotient.toDouble();
}

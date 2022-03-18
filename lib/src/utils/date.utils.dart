// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

extension DateTimeExtension on DateTime {
  DateTime get date => DateTime(year, month, day);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth => DateTime(year, month + 1, -1);
  DateTime get previousDay => add(const Duration(days: -1));

  bool get isStartOfMonth => day == 1;
}

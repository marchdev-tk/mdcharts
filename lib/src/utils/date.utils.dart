// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Set of extension on [DateTime].
extension DateTimeExtension on DateTime {
  /// Gets date part of the [DateTime] omitting time part.
  DateTime get date => DateTime(year, month, day);

  /// Gets start of the month omitting time part.
  DateTime get startOfMonth => DateTime(year, month);

  /// Gets end of the month omitting time part.
  DateTime get endOfMonth => DateTime(year, month + 1, -1);

  /// Gets previous day omitting time part.
  DateTime get previousDay => add(const Duration(days: -1));

  /// Whether this date is a start of the month or not.
  bool get isStartOfMonth => day == 1;
}

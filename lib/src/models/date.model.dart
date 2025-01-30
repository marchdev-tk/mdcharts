// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MdDate implements Comparable<MdDate> {
  const MdDate(this.year, this.month, this.day) : assert(year >= 0);

  final int year;
  final int month;
  final int day;

  // Month constants that are returned by the [month] getter.
  static const int january = 1;
  static const int february = 2;
  static const int march = 3;
  static const int april = 4;
  static const int may = 5;
  static const int june = 6;
  static const int july = 7;
  static const int august = 8;
  static const int september = 9;
  static const int october = 10;
  static const int november = 11;
  static const int december = 12;
  static const int monthsPerYear = 12;

  // static const _monthDayQuantity = <int, int>{
  //   january: 31,
  //   february: 28,
  //   march: 31,
  //   april: 30,
  //   may: 31,
  //   june: 30,
  //   july: 31,
  //   august: 31,
  //   september: 30,
  //   october: 31,
  //   november: 30,
  //   december: 31,
  // };

  /// Gets start of the month.
  MdDate get startOfMonth => _convertDate(year, month, 1);

  /// Gets end of the month.
  MdDate get endOfMonth => _convertDate(year, month + 1, 0);

  /// Gets previous day.
  MdDate get previousDay => _convertDate(year, month, day - 1);

  /// Whether this date is a start of the month or not.
  bool get isStartOfMonth => day == 1;

  // int _getDaysInMonth(int year, int month) {
  //   int monthDayQty = _monthDayQuantity[month]!;
  //   if (month == february && year % 4 == 0) {
  //     monthDayQty = monthDayQty + 1;
  //   }

  //   return monthDayQty;
  // }

  MdDate _convertDate(int year, int month, int day) {
    // int localYear = year;
    // int localMonth = month;
    // int localDay = day;

    // int monthDayQty = _getDaysInMonth(localYear, localMonth);

    // if (localDay == 0) {
    //   monthDayQty = _getDaysInMonth(localYear, localMonth - 1);
    //   localDay =
    // }

    // TODO: implement date conversion

    return MdDate(year, month, day);
  }

  @override
  int compareTo(MdDate other) {
    final comparedYear = year.compareTo(other.year);
    if (comparedYear != 0) {
      return comparedYear;
    }

    final comparedMonth = month.compareTo(other.month);
    if (comparedMonth != 0) {
      return comparedMonth;
    }

    final comparedDay = day.compareTo(other.day);
    if (comparedDay != 0) {
      return comparedDay;
    }

    return 0;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MdDate &&
            year == other.year &&
            month == other.month &&
            day == other.day;
  }
}

extension DateTimeExtension on DateTime {
  DateTime get date => DateTime(year, month, day);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth => DateTime(year, month + 1, -1);
  DateTime get previousDay => add(const Duration(days: -1));

  bool get isStartOfMonth => day == 1;
}

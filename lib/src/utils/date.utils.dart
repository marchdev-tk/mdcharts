extension DateTimeExtension on DateTime {
  DateTime get date => DateTime(year, month, day);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth => DateTime(year, month + 1, -1);
}

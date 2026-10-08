extension DatetimeX on DateTime {
  bool get isToday {
    final d = DateTime.now();
    if (month == d.month && day == d.day) {
      return true;
    }
    return false;
  }
}

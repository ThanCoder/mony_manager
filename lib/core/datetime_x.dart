extension DatetimeX on DateTime {
  bool get isToday {
    final d = DateTime.now();
    if (thisMonth && day == d.day) {
      return true;
    }
    return false;
  }

  bool get thisYear {
    final d = DateTime.now();
    if (year == d.year) {
      return true;
    }
    return false;
  }

  bool get thisMonth {
    final d = DateTime.now();
    if (thisYear && month == d.month) {
      return true;
    }
    return false;
  }
}

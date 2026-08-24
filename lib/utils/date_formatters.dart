String formatDate(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0'); 
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$month/$day/${dateTime.year}';
} // transformare data in format MM/DD/YYYY sub forma de listare in timeline, ex: 01/15/2024  

String formatTime(DateTime dateTime) {
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  final hourValue = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final hour = hourValue.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}

String formatTimelineHeader(DateTime dateTime) {
  return '${_weekdayName(dateTime.weekday)}, ${dateTime.day} '
      '${_monthName(dateTime.month)} ${dateTime.year}';
}

String _weekdayName(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'MONDAY';
    case DateTime.tuesday:
      return 'TUESDAY';
    case DateTime.wednesday:
      return 'WEDNESDAY';
    case DateTime.thursday:
      return 'THURSDAY';
    case DateTime.friday:
      return 'FRIDAY';
    case DateTime.saturday:
      return 'SATURDAY';
    case DateTime.sunday:
      return 'SUNDAY';
  }

  return '';
}

String _monthName(int month) {
  switch (month) {
    case DateTime.january:
      return 'JANUARY';
    case DateTime.february:
      return 'FEBRUARY';
    case DateTime.march:
      return 'MARCH';
    case DateTime.april:
      return 'APRIL';
    case DateTime.may:
      return 'MAY';
    case DateTime.june:
      return 'JUNE';
    case DateTime.july:
      return 'JULY';
    case DateTime.august:
      return 'AUGUST';
    case DateTime.september:
      return 'SEPTEMBER';
    case DateTime.october:
      return 'OCTOBER';
    case DateTime.november:
      return 'NOVEMBER';
    case DateTime.december:
      return 'DECEMBER';
  }

  return '';
}

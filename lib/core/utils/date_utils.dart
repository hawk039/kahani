class DateFormatter {
  static const List<String> _monthAbbreviations = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static String formatToMonthDayYear(DateTime dateTime) {
    try {
      final month = _monthAbbreviations[dateTime.month - 1];
      final day = dateTime.day;
      final year = dateTime.year;
      return '$month $day, $year';
    } catch (e) {
      // Fallback for any unexpected error, like an invalid month index.
      return dateTime.toIso8601String().split('T').first;
    }
  }
}

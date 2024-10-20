import 'package:intl/intl.dart';

String getDateTitle(DateTime date) {
  DateTime today = DateTime.now();
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (isSameDay(date, today)) {
    return 'Today';
  } else if (isSameDay(date, yesterday)) {
    return 'Yesterday';
  } else {
    return formatDate(date);
  }
}
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}


String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

DateTime parseDate(String dateString) {
  try {
    // Parsing the date in yyyy-MM-dd format
    return DateFormat('yyyy-MM-dd').parse(dateString);
  } catch (e) {
    return DateTime.now(); // Fallback to current date on failure
  }
}

//Capitalize
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}


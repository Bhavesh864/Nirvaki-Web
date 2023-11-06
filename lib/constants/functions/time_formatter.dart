import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../methods/date_time_methods.dart';

class TimeFormatter {
  static String formatFirestoreTimestamp(Timestamp? firestoreTimestamp, bool isSameWeek) {
    if (firestoreTimestamp == null) {
      return '';
    }

    final timestamp = firestoreTimestamp.toDate();
    final DateTime now = DateTime.now();
    final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (isSameDay(timestamp, now)) {
      return 'Today at ${_formatTime(timestamp)}';
    } else if (isSameDay(timestamp, yesterday)) {
      return 'Yesterday at ${_formatTime(timestamp)}';
    } else if (!isSameWeek) {
      return '${DateFormat('EEEE').format(firestoreTimestamp.toDate())} at ${_formatTime(timestamp)}';
    } else {
      // For older dates, return the date and time in a custom format
      final day = timestamp.day;
      final month = timestamp.month;
      final year = timestamp.year;

      // Format the date as "DD MMM YYYY at HH:MM AM/PM"
      final formattedDate = '$day ${_getMonthName(month)} $year at ${_formatTime(timestamp)}';
      return formattedDate;
    }
  }

  static String _getMonthName(int month) {
    // List of month names
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Ensure the month value is within valid bounds
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }

    return '';
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour < 12 ? 'AM' : 'PM';

    final formattedHour = hourOf12HourFormat(hour);
    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  static int hourOf12HourFormat(int hour) {
    if (hour == 0) {
      return 12;
    } else if (hour > 12) {
      return hour - 12;
    } else {
      return hour;
    }
  }
}

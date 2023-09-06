import 'package:cloud_firestore/cloud_firestore.dart';

class TimeFormatter {
  static String formatFirestoreTimestamp(Timestamp? firestoreTimestamp) {
    if (firestoreTimestamp == null) {
      return '';
    }
    final timestamp = firestoreTimestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(timestamp)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(timestamp)}';
    } else {
      return '${difference.inDays} days ago';
    }
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

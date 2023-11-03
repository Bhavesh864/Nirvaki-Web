import 'package:intl/intl.dart';

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

String formatMessageDate(DateTime date) {
  final DateFormat formatter = DateFormat('d MMMM y');
  return formatter.format(date);
}

String getMessageDay(DateTime messageTime, bool isNewWeek) {
  final DateTime now = DateTime.now();
  final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (isSameDay(messageTime, now)) {
    return 'Today';
  } else if (isSameDay(messageTime, yesterday)) {
    return 'Yesterday';
  } else if (!isNewWeek) {
    // Show the day name if it's a new week
    return DateFormat('EEEE').format(messageTime); // Requires intl package
  } else {
    // Show the date if it's not a new week
    return DateFormat('dd MMMM yyyy').format(messageTime); // Requires intl package
  }
}

String formatTimestamp(DateTime timestamp) {
  final formattedTime = DateFormat.jm().format(timestamp);
  return formattedTime;
}

 // String formatTimestamp(DateTime timestamp) {
  //   final formattedTime = DateFormat.jm().format(timestamp); // Format to 'hh:mm a'
  //   return formattedTime;
  // }

  // String formatTimestamp(DateTime timestamp) {
  //   final now = DateTime.now();
  //   final difference = now.difference(timestamp);

  //   if (difference.inDays == 0) {
  //     if (difference.inHours == 0) {
  //       if (difference.inMinutes < 5) {
  //         return 'Just now';
  //       }
  //       return '${difference.inMinutes} minutes ago';
  //     } else {
  //       return '${difference.inHours} hours ago';
  //     }
  //   } else if (difference.inDays == 1) {
  //     return 'Yesterday';
  //   } else {
  //     return DateFormat.yMMMd().format(timestamp);
  //   }
  // }
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/widgets/calendar_view.dart';

import '../../constants/functions/calendar/calendar_functions.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CalendarItems> appointments) {
    this.appointments = appointments;
  }

  getCalendarEvent(int index) => appointments![index] as CalendarItems;

  @override
  DateTime getStartTime(int index) {
    final calendarEvent = getCalendarEvent(index);
    DateFormat inputFormat = DateFormat('E, MMM d, y');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.dueDate);
    } catch (_) {
      final DateFormat alternativeFormat = DateFormat('dd-MM-yyyy');
      date = alternativeFormat.parse(calendarEvent.dueDate);
    }

    String customTime = calendarEvent.time ?? '1:20 AM';
    DateFormat customTimeFormat = DateFormat('hh:mm aa');

    try {
      DateTime customDateTime = customTimeFormat.parse(customTime);

      date = DateTime(
        date.year,
        date.month,
        date.day,
        customDateTime.hour,
        customDateTime.minute,
      );
    } catch (e) {
      print('Error parsing custom time: $e');
    }

    return date;
  }

  @override
  DateTime getEndTime(int index) {
    final calendarEvent = getCalendarEvent(index);
    DateFormat inputFormat = DateFormat('E, MMM d, y');

    DateTime date;
    try {
      date = inputFormat.parse(calendarEvent.dueDate);
    } catch (_) {
      final DateFormat alternativeFormat = DateFormat('dd-MM-yyyy');
      date = alternativeFormat.parse(calendarEvent.dueDate);
    }

    String customTime = calendarEvent.time ?? '4:20 AM';
    DateFormat customTimeFormat = DateFormat('hh:mm aa');

    try {
      DateTime customDateTime = customTimeFormat.parse(customTime).add(const Duration(hours: 3));

      date = DateTime(
        date.year,
        date.month,
        date.day,
        customDateTime.hour,
        customDateTime.minute,
      );
    } catch (e) {
      print('Error parsing custom time: $e');
    }

    return date;
  }

  @override
  String getSubject(int index) => getCalendarEvent(index).calenderTitle;

  @override
  Color getColor(int index) => getColorForTaskType("Meeting");
}

// class CustomEventDataSource extends CalendarDataSource {
//   CustomEventDataSource(List<CalendarItems> appointments) {
//     this.appointments = appointments;
//   }

//   getCalendarEvent(int index) => appointments![index] as CalendarItems;

//   @override
//   DateTime getStartTime(int index) {
//     DateFormat inputFormat = DateFormat('E, MMM d, y');
//     DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

//     // Replace the time part with your custom time (assuming customTime is in HH:mm aa format)
//     String customTime = getCalendarEvent(index).time;
//     DateFormat customTimeFormat = DateFormat('hh:mm aa');

//     try {
//       DateTime customDateTime = customTimeFormat.parse(customTime);

//       date = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         customDateTime.hour,
//         customDateTime.minute,
//       );
//     } catch (e) {
//       print('Error parsing custom time: $e');
//     }

//     return date;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     DateFormat inputFormat = DateFormat('E, MMM d, y');
//     DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

//     // Replace the time part with your custom time (assuming customTime is in HH:mm aa format)
//     String customTime = getCalendarEvent(index).time;
//     DateFormat customTimeFormat = DateFormat('hh:mm aa');

//     try {
//       DateTime customDateTime = customTimeFormat.parse(customTime).add(const Duration(hours: 3));

//       date = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         customDateTime.hour,
//         customDateTime.minute,
//       );
//     } catch (e) {
//       print('Error parsing custom time: $e');
//     }

//     return date;
//   }

//   @override
//   String getSubject(int index) => getCalendarEvent(index).calenderTitle;

//   @override
//   Color getColor(int index) => getColorForTaskType("Meeting");

//   @override
//   bool isAllDay(int index) => false;
// }

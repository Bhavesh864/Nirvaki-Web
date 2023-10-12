import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants/firebase/calenderModel/calender_model.dart';
import '../../constants/functions/calendar/calendar_functions.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CalendarModel> appointments) {
    this.appointments = appointments;
  }

  getCalendarEvent(int index) => appointments![index] as CalendarModel;

  @override
  DateTime getStartTime(int index) {
    DateFormat inputFormat = DateFormat('E, MMM d, y');
    DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

    String customTime = getCalendarEvent(index).time;
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
    DateFormat inputFormat = DateFormat('E, MMM d, y');
    DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

    // Replace the time part with your custom time (assuming customTime is in HH:mm aa format)
    String customTime = getCalendarEvent(index).time;
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

  @override
  bool isAllDay(int index) => false;
}

class CustomEventDataSource extends CalendarDataSource {
  CustomEventDataSource(List<CalendarModel> appointments) {
    this.appointments = appointments;
  }

  getCalendarEvent(int index) => appointments![index] as CalendarModel;

  @override
  DateTime getStartTime(int index) {
    DateFormat inputFormat = DateFormat('E, MMM d, y');
    DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

    // Replace the time part with your custom time (assuming customTime is in HH:mm aa format)
    String customTime = getCalendarEvent(index).time;
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
    DateFormat inputFormat = DateFormat('E, MMM d, y');
    DateTime date = inputFormat.parse(getCalendarEvent(index).dueDate);

    // Replace the time part with your custom time (assuming customTime is in HH:mm aa format)
    String customTime = getCalendarEvent(index).time;
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

  @override
  bool isAllDay(int index) => false;

  @override
  List<CalendarModel> getAppointments(DateTime startDate, DateTime endDate) {
    List filteredAppointments = [];

    for (var appointment in appointments!) {
      if (appointment.startTime.isAfter(startDate) && appointment.startTime.isBefore(endDate)) {
        // Filter appointments for each time slot to show only two
        var sameTimeSlotAppointments = appointments!.where((a) => a.startTime == appointment.startTime && a.endTime == appointment.endTime);

        if (sameTimeSlotAppointments.length <= 2) {
          filteredAppointments.addAll(sameTimeSlotAppointments);
        } else {
          // If there are more than two appointments, add the top two based on your criteria
          var topTwoAppointments = sameTimeSlotAppointments.take(2);
          filteredAppointments.addAll(topTwoAppointments);
        }
      }
    }

    return filteredAppointments as List<CalendarModel>;
  }
}

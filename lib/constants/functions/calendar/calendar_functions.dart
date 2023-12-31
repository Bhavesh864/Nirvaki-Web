import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/widgets/calendar_view.dart';

import '../../../Customs/snackbar.dart';
import '../../../riverpodstate/user_data.dart';
import '../../firebase/calenderModel/calender_model.dart';
import '../../firebase/random_uid.dart';
import '../../firebase/userModel/user_info.dart';
import '../../utils/colors.dart';
import '../../validation/basic_validation.dart';

Color getColorForTaskType(String taskType) {
  // Implement logic to map task types to colors here
  if (taskType == "Meeting") {
    return Colors.orange; // Return the color for meetings
  } else if (taskType == "Event") {
    return Colors.green; // Return the color for events
  } else if (taskType == "Appointment") {
    return Colors.red; // Return the color for appointments
  }
  // You can add more cases for other task types
  // or provide a default color if needed.
  return AppColor.primary;
}

Color getRandomColorForTaskType(String taskType) {
  // Define a list of predefined colors
  List<Color> colors = [
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
    Colors.indigo,
  ];

  // Generate a random index to select a color from the list
  int randomIndex = Random().nextInt(colors.length);

  // Return the randomly selected color
  return colors[randomIndex];
}

String toDate(DateTime dateTime) {
  final date = DateFormat.yMMMEd().format(dateTime);

  return date;
}

String toTime(DateTime dateTime) {
  final date = DateFormat('hh:mm a').format(dateTime);

  return date;
}

Future<DateTime?> pickDateTime(DateTime initialDate, {required BuildContext context, required bool pickDate, DateTime? firstDate}) async {
  if (pickDate) {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (date == null) return null;

    final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

    return date.add(time);
  } else {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (timeOfDay == null) return null;

    final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
    final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

    return date.add(time);
  }
}

Future pickFromDateTime({
  required DateTime pickedDate,
  required bool pickDate,
  required BuildContext context,
  required TextEditingController? dateController,
  required TextEditingController timeController,
}) async {
  final date = await pickDateTime(pickedDate, pickDate: pickDate, context: context);

  if (pickDate) {
    pickedDate = date!;
    dateController!.text = toDate(date);
  } else {
    timeController.text = toTime(date!);
  }
}

void addCalenderDatatoFirebase({
  required String title,
  required String description,
  required String dueDate,
  required String time,
  required WidgetRef ref,
}) {
  final User? user = ref.read(userDataProvider);
  final CalendarModel calendarModel = CalendarModel(
    calenderTitle: title,
    calenderDescription: description,
    calenderType: "Meeting",
    id: generateUid(),
    dueDate: dueDate,
    time: time,
    userId: user?.userId,
    brokerId: user?.brokerId,
    managerId: user?.managerid,
  );

  CalendarModel.addCalendarModel(calendarModel);
}

void onAddTask({
  required WidgetRef ref,
  required BuildContext context,
  required TextEditingController dateController,
  required TextEditingController timeController,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
}) {
  addCalenderDatatoFirebase(
    title: removeExtraSpaces(titleController.text),
    description: removeExtraSpaces(descriptionController.text),
    dueDate: dateController.text.trim(),
    time: timeController.text.trim(),
    ref: ref,
  );
  titleController.clear();
  descriptionController.clear();
  dateController.clear();
  timeController.clear();
  customSnackBar(context: context, text: 'Item added successfully!');
}

void onDeleteTask({
  required BuildContext context,
  required TextEditingController dateController,
  required TextEditingController timeController,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
  required CalendarItems calendarModel,
}) {
  CalendarModel.deleteCalendarModel(calendarModel.id!);
  titleController.clear();
  descriptionController.clear();
  dateController.clear();
  timeController.clear();

  customSnackBar(context: context, text: 'Item deleted successfully!');
}

void onUpdateTask({
  required BuildContext context,
  required TextEditingController dateController,
  required TextEditingController timeController,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
  required CalendarItems calendarModel,
}) {
  final CalendarModel updatedModel = CalendarModel(
    id: calendarModel.id,
    calenderType: 'Meeting',
    brokerId: calendarModel.brokerId,
    userId: calendarModel.userId,
    managerId: calendarModel.managerId,
    calenderTitle: removeExtraSpaces(titleController.text),
    calenderDescription: removeExtraSpaces(descriptionController.text),
    dueDate: dateController.text,
    time: timeController.text,
  );
  CalendarModel.updateCalendarModel(updatedModel);
  titleController.clear();
  descriptionController.clear();
  dateController.clear();
  timeController.clear();
  customSnackBar(context: context, text: 'Item updated successfully!');
}

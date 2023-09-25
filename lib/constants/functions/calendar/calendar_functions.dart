import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../Customs/snackbar.dart';
import '../../../riverpodstate/user_data.dart';
import '../../firebase/calenderModel/calender_model.dart';
import '../../firebase/random_uid.dart';
import '../../firebase/userModel/user_info.dart';
import '../../utils/colors.dart';

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
  required TextEditingController dateController,
  required TextEditingController timeController,
}) async {
  final date = await pickDateTime(pickedDate, pickDate: pickDate, context: context);

  if (pickDate) {
    pickedDate = date!;
    dateController.text = toDate(date);
  } else {
    // pickedTime = date!;
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
    title: titleController.text.trim(),
    description: descriptionController.text.trim(),
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
  required CalendarModel calendarModel,
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
  required CalendarModel calendarModel,
}) {
  final CalendarModel updatedModel = CalendarModel(
    id: calendarModel.id,
    calenderType: 'Meeting',
    brokerId: calendarModel.brokerId,
    userId: calendarModel.userId,
    managerId: calendarModel.managerId,
    calenderTitle: titleController.text,
    calenderDescription: descriptionController.text,
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

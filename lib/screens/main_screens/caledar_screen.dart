import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:yes_broker/constants/firebase/calenderModel/calender_model.dart';
import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/constants/functions/workitems_detail_methods.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../constants/firebase/userModel/user_info.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<CalenderModel> appointments) {
    this.appointments = appointments;
  }

  getCalendarEvent(int index) => appointments![index] as CalenderModel;

  @override
  DateTime getStartTime(int index) {
    DateFormat inputFormat = DateFormat('E, MMM d, y');
    return inputFormat.parse(getCalendarEvent(index).dueDate);
  }

  // @override
  // DateTime getEndTime(int index) {
  //   DateFormat inputFormat = DateFormat('E, MMM d, y');
  //   return inputFormat.parse(getCalendarEvent(index).dueDate).add(const Duration(hours: 3));
  // }

  @override
  String getSubject(int index) => getCalendarEvent(index).calenderTitle;

  @override
  Color getColor(int index) => AppColor.primary.withOpacity(0.5);
}

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _displayedMonth;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  void addCalenderDatatoFirebase({
    required String title,
    required String description,
    required String dueDate,
    required String time,
  }) {
    final User user = ref.read(userDataProvider);
    final CalenderModel calenderModel = CalenderModel(
      calenderTitle: title,
      calenderDescription: description,
      calenderType: "Meeting",
      id: generateUid(),
      dueDate: dueDate,
      time: time,
      userId: user.userId,
      brokerId: user.brokerId,
      managerId: user.managerid,
    );

    CalenderModel.addCalenderModel(calenderModel);
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.read(userDataProvider);

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('calenderDetails').where('brokerId', isEqualTo: user.brokerId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData) {
            final dataList = snapshot.data!.docs;
            List<CalenderModel> calenderList = dataList.map((doc) => CalenderModel.fromSnapshot(doc)).toList();
            final List<CalenderModel> selectedEvents = calenderList;
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SfCalendar(
                      // headerHeight: 0,
                      dataSource: EventDataSource(selectedEvents),
                      view: CalendarView.day,
                      allowedViews: const [
                        CalendarView.day,
                        CalendarView.week,
                      ],
                      showDatePickerButton: true,
                      timeSlotViewSettings: const TimeSlotViewSettings(startHour: 8, endHour: 24),
                      initialDisplayDate: selectedDate,
                      appointmentBuilder: (context, calendarAppointmentDetails) {
                        final event = calendarAppointmentDetails.appointments.first;

                        return Container(
                          height: calendarAppointmentDetails.bounds.height,
                          width: calendarAppointmentDetails.bounds.width,
                          decoration: BoxDecoration(
                            color: AppColor.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              event.calenderTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      showTodayButton: true,
                      showNavigationArrow: true,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColor.primary,
                            ),
                            onPressed: _previousMonth,
                          ),
                          Text(
                            DateFormat.yMMMM().format(_displayedMonth),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.primary,
                            ),
                            onPressed: _nextMonth,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 240,
                        child: Center(
                          child: SfCalendar(
                            onLongPress: (calendarLongPressDetails) {
                              selectedDate = calendarLongPressDetails.date!;
                            },
                            headerHeight: 0,
                            dataSource: EventDataSource(calenderList),
                            cellBorderColor: Colors.transparent,
                            view: CalendarView.month,
                            controller: CalendarController(),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      CustomButton(
                        text: 'Create new',
                        onPressed: () {
                          showAddCalendarModal(
                            context,
                            titleController,
                            dateController,
                            timeController,
                            descriptionController,
                            () {
                              addCalenderDatatoFirebase(
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                dueDate: dateController.text.trim(),
                                time: timeController.text.trim(),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}

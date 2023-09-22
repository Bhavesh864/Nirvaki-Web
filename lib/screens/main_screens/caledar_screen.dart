import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/functions/workitems_detail_methods.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../constants/firebase/calenderModel/calender_model.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/calendar/calendar_functions.dart';
import '../../widgets/calendar/event_data.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _displayedMonth;
  DateTime selectedDate = DateTime.now();
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
      selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
      selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.read(userDataProvider);
    print(user?.email);
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              title: const CustomText(
                title: 'Calendar',
              ),
            )
          : null,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('calenderDetails').where('brokerId', isEqualTo: user?.brokerId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasData) {
              final dataList = snapshot.data!.docs;
              List<CalendarModel> calenderList = dataList.map((doc) => CalendarModel.fromSnapshot(doc)).toList();

              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SfCalendar(
                        showCurrentTimeIndicator: false,
                        dataSource: EventDataSource(calenderList),
                        view: CalendarView.day,
                        showDatePickerButton: true,
                        timeSlotViewSettings: const TimeSlotViewSettings(startHour: 8, endHour: 24),
                        initialDisplayDate: selectedDate,
                        showTodayButton: true,
                        showNavigationArrow: true,
                        backgroundColor: Colors.white,
                        allowedViews: const [
                          CalendarView.day,
                          CalendarView.week,
                        ],
                        onTap: (details) {
                          if (details.appointments == null) return;
                          final CalendarModel event = details.appointments!.first;
                          showAddCalendarModal(
                            context: context,
                            isEdit: true,
                            calendarModel: event,
                            ref: ref,
                          );
                        },
                        appointmentBuilder: (context, calendarAppointmentDetails) {
                          final event = calendarAppointmentDetails.appointments.first;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: calendarAppointmentDetails.bounds.height,
                            width: calendarAppointmentDetails.bounds.width,
                            decoration: BoxDecoration(
                              color: getColorForTaskType('').withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                event.calenderTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (!Responsive.isMobile(context)) ...[
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
                                DateFormat.yMMMM().format(selectedDate),
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
                                onTap: (calendarLongPressDetails) {
                                  selectedDate = calendarLongPressDetails.date!;
                                  setState(() {});
                                },
                                headerHeight: 0,
                                initialDisplayDate: selectedDate,
                                initialSelectedDate: selectedDate,
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
                            height: 40,
                            width: 160,
                            text: 'Create new +',
                            onPressed: () {
                              showAddCalendarModal(
                                context: context,
                                isEdit: false,
                                ref: ref,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ]
                ],
              );
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}

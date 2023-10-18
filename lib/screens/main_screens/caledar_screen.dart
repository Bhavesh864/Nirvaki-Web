import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/Customs/custom_text.dart';

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
      selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.read(userDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
                size: 24,
              ),
              centerTitle: false,
              titleSpacing: 0,
              title: const CustomText(
                title: 'Calendar',
                fontWeight: FontWeight.w600,
                size: 18,
                letterSpacing: 0.5,
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
                        viewHeaderHeight: Responsive.isMobile(context) ? 0 : -1,
                        showTodayButton: Responsive.isMobile(context) ? false : true,
                        showNavigationArrow: Responsive.isMobile(context) ? false : true,
                        backgroundColor: Colors.white,
                        allowedViews: Responsive.isMobile(context)
                            ? null
                            : [
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 0 : 8),
                            height: calendarAppointmentDetails.bounds.height,
                            width: calendarAppointmentDetails.bounds.width,
                            decoration: BoxDecoration(
                              color: getColorForTaskType('Appointment').withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                event.calenderTitle,
                                maxLines: 1,
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
                    const VerticalDivider(
                      indent: 15,
                      width: 30,
                    ),
                    Expanded(
                      flex: Responsive.isTablet(context) ? 2 : 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF989898),
                                  ),
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
                            Center(
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

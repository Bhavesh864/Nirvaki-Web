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
import '../../constants/functions/calendar/calendar_functions.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../widgets/assigned_circular_images.dart';
import '../../widgets/calendar/event_data.dart';
import '../../widgets/calendar_view.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _displayedMonth;
  DateTime selectedDate = DateTime.now();
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  CalendarController firstCalendarController = CalendarController();
  CalendarController secondCalendarController = CalendarController();

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
          stream: mergeCalendarEventsAndTodo(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasData) {
              List<CalendarItems> calenderList = snapshot.data!;
              // List<CalendarModel> calenderList = dataList.map((doc) => CalendarModel.fromSnapshot(doc)).toList();

              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SfCalendar(
                          controller: firstCalendarController,
                          showCurrentTimeIndicator: false,
                          dataSource: EventDataSource(calenderList),
                          view: CalendarView.day,
                          allowAppointmentResize: false,
                          selectionDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                          showDatePickerButton: true,
                          timeSlotViewSettings: const TimeSlotViewSettings(),
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

                            final CalendarItems event = details.appointments!.first;

                            if (event.calenderType == 'Todo') {
                              navigateBasedOnId(context, event.id!, ref);
                              return;
                            }

                            showAddCalendarModal(
                              context: context,
                              isEdit: true,
                              calendarModel: event,
                              ref: ref,
                            );
                          },
                          appointmentBuilder: (context, calendarAppointmentDetails) {
                            final CalendarItems event = calendarAppointmentDetails.appointments.first;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 0 : 8),
                              height: calendarAppointmentDetails.bounds.height,
                              width: calendarAppointmentDetails.bounds.width,
                              decoration: BoxDecoration(
                                color: getColorForTaskType('').withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(maxWidth: 200),
                                      child: Text(
                                        event.calenderTitle!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (event.calenderType == 'Todo')
                                      Padding(
                                        padding: EdgeInsets.only(right: event.todoDetails!.assignedto!.length > 1 ? 0 : 8),
                                        child: AssignedCircularImages(
                                          cardData: event.todoDetails,
                                          heightOfCircles: 26,
                                          widthOfCircles: 26,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
                                controller: secondCalendarController,
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

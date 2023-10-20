import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/Customs/loader.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/screens/main_screens/caledar_screen.dart';
import '../constants/firebase/calenderModel/calender_model.dart';
import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/calendar/calendar_functions.dart';
import '../constants/functions/workitems_detail_methods.dart';
import '../riverpodstate/user_data.dart';
import 'calendar/event_data.dart';

class CustomCalendarView extends ConsumerStatefulWidget {
  const CustomCalendarView({super.key});

  @override
  ConsumerState<CustomCalendarView> createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends ConsumerState<CustomCalendarView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> calenderDetails;
  @override
  void initState() {
    super.initState();
    getCalenderDetailsfunc();
  }

  void getCalenderDetailsfunc() {
    final User? user = ref.read(userDataProvider);
    calenderDetails = FirebaseFirestore.instance.collection('calenderDetails').where('brokerId', isEqualTo: user?.brokerId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: calenderDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          final dataList = snapshot.data!.docs;
          List<CalendarModel> calenderList = dataList.map((doc) => CalendarModel.fromSnapshot(doc)).toList();

          return Container(
            decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (Responsive.isMobile(context)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CalendarScreen();
                          },
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 0 : 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          title: 'Calendar',
                          fontWeight: FontWeight.w600,
                          size: 15,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showAddCalendarModal(
                                  context: context,
                                  isEdit: false,
                                  ref: ref,
                                );
                              },
                              child: const Icon(
                                Icons.add,
                                size: 24,
                              ),
                            ),
                            const Icon(
                              Icons.more_horiz,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: kIsWeb && !Responsive.isMobile(context) ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    height: Responsive.isMobile(context) ? 180 : height! * 0.25,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SfCalendar(
                          initialDisplayDate: DateTime.now(),
                          controller: CalendarController(),
                          headerHeight: 0,
                          dataSource: EventDataSource(calenderList),
                          view: CalendarView.timelineDay,
                          timeSlotViewSettings: TimeSlotViewSettings(
                            startHour: 9,
                            endHour: 24,
                            timeTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w600, 0.7),
                            ),
                            timelineAppointmentHeight: Responsive.isMobile(context) ? 70 : 60,
                          ),

                          backgroundColor: Colors.white,
                          allowAppointmentResize: true,
                          showDatePickerButton: false,
                          viewHeaderHeight: 0,

                          // headerStyle: const CalendarHeaderStyle(
                          //   textAlign: TextAlign.center,
                          //   backgroundColor: Colors.amber,
                          // ),
                          // appointmentTimeTextFormat: Intl.defaultLocale,
                          appointmentBuilder: (context, calendarAppointmentDetails) {
                            final CalendarModel event = calendarAppointmentDetails.appointments.first;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: calendarAppointmentDetails.bounds.height,
                              decoration: BoxDecoration(
                                color: AppColor.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 4,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: getColorForTaskType('Meeting'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      event.calenderTitle.toString(),
                                      // maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

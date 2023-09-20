import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';

import 'package:yes_broker/screens/main_screens/caledar_screen.dart';

import '../constants/firebase/calenderModel/calender_model.dart';
import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/calendar/calendar_functions.dart';
import '../constants/functions/workitems_detail_methods.dart';
import '../customs/loader.dart';
import '../riverpodstate/user_data.dart';
import 'calendar/event_data.dart';

class CustomCalendarView extends ConsumerStatefulWidget {
  const CustomCalendarView({super.key});

  @override
  ConsumerState<CustomCalendarView> createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends ConsumerState<CustomCalendarView> {
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
            List<CalendarModel> calenderList = dataList.map((doc) => CalendarModel.fromSnapshot(doc)).toList();

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CalendarScreen();
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            title: 'Calendar',
                            fontWeight: FontWeight.w600,
                          ),
                          Row(
                            children: [
                              GestureDetector(
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 175,
                      child: SfCalendar(
                        headerHeight: 0,
                        dataSource: EventDataSource(calenderList),
                        view: CalendarView.timelineWeek,
                        timeSlotViewSettings: const TimeSlotViewSettings(startHour: 9, endHour: 24),
                        showTodayButton: true,
                        showNavigationArrow: true,
                        backgroundColor: Colors.white,
                        allowAppointmentResize: true,
                        appointmentBuilder: (context, calendarAppointmentDetails) {
                          final event = calendarAppointmentDetails.appointments.first;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            height: calendarAppointmentDetails.bounds.height,
                            width: 500,
                            decoration: BoxDecoration(
                              color: getColorForTaskType(event.calenderType).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class CustomCalendarView extends StatefulWidget {
//   CustomCalendarView({Key? key}) : super(key: key);

//   @override
//   _CustomCalendarViewState createState() => _CustomCalendarViewState();
// }

// class _CustomCalendarViewState extends State<CustomCalendarView> {
//   late MeetingDataSource _events;
//   late List<Appointment> _shiftCollection;

//   late List<CalendarResource> _employeeCalendarResource;

//   @override
//   void initState() {
//     addResourceDetails();
//     addAppointments();
//     addSpecialRegions();
//     _events = MeetingDataSource(_shiftCollection);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             body: SfCalendar(
//       view: CalendarView.timelineWorkWeek,
//       firstDayOfWeek: 1,
//       timeSlotViewSettings:
//           const TimeSlotViewSettings(startHour: 9, endHour: 18),
//       dataSource: _events,
//     )));
//   }

//   void addAppointments() {
//     var subjectCollection = [
//       'General Meeting',
//       'Plan Execution',
//       'Project Plan',
//       'Consulting',
//       'Support',
//       'Development Meeting',
//       'Scrum',
//       'Project Completion',
//       'Release updates',
//       'Performance Check'
//     ];

//     var colorCollection = [
//       const Color(0xFF0F8644),
//       const Color(0xFF8B1FA9),
//       const Color(0xFFD20100),
//       const Color(0xFFFC571D),
//       const Color(0xFF85461E),
//       const Color(0xFF36B37B),
//       const Color(0xFF3D4FB5),
//       const Color(0xFFE47C73),
//       const Color(0xFF636363)
//     ];

//     _shiftCollection = <Appointment>[];
//     for (var calendarResource in _employeeCalendarResource) {
//       var employeeIds = [calendarResource.id];

//       for (int j = 0; j < 365; j++) {
//         for (int k = 0; k < 2; k++) {
//           final DateTime date = DateTime.now().add(Duration(days: j + k));
//           int startHour = 9 + Random().nextInt(6);
//           startHour =
//               startHour >= 13 && startHour <= 14 ? startHour + 1 : startHour;
//           final DateTime _shiftStartTime =
//               DateTime(date.year, date.month, date.day, startHour, 0, 0);
//           _shiftCollection.add(Appointment(
//               startTime: _shiftStartTime,
//               endTime: _shiftStartTime.add(const Duration(hours: 1)),
//               subject: subjectCollection[Random().nextInt(8)],
//               color: colorCollection[Random().nextInt(8)],
//               startTimeZone: '',
//               endTimeZone: '',
//               resourceIds: employeeIds));
//         }
//       }
//     }
//   }

//   void addResourceDetails() {
//     var nameCollection = [
//       'John',
//       'Bryan',
//       'Robert',
//       'Kenny',
//       'Tia',
//       'Theresa',
//       'Edith',
//       'Brooklyn',
//       'James William',
//       'Sophia',
//       'Elena',
//       'Stephen',
//       'Zoey Addison',
//       'Daniel',
//       'Emilia',
//       'Kinsley Elena',
//       'Danieals',
//       'William',
//       'Addison',
//       'Ruby'
//     ];

//     var userImages = [
//       'images/People_Circle5.png',
//       'images/People_Circle8.png',
//       'images/People_Circle18.png',
//       'images/People_Circle23.png',
//       'images/People_Circle25.png',
//       'images/People_Circle20.png',
//       'images/People_Circle13.png',
//       'images/People_Circle11.png',
//       'images/People_Circle27.png',
//       'images/People_Circle26.png',
//       'images/People_Circle24.png',
//       'images/People_Circle15.png',
//     ];

//     _employeeCalendarResource = <CalendarResource>[];
//     for (var i = 0; i < nameCollection.length; i++) {
//       _employeeCalendarResource.add(CalendarResource(
//           id: '000' + i.toString(),
//           displayName: nameCollection[i],
//           color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
//               Random().nextInt(255), 1),
//           image:
//               i < userImages.length ? ExactAssetImage(userImages[i]) : null));
//     }
//   }

//   void addSpecialRegions() {
//     final DateTime date = DateTime.now();
//     // _specialTimeRegions = [
//     //   TimeRegion(
//     //       startTime: DateTime(date.year, date.month, date.day, 13, 0, 0),
//     //       endTime: DateTime(date.year, date.month, date.day, 14, 0, 0),
//     //       text: 'Lunch',
//     //       resourceIds: _employeeCalendarResource.map((e) => e.id).toList(),
//     //       recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
//     //       enablePointerInteraction: false)
//     // ];
//   }
// }

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> shiftCollection) {
//     appointments = shiftCollection;
//   }
// }

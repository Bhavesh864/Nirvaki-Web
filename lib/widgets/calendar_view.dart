// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:rxdart/rxdart.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/loader.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/calendar_items/controller/calendar_controller.dart';
import 'package:yes_broker/screens/main_screens/caledar_screen.dart';
import 'package:yes_broker/widgets/assigned_circular_images.dart';

import '../constants/firebase/calenderModel/calender_model.dart';
import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/calendar/calendar_functions.dart';
import '../constants/functions/navigation/navigation_functions.dart';
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
    // mergeCalendarTodo();
  }

  void getCalenderDetailsfunc() {
    final User? user = ref.read(userDataProvider);
    calenderDetails = FirebaseFirestore.instance.collection('calenderDetails').where('brokerId', isEqualTo: user?.brokerId).snapshots(includeMetadataChanges: true);
  }

  mergeCalendarTodo() {
    final User? currentUserdata = ref.read(userDataProvider);

    Stream<List<CalendarModel>> calendarStream = calenderDetails.map((querySnapshot) {
      List<CalendarModel> calendarList = [];
      // ignore: unused_local_variable
      for (var doc in querySnapshot.docs) {
        CalendarModel calendarModel = CalendarModel();
        calendarList.add(calendarModel);
      }
      return calendarList;
    });

    Stream<List<CardDetails>> cardDetailStream = calenderDetails.map((querySnapshot) {
      List<CardDetails> cardList = [];
      // ignore: unused_local_variable
      for (var doc in querySnapshot.docs) {
        CardDetails cardModel = CardDetails(workitemId: doc['workitemId'], status: 'NEW', createdate: Timestamp.now(), brokerid: currentUserdata?.brokerId);
        cardList.add(cardModel);
      }
      return cardList;
    });

    final mergeList = Rx.combineLatest2<List<CalendarModel>, List<CardDetails>, List<dynamic>>(calendarStream, cardDetailStream, (calendarData, cardData) {
      final list = [];

      list.addAll(calendarData);
      list.addAll(cardData);
      return list;
    });
    return mergeList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mergeCalendarEventsAndTodo(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          List<CalendarItems> calenderList = snapshot.data!;
          // List<CalendarModel> calenderList = dataList.map((doc) => CalendarModel.fromSnapshot(doc)).toList();

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
                        // physics: const NeverScrollableScrollPhysics(),
                        child: SfCalendar(
                          initialSelectedDate: DateTime.now(),
                          initialDisplayDate: DateTime.now(),
                          headerHeight: 0,
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
                          dataSource: EventDataSource(calenderList),
                          view: CalendarView.timelineDay,
                          timeSlotViewSettings: TimeSlotViewSettings(
                            timeTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.lerp(
                                FontWeight.w400,
                                FontWeight.w600,
                                0.7,
                              ),
                            ),
                            timelineAppointmentHeight: Responsive.isMobile(context) ? 70 : 60,
                          ),
                          backgroundColor: Colors.white,
                          allowAppointmentResize: false,
                          selectionDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                          showDatePickerButton: false,
                          viewHeaderHeight: 0,
                          appointmentBuilder: (context, calendarAppointmentDetails) {
                            final CalendarItems event = calendarAppointmentDetails.appointments.first;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: calendarAppointmentDetails.bounds.height,
                              decoration: BoxDecoration(
                                color: AppColor.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 4,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: getColorForTaskType(''),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 100,
                                        ),
                                        child: Text(
                                          event.calenderTitle.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (event.calenderType == 'Todo')
                                    Padding(
                                      padding: EdgeInsets.only(right: event.todoDetails!.assignedto!.length > 1 ? 0 : 8),
                                      child: AssignedCircularImages(
                                        cardData: event.todoDetails,
                                        heightOfCircles: 20,
                                        widthOfCircles: 20,
                                      ),
                                    )
                                ],
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

class CalendarItems {
  String? id;
  String? calenderTitle;
  String? calenderDescription;
  String? calenderType;
  String? userId;
  String? brokerId;
  String? managerId;
  String? dueDate;
  String? time;
  CardDetails? todoDetails;

  CalendarItems({
    this.id,
    this.calenderTitle,
    this.calenderDescription,
    this.calenderType,
    this.userId,
    this.brokerId,
    this.managerId,
    this.dueDate,
    this.time,
    this.todoDetails,
  });
}

Stream<List<CalendarItems>> mergeCalendarEventsAndTodo(WidgetRef ref) {
  final calendarEventsList = ref.watch(calendarControllerProvider).calendarEvents();
  final cardDetailsList = ref.watch(calendarControllerProvider).cardDetails(ref);

  final mergedStream = Rx.combineLatest2(
    calendarEventsList,
    cardDetailsList,
    (List<CalendarModel>? calendarEvents, List<CardDetails>? todoItems) {
      final calendarItems = <CalendarItems>[];

      if (calendarEvents != null) {
        calendarItems.addAll(
          calendarEvents.map(
            (calendarItem) => CalendarItems(
              id: calendarItem.id,
              calenderTitle: calendarItem.calenderTitle,
              calenderDescription: calendarItem.calenderDescription,
              calenderType: calendarItem.calenderType,
              userId: calendarItem.userId,
              brokerId: calendarItem.brokerId,
              managerId: calendarItem.managerId,
              dueDate: calendarItem.dueDate,
              time: calendarItem.time,
            ),
          ),
        );
      }

      if (todoItems != null) {
        calendarItems.addAll(
          todoItems.map(
            (todoItem) => CalendarItems(
              id: todoItem.workitemId,
              calenderTitle: todoItem.cardTitle,
              calenderDescription: todoItem.cardDescription,
              calenderType: "Todo",
              userId: todoItem.brokerid,
              brokerId: todoItem.brokerid,
              managerId: todoItem.managerid,
              dueDate: todoItem.duedate,
              time: todoItem.dueTime,
              todoDetails: todoItem,
            ),
          ),
        );
      }

      return calendarItems;
    },
  );

  return mergedStream;
}

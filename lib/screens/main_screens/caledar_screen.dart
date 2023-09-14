import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/constants/functions/workitems_detail_methods.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_fields.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SfCalendar(
              // headerHeight: 0,
              view: CalendarView.day,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
              ],
              showDatePickerButton: true,
              timeSlotViewSettings: const TimeSlotViewSettings(startHour: 8, endHour: 24),
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
                    headerHeight: 0,
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
                  showAddCalendarModal(context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

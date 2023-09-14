import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yes_broker/constants/utils/colors.dart';

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
          flex: 3,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Center(
              child: SfCalendar(
                headerHeight: 0,
                view: CalendarView.week,
                timeSlotViewSettings: const TimeSlotViewSettings(startHour: 9, endHour: 18),
                showTodayButton: true,
                showNavigationArrow: true,
                backgroundColor: Colors.white,
              ),
            ),
          ),
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
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Center(
                  child: SfCalendar(
                    headerHeight: 0,
                    view: CalendarView.month,
                    controller: CalendarController(),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
